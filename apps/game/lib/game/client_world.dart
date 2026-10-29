import 'dart:async';

import 'package:craftaria/game/player_status.dart';
import 'package:craftaria_map/craftaria_map.dart';
import 'package:craftaria_protocol/craftaria_protocol.dart';
import 'package:craftaria_sim/craftaria_sim.dart';
import 'package:game_client/game_client.dart';

/// Longest frame the fixed-step loop catches up on, so a stalled tab does
/// not replay seconds of input at once.
const maxFrameSeconds = 0.25;

/// Layer holding resource nodes such as trees.
const resourceLayer = 'decoration';

typedef _Walk = ({PathWalker walker, Tile target});

/// The client's view of the world: loaded chunks, the predicted local player
/// and interpolated remote players. Free of rendering so it can be tested.
class ClientWorld {
  /// Creates a [ClientWorld] fed by [client].
  ClientWorld({required GameClient client, Stopwatch? clock})
    : _client = client,
      _clock = (clock ?? Stopwatch())..start() {
    _subscription = client.messages.listen(handle, onError: (_) {});
  }

  final GameClient _client;
  final Stopwatch _clock;
  late final StreamSubscription<ServerMessage> _subscription;

  /// Chunks received so far.
  final ChunkMap chunks = ChunkMap();

  final _newChunks = <MapChunk>[];
  final _remotes = <String, InterpolationBuffer>{};
  final _statusChanges = StreamController<PlayerStatus>.broadcast();
  final _notices = StreamController<NoticeCode>.broadcast();
  PredictedPlayer? _localPlayer;
  String? _localPlayerId;
  double _accumulator = 0;
  PlayerStatus _status = const PlayerStatus();
  ActionState? _action;
  _Walk? _walk;
  int _serverTick = 0;
  Duration _serverTickAt = Duration.zero;

  /// The local player's items, skills and action.
  PlayerStatus get status => _status;

  /// Emits [status] whenever it changes.
  Stream<PlayerStatus> get statusChanges => _statusChanges.stream;

  /// Things the player should be told, such as why gathering stopped.
  Stream<NoticeCode> get notices => _notices.stream;

  /// Whether the player is walking to a target on their own.
  bool get isWalking => _walk != null;

  /// Progress of the current action cycle from 0 to 1, or null when idle.
  double? get actionProgress {
    final action = _action;
    if (action == null || action.durationTicks == 0) return null;
    final elapsed = _clock.elapsed - _serverTickAt;
    final tick = _serverTick + elapsed.inMicroseconds / (tickSeconds * 1000000);
    return ((tick - action.startTick) / action.durationTicks).clamp(0, 1);
  }

  /// Id of the local player, once welcomed.
  String? get localPlayerId => _localPlayerId;

  /// The predicted local player, once welcomed.
  PredictedPlayer? get localPlayer => _localPlayer;

  /// Ids of the other players currently visible.
  Iterable<String> get remotePlayerIds => _remotes.keys;

  /// Chunks received or changed since the last call. A changed chunk
  /// replaces the one with the same coordinates.
  List<MapChunk> takeNewChunks() {
    final chunks = List.of(_newChunks);
    _newChunks.clear();
    return chunks;
  }

  /// Where to draw the local player, interpolated between simulation ticks.
  Position? get localRenderPosition {
    final player = _localPlayer;
    if (player == null) return null;
    return Position.lerp(
      player.previous,
      player.position,
      _accumulator / tickSeconds,
    );
  }

  /// Where to draw the remote player [id] now.
  Position? remotePosition(String id) => _remotes[id]?.sample(_clock.elapsed);

  /// Acts on the world tile ([tileX], [tileY]), as when it is clicked: a tree
  /// is walked to and gathered from, anything else cancels what the player
  /// is doing.
  void interact(int tileX, int tileY) {
    final player = _localPlayer;
    if (player == null) return;
    final target = (x: tileX, y: tileY);
    final path =
        TileId.isTree(chunks.tileAt(tileX, tileY, layer: resourceLayer))
        ? findPathNextTo(
            start: (
              x: floorDiv(player.position.x, tileSubpixels),
              y: floorDiv(player.position.y, tileSubpixels),
            ),
            target: target,
            isBlocked: chunks.isBlocked,
          )
        : null;
    if (path == null) {
      cancel();
      return;
    }
    _walk = (
      walker: PathWalker(path: path, isBlocked: chunks.isBlocked),
      target: target,
    );
  }

  /// Stops walking and the current action.
  void cancel() {
    _walk = null;
    if (_action != null) _client.sendCancelAction();
  }

  /// Equips the tool in inventory [slot].
  void equip(int slot) => _client.sendEquip(slot);

  /// Development only: asks the server for items.
  void debugGrantItem(String itemId, int count) =>
      _client.sendDebugGrantItem(itemId, count);

