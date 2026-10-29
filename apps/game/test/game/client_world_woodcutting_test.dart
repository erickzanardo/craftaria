import 'dart:async';
import 'dart:typed_data';

import 'package:craftaria/game/client_world.dart';
import 'package:craftaria/game/player_status.dart';
import 'package:craftaria_map/craftaria_map.dart';
import 'package:craftaria_protocol/craftaria_protocol.dart';
import 'package:craftaria_sim/craftaria_sim.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/helpers.dart';

class _FakeClock extends Fake implements Stopwatch {
  Duration now = Duration.zero;

  @override
  void start() {}

  @override
  Duration get elapsed => now;
}

/// Chunk (0, 0) of grass with pines at [trees] (local tile coordinates).
ServerMessage _forest(List<(int, int)> trees) {
  final decoration = List.filled(tilesPerChunk, 0);
  final collision = Uint8List(tilesPerChunk ~/ 8);
  for (final (x, y) in trees) {
    final index = y * chunkSize + x;
    decoration[index] = TileId.pine;
    collision[index >> 3] |= 1 << (index & 7);
  }
  return ServerMessage(
    chunk: ChunkData(
      chunk: Chunk(
        collision: collision,
        layers: [
          TileLayer(name: 'ground', tiles: List.filled(tilesPerChunk, 1)),
          TileLayer(name: resourceLayer, tiles: decoration),
        ],
      ),
    ),
  );
}

