import 'dart:async';

import 'package:craftaria_map/craftaria_map.dart';
import 'package:craftaria_protocol/craftaria_protocol.dart';
import 'package:craftaria_sim/craftaria_sim.dart';
import 'package:game_client/game_client.dart';

/// Longest frame the fixed-step loop catches up on, so a stalled tab does
/// not replay seconds of input at once.
const maxFrameSeconds = 0.25;

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
  PredictedPlayer? _localPlayer;
  String? _localPlayerId;
  double _accumulator = 0;

  /// Id of the local player, once welcomed.
  String? get localPlayerId => _localPlayerId;

  /// The predicted local player, once welcomed.
  PredictedPlayer? get localPlayer => _localPlayer;

  /// Ids of the other players currently visible.
  Iterable<String> get remotePlayerIds => _remotes.keys;

  /// Chunks received since the last call.
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

  /// Advances the fixed-step simulation by [dt] seconds using [intent].
  void update(double dt, MoveIntent intent) {
    final player = _localPlayer;
    if (player == null) return;

    _accumulator += dt.clamp(0, maxFrameSeconds);
    while (_accumulator >= tickSeconds) {
      _accumulator -= tickSeconds;
      if (intent.isIdle) {
        // Idle ticks are not sent: the server only needs movement.
        player.hold();
        continue;
      }
      final input = player.apply(intent);
      _client.sendMove(seq: input.seq, dx: intent.dx, dy: intent.dy);
    }
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
      case ServerMessage_Payload.chunk:
        final chunk = MapChunk.fromProto(message.chunk.chunk);
        chunks.put(chunk);
        _newChunks.add(chunk);
      case ServerMessage_Payload.snapshot:
        _applySnapshot(message.snapshot);
      case _:
        break;
    }
  }

  void _applySnapshot(Snapshot snapshot) {
    final now = _clock.elapsed;
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
  Future<void> dispose() => _subscription.cancel();
}