  /// Development only: asks the server for XP.
  void debugGrantXp(String skillId, int amount) =>
      _client.sendDebugGrantXp(skillId, amount);

  /// Advances the fixed-step simulation by [dt] seconds. Movement [keys]
  /// override and cancel walking to a target.
  void update(double dt, MoveIntent keys) {
    final player = _localPlayer;
    if (player == null) return;

    _accumulator += dt.clamp(0, maxFrameSeconds);
    while (_accumulator >= tickSeconds) {
      _accumulator -= tickSeconds;
      final intent = _tickIntent(player, keys);
      if (intent.isIdle) {
        // Idle ticks are not sent: the server only needs movement.
        player.hold();
        continue;
      }
      final input = player.apply(intent);
      _client.sendMove(seq: input.seq, dx: intent.dx, dy: intent.dy);
    }
  }

  /// Keyboard movement wins over walking and cancels it.
  MoveIntent _tickIntent(PredictedPlayer player, MoveIntent keys) {
    final walk = _walk;
    if (!keys.isIdle || walk == null) {
      _walk = null;
      return keys;
    }
    final intent = walk.walker.next(player.position);
    if (walk.walker.arrived) {
      _walk = null;
      _client.sendGather(
        seq: player.reserveSeq(),
        tileX: walk.target.x,
        tileY: walk.target.y,
      );
    } else if (walk.walker.stuck) {
      _walk = null;
    }
    return intent;
  }

  /// Applies a server message.
  void handle(ServerMessage message) {
    switch (message.whichPayload()) {
      case ServerMessage_Payload.welcome:
        final welcome = message.welcome;
        _localPlayerId = welcome.playerId;
        _localPlayer = PredictedPlayer(
          position: Position(welcome.spawn.x, welcome.spawn.y),
          isBlocked: chunks.isBlocked,
        );
        _setStatus(
          _status.copyWith(
            items: {
              for (final item in welcome.items)
                item.id: ItemInfo(
                  id: item.id,
                  name: item.name,
                  maxStack: item.maxStack,
                ),
            },
          ),
        );
      case ServerMessage_Payload.chunk:
        final chunk = MapChunk.fromProto(message.chunk.chunk);
        chunks.put(chunk);
        _newChunks.add(chunk);
      case ServerMessage_Payload.snapshot:
        _applySnapshot(message.snapshot);
      case ServerMessage_Payload.inventory:
        final inventory = message.inventory;
        _setStatus(
          _status.copyWith(
            slots: [for (final slot in inventory.slots) _slotFrom(slot)],
            equipped: () =>
                inventory.equipped.isEmpty ? null : inventory.equipped,
          ),
        );
      case ServerMessage_Payload.skill:
        final skill = message.skill;
        _setStatus(
          _status.copyWith(
            skills: {
              ..._status.skills,
              skill.skillId: SkillProgress.fromProto(skill),
            },
          ),
        );
      case ServerMessage_Payload.action:
        final action = message.action;
        _action = action.kind.isEmpty ? null : action;
        _setStatus(_status.copyWith(gathering: _action != null));
      case ServerMessage_Payload.tile:
        final tile = message.tile;
        final updated = chunks.setTile(
          ChunkCoord(tile.cx, tile.cy),
          layer: tile.layer,
          index: tile.index,
          tileId: tile.tileId,
          blocked: tile.blocked,
        );
        if (updated != null) _newChunks.add(updated);
      case ServerMessage_Payload.notice:
        _notices.add(message.notice.code);
      case _:
        break;
    }
  }

  static ItemSlot? _slotFrom(ItemStack stack) => stack.itemId.isEmpty
      ? null
      : ItemSlot(itemId: stack.itemId, count: stack.count);

  void _setStatus(PlayerStatus status) {
    if (status == _status) return;
    _status = status;
    _statusChanges.add(status);
  }

  void _applySnapshot(Snapshot snapshot) {
    final now = _clock.elapsed;
    _serverTick = snapshot.tick;
    _serverTickAt = now;
    final seen = <String>{};
    for (final entity in snapshot.entities) {
      final position = Position(entity.position.x, entity.position.y);
      if (entity.id == _localPlayerId) {
        _localPlayer?.reconcile(
          server: position,
          lastInputSeq: snapshot.lastInputSeq,
        );
        continue;
      }
      seen.add(entity.id);
      _remotes
          .putIfAbsent(entity.id, InterpolationBuffer.new)
          .add(now, position);
    }
    _remotes.removeWhere((id, _) => !seen.contains(id));
  }

  /// Stops listening to the server.
  Future<void> dispose() async {
    await _subscription.cancel();
    await _statusChanges.close();
    await _notices.close();
  }
}
