import 'dart:async';

import 'package:craftaria/game/components/action_progress_component.dart';
import 'package:craftaria/game/components/player_component.dart';
import 'package:craftaria/game/game.dart';
import 'package:craftaria_map/craftaria_map.dart';
import 'package:craftaria_protocol/craftaria_protocol.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:world_renderer/world_renderer.dart';

import '../helpers/helpers.dart';

ServerMessage _chunk({required bool withOverlay, int cx = 0, int? treeAt}) =>
    ServerMessage(
      chunk: ChunkData(
        chunk: Chunk(
          cx: cx,
          collision: Uint8List(tilesPerChunk ~/ 8),
          layers: [
            TileLayer(name: 'ground', tiles: List.filled(tilesPerChunk, 1)),
            if (treeAt != null)
              TileLayer(
                name: resourceLayer,
                tiles: List.filled(tilesPerChunk, 0)..[treeAt] = TileId.pine,
              ),
            if (withOverlay)
              TileLayer(
                name: 'overlay',
                tiles: List.filled(tilesPerChunk, 0),
                aboveEntities: true,
              ),
          ],
        ),
      ),
    );

void main() {
  late ClientWorld clientWorld;

  setUp(() {
    clientWorld = ClientWorld(client: mockGameClient(StreamController()));
  });

  CraftariaGame createGame() => CraftariaGame(clientWorld: clientWorld);

  group('CraftariaGame', () {
    testWithGame(
      'uses the largest whole zoom that fits the target height',
      createGame,
      (game) async {
        game.onGameResize(Vector2(800, targetViewHeight * 3.5));
        expect(game.camera.viewfinder.zoom, equals(3));

        game.onGameResize(Vector2(100, 50));
        expect(game.camera.viewfinder.zoom, equals(1));
        expect(game.backgroundColor(), equals(const Color(0xFF000000)));
      },
    );

    testWithGame('adds chunk components as chunks arrive', createGame, (
      game,
    ) async {
      clientWorld
        ..handle(_chunk(withOverlay: false))
        ..handle(_chunk(withOverlay: true, cx: 1));
      game.update(0);
      await game.ready();

      final chunks = game.world.children.whereType<ChunkComponent>();
      expect(chunks.where((c) => !c.overlay), hasLength(2));
      expect(chunks.where((c) => c.overlay), hasLength(1));
    });

    testWithGame('replaces the components of a changed chunk', createGame, (
      game,
    ) async {
      clientWorld.handle(_chunk(withOverlay: true));
      game.update(0);
      await game.ready();
      clientWorld.handle(_chunk(withOverlay: false));
      game.update(0);
      await game.ready();

      final chunks = game.world.children.whereType<ChunkComponent>();
      expect(chunks, hasLength(1));
      expect(chunks.single.overlay, isFalse);
    });

    testWithGame('taps act on the world tile under them', createGame, (
      game,
    ) async {
      game.onGameResize(Vector2(320, 180));
      clientWorld
        ..handle(welcome())
        ..handle(_chunk(withOverlay: false, treeAt: 3));
      game.update(0);
      await game.ready();
      game.update(0);

      // The camera centers on the player at (4, 4) px with zoom 1.
      final tree = Vector2(160 + 3 * 8 + 4 - 4, 90);
      game.onTapUp(
        TapUpEvent(
          1,
          game,
          TapUpDetails(
            kind: PointerDeviceKind.mouse,
            globalPosition: tree.toOffset(),
            localPosition: tree.toOffset(),
          ),
        ),
      );
      expect(clientWorld.isWalking, isTrue);

      game.tapAt(Vector2(0, 0));
      expect(clientWorld.isWalking, isFalse);
    });

    testWithGame('shows action progress over the local player', createGame, (
      game,
    ) async {
      clientWorld.handle(welcome());
      game.update(0);
      await game.ready();
      final bar = game.world.children
          .whereType<ActionProgressComponent>()
          .single;
      expect(bar.progress(), isNull);
      expect(bar.locate(), equals(clientWorld.localRenderPosition));
    });

    testWithGame('spawns the local player and follows it', createGame, (
      game,
    ) async {
      clientWorld.handle(welcome(x: 160, y: 320));
      game.update(0);
      await game.ready();
      game.update(0);

      final players = game.world.children.whereType<PlayerComponent>();
      expect(players.single.playerId, equals('me'));
      expect(game.camera.viewfinder.position, equals(Vector2(10, 20)));
    });

    testWithGame('adds and removes remote players', createGame, (game) async {
      clientWorld
        ..handle(welcome())
        ..handle(snapshot({'me': (0, 0), 'other': (16, 16)}));
      game.update(0);
      await game.ready();
      game.update(0);

      expect(game.remotePlayers.keys, equals(['other']));
      expect(game.remotePlayers['other']!.position, equals(Vector2(1, 1)));

      clientWorld.handle(snapshot({'me': (0, 0)}));
      game.update(0);
      await game.ready();

      expect(game.remotePlayers, isEmpty);
      expect(
        game.world.children.whereType<PlayerComponent>().map((p) => p.playerId),
        equals(['me']),
      );
    });

    testWithGame('feeds keyboard input to the world', createGame, (game) async {
      final handled = game.onKeyEvent(
        const KeyDownEvent(
          physicalKey: PhysicalKeyboardKey.keyD,
          logicalKey: LogicalKeyboardKey.keyD,
          timeStamp: Duration.zero,
        ),
        {LogicalKeyboardKey.keyD},
      );
      expect(handled, equals(KeyEventResult.handled));

      final ignored = game.onKeyEvent(
        const KeyDownEvent(
          physicalKey: PhysicalKeyboardKey.keyQ,
          logicalKey: LogicalKeyboardKey.keyQ,
          timeStamp: Duration.zero,
        ),
        {LogicalKeyboardKey.keyQ},
      );
      expect(ignored, equals(KeyEventResult.ignored));
    });
  });
}
