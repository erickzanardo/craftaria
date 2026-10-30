import 'dart:async';
import 'dart:typed_data';

import 'package:craftaria/game/character/character_look.dart';
import 'package:craftaria/game/client_world.dart';
import 'package:craftaria_map/craftaria_map.dart';
import 'package:craftaria_protocol/craftaria_protocol.dart';
import 'package:craftaria_sim/craftaria_sim.dart';
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

ServerMessage _chunkMessage(int cx, int cy, {List<int> blocked = const []}) {
  final collision = Uint8List(tilesPerChunk ~/ 8);
  for (final index in blocked) {
    collision[index >> 3] |= 1 << (index & 7);
  }
  return ServerMessage(
    chunk: ChunkData(
      chunk: Chunk(
        cx: cx,
        cy: cy,
        collision: collision,
        layers: [TileLayer(name: 'ground', tiles: List.filled(1024, 1))],
      ),
    ),
  );
}

void main() {
  group('ClientWorld', () {
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

    test('can be created with the default clock', () {
      expect(
        () => ClientWorld(client: mockGameClient(StreamController())),
        returnsNormally,
      );
    });

    test('creates the local player on welcome', () {
      expect(world.localPlayer, isNull);
      expect(world.localRenderPosition, isNull);

      world.handle(welcome(x: 10, y: 20));

      expect(world.localPlayerId, equals('me'));
      expect(world.localPlayer!.position, equals(const Position(10, 20)));
      expect(world.localRenderPosition, equals(const Position(10, 20)));
    });

    test('stores chunks and hands each out once', () {
      world.handle(_chunkMessage(0, 0, blocked: [0]));

      expect(world.chunks.isBlocked(0, 0), isTrue);
      expect(world.takeNewChunks().single.coord, const ChunkCoord(0, 0));
      expect(world.takeNewChunks(), isEmpty);
    });

    test('ignores other messages', () {
      world.handle(ServerMessage(pong: Pong()));
      expect(world.localPlayer, isNull);
    });

    test('does nothing before the welcome', () {
      world.update(1, const MoveIntent(1, 0));
      verifyNever(
        () => client.sendMove(
          seq: any(named: 'seq'),
          dx: any(named: 'dx'),
          dy: any(named: 'dy'),
        ),
      );
    });

    test('predicts and sends one input per fixed tick', () {
      world
        ..handle(welcome(x: 0, y: 0))
        ..update(tickSeconds * 2.5, const MoveIntent(1, 0));

      verify(() => client.sendMove(seq: 1, dx: 1, dy: 0)).called(1);
      verify(() => client.sendMove(seq: 2, dx: 1, dy: 0)).called(1);
      expect(
        world.localPlayer!.position,
        equals(const Position(playerSpeed * 2, 0)),
      );
      // Half way into the third tick.
      expect(
        world.localRenderPosition,
        equals(const Position(playerSpeed * 3 ~/ 2, 0)),
      );
    });

    test('does not send idle ticks and settles interpolation', () {
      world
        ..handle(welcome(x: 0, y: 0))
        ..update(tickSeconds, const MoveIntent(1, 0))
        ..update(tickSeconds * 1.5, MoveIntent.idle);

      verify(
        () => client.sendMove(
          seq: any(named: 'seq'),
          dx: any(named: 'dx'),
          dy: any(named: 'dy'),
        ),
      ).called(1);
      expect(world.localRenderPosition, equals(world.localPlayer!.position));
    });

    test('clamps long frames', () {
      world
        ..handle(welcome(x: 0, y: 0))
        ..update(10, const MoveIntent(1, 0));

      final ticks = (maxFrameSeconds / tickSeconds).floor();
      expect(world.localPlayer!.pending, hasLength(ticks));
    });

    test('reconciles the local player from snapshots', () {
      world
        ..handle(welcome(x: 0, y: 0))
        ..update(tickSeconds * 2, const MoveIntent(0, 1))
        ..handle(snapshot({'me': (5, playerSpeed)}, lastInputSeq: 1));

      expect(
        world.localPlayer!.position,
        equals(const Position(5, playerSpeed * 2)),
      );
    });

    test('interpolates remote players and drops those that left', () {
      world.handle(welcome());

      clock.now = const Duration(milliseconds: 1000);
      world.handle(snapshot({'me': (64, 64), 'other': (0, 0)}));
      clock.now = const Duration(milliseconds: 1050);
      world.handle(snapshot({'me': (64, 64), 'other': (100, 0)}));

      expect(world.remotePlayerIds, equals(['other']));
      clock.now = const Duration(milliseconds: 1125);
      expect(world.remotePosition('other'), equals(const Position(50, 0)));
      expect(world.remotePosition('unknown'), isNull);

      world.handle(snapshot({'me': (64, 64)}));
      expect(world.remotePlayerIds, isEmpty);
    });

    test('reads the palette and the created character from the welcome', () {
      world.handle(welcome());
      expect(world.status.palette, equals(testPalette));
      expect(world.status.skinColors, equals(testSkinColors));
      expect(world.status.look, equals(testLook));
      expect(world.lookOf('me'), equals(testLook));

      world.handle(welcome(look: null));
      expect(world.status.look, isNull);
      expect(world.lookOf('me'), isNull);
    });

    test('previews a look on the local player, then creates it', () {
      world.handle(welcome(look: null));
      const look = CharacterLook(skin: 13, shirt: 2, pants: 3);
      world.previewLook = look;
      expect(world.lookOf('me'), equals(look));
      expect(world.status.look, isNull);
      verifyNever(() => client.sendAppearance(any()));

      world.createCharacter(look);
      expect(world.previewLook, isNull);
      expect(world.status.look, equals(look));
      expect(world.lookOf('me'), equals(look));
      verify(() => client.sendAppearance(look.toProto())).called(1);
    });

    test('shows only remote players who have created their character', () {
      world
        ..handle(welcome())
        ..handle(
          snapshot({'me': (0, 0), 'new': (0, 0)}, uncreated: {'me', 'new'}),
        );
      expect(world.remotePlayerIds, isEmpty);
      expect(world.lookOf('new'), isNull);
      // The local player's own look comes from its status.
      expect(world.lookOf('me'), equals(testLook));

      world.handle(snapshot({'me': (0, 0), 'new': (0, 0)}));
      expect(world.remotePlayerIds, equals(['new']));
      expect(world.lookOf('new'), equals(testLook));

      world.handle(snapshot({'me': (0, 0)}));
      expect(world.lookOf('new'), isNull);
    });

    test('listens to the client until disposed', () async {
      messages.add(welcome(playerId: 'streamed'));
      await Future<void>.delayed(Duration.zero);
      expect(world.localPlayerId, equals('streamed'));

      messages.addError(Exception('bad frame'));
      await world.dispose();
      messages.add(welcome(playerId: 'late'));
      await Future<void>.delayed(Duration.zero);
      expect(world.localPlayerId, equals('streamed'));
    });
  });
}