void main() {
  group('ClientWorld woodcutting', () {
    late StreamController<ServerMessage> messages;
    late MockGameClient client;
    late _FakeClock clock;
    late ClientWorld world;

    setUp(() {
      messages = StreamController();
      client = mockGameClient(messages);
      clock = _FakeClock();
      world = ClientWorld(client: client, clock: clock);
    });

    void tickUntilIdle({int maxTicks = 100}) {
      for (var i = 0; i < maxTicks && world.isWalking; i++) {
        world.update(tickSeconds, MoveIntent.idle);
      }
    }

    test('reads item names from the welcome', () {
      world.handle(
        ServerMessage(
          welcome: Welcome(
            playerId: 'me',
            spawn: Vec2(),
            items: [
              ItemDefinition(id: 'pine_log', name: 'Pine log', maxStack: 50),
            ],
          ),
        ),
      );
      expect(
        world.status.items['pine_log'],
        equals(const ItemInfo(id: 'pine_log', name: 'Pine log', maxStack: 50)),
      );
    });

    test('tracks inventory, skills and action, emitting changes', () async {
      final statuses = <PlayerStatus>[];
      world.statusChanges.listen(statuses.add);

      world
        ..handle(
          ServerMessage(
            inventory: InventoryUpdate(
              slots: [
                ItemStack(itemId: 'pine_log', count: 3),
                ItemStack(),
              ],
              equipped: 'stone_axe',
            ),
          ),
        )
        ..handle(
          ServerMessage(
            skill: SkillUpdate(
              skillId: 'woodcutting',
              level: 2,
              xp: Int64(100),
              levelXp: Int64(80),
              nextLevelXp: Int64(166),
            ),
          ),
        )
        ..handle(ServerMessage(action: ActionState(kind: 'gather')))
        // Unchanged status is not emitted again.
        ..handle(ServerMessage(action: ActionState(kind: 'gather')));
      await Future<void>.delayed(Duration.zero);

      expect(statuses, hasLength(3));
      expect(
        world.status.slots,
        equals([const ItemSlot(itemId: 'pine_log', count: 3), null]),
      );
      expect(world.status.equipped, equals('stone_axe'));
      expect(world.status.skills['woodcutting']!.level, equals(2));
      expect(world.status.gathering, isTrue);

      world
        ..handle(ServerMessage(action: ActionState()))
        ..handle(ServerMessage(inventory: InventoryUpdate()));
      expect(world.status.gathering, isFalse);
      expect(world.status.equipped, isNull);
    });

    test('reports action progress against the server tick', () {
      expect(world.actionProgress, isNull);
      clock.now = const Duration(seconds: 1);
      world
        ..handle(ServerMessage(snapshot: Snapshot(tick: 10)))
        ..handle(
          ServerMessage(
            action: ActionState(
              kind: 'gather',
              startTick: 10,
              durationTicks: 20,
            ),
          ),
        );
      expect(world.actionProgress, equals(0));

      clock.now = const Duration(milliseconds: 1500);
      expect(world.actionProgress, closeTo(0.5, 1e-9));

      clock.now = const Duration(seconds: 9);
      expect(world.actionProgress, equals(1));

      world.handle(ServerMessage(action: ActionState(kind: 'gather')));
      expect(world.actionProgress, isNull);
    });

    test('applies tile updates to loaded chunks and redraws them', () {
      world
        ..handle(_forest([(3, 0)]))
        ..takeNewChunks()
        ..handle(
          ServerMessage(
            tile: TileUpdate(
              layer: resourceLayer,
              index: 3,
              tileId: TileId.pineStump,
              blocked: true,
            ),
          ),
        )
        ..handle(ServerMessage(tile: TileUpdate(cx: 9, layer: resourceLayer)));

      expect(
        world.chunks.tileAt(3, 0, layer: resourceLayer),
        equals(TileId.pineStump),
      );
      expect(world.takeNewChunks(), hasLength(1));
    });

    test('forwards notices', () async {
      final notices = <NoticeCode>[];
      world.notices.listen(notices.add);
      world.handle(
        ServerMessage(
          notice: Notice(code: NoticeCode.NOTICE_CODE_INVENTORY_FULL),
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect(notices, equals([NoticeCode.NOTICE_CODE_INVENTORY_FULL]));
    });

    // welcome() spawns the player at the center of tile (0, 0).
    test('walks next to a clicked tree, then gathers after the moves', () {
      world
        ..handle(welcome())
        ..handle(_forest([(4, 0)]))
        ..interact(4, 0);
      expect(world.isWalking, isTrue);

      tickUntilIdle();

      expect(world.isWalking, isFalse);
      final player = world.localPlayer!;
      final moves = player.pending.length;
      expect(moves, greaterThan(0));
      expect(floorDiv(player.position.x, tileSubpixels), equals(3));
      verify(
        () => client.sendGather(seq: moves + 1, tileX: 4, tileY: 0),
      ).called(1);
    });

    test('gathers at once when already next to the tree', () {
      world
        ..handle(welcome())
        ..handle(_forest([(1, 1)]))
        ..interact(1, 1)
        ..update(tickSeconds, MoveIntent.idle);
      verify(() => client.sendGather(seq: 1, tileX: 1, tileY: 1)).called(1);
      verifyNever(
        () => client.sendMove(
          seq: any(named: 'seq'),
          dx: any(named: 'dx'),
          dy: any(named: 'dy'),
        ),
      );
    });

    test('keyboard movement cancels the walk', () {
      world
        ..handle(welcome())
        ..handle(_forest([(6, 0)]))
        ..interact(6, 0)
        ..update(tickSeconds, const MoveIntent(0, 1));
      expect(world.isWalking, isFalse);
      verify(() => client.sendMove(seq: 1, dx: 0, dy: 1)).called(1);
    });

    test('gives up a walk that gets stuck', () {
      world
        ..handle(welcome())
        ..handle(_forest([(6, 0)]))
        ..interact(6, 0)
        // The server puts a stump right in the path.
        ..handle(
          ServerMessage(
            tile: TileUpdate(
              layer: resourceLayer,
              index: 1,
              tileId: TileId.pineStump,
              blocked: true,
            ),
          ),
        );
      tickUntilIdle();
      expect(world.isWalking, isFalse);
      verifyNever(
        () => client.sendGather(
          seq: any(named: 'seq'),
          tileX: any(named: 'tileX'),
          tileY: any(named: 'tileY'),
        ),
      );
    });

    test('clicking anything else cancels walking and the action', () {
      world
        ..interact(0, 0)
        ..handle(welcome())
        ..handle(_forest([(6, 0)]))
        ..interact(6, 0)
        ..interact(2, 2);
      expect(world.isWalking, isFalse);
      verifyNever(client.sendCancelAction);

      world
        ..handle(ServerMessage(action: ActionState(kind: 'gather')))
        ..interact(2, 2);
      verify(client.sendCancelAction).called(1);
    });

    test('does nothing for a tree it cannot reach', () {
      final walled = [
        for (var x = 9; x <= 11; x++) ...[(x, 9), (x, 11)],
        (9, 10),
        (11, 10),
        (10, 10),
      ];
      world
        ..handle(welcome())
        ..handle(_forest(walled))
        ..interact(10, 10);
      expect(world.isWalking, isFalse);
    });

    test('passes equip and debug commands to the client', () {
      world
        ..equip(4)
        ..debugGrantItem('iron_axe', 1)
        ..debugGrantXp('woodcutting', 10);
      verify(() => client.sendEquip(4)).called(1);
      verify(() => client.sendDebugGrantItem('iron_axe', 1)).called(1);
      verify(() => client.sendDebugGrantXp('woodcutting', 10)).called(1);
    });
  });
}
