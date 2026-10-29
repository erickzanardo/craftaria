import 'dart:typed_data';
import 'dart:ui';

import 'package:craftaria_map/craftaria_map.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:world_renderer/world_renderer.dart';

class _MockCanvas extends Mock implements Canvas {}

class _FakePicture extends Fake implements Picture {}

class _RecordingTileRenderer implements TileRenderer {
  final calls = <(int, Rect)>[];

  @override
  void render(Canvas canvas, int tileId, Rect destination) =>
      calls.add((tileId, destination));
}

MapChunk _chunk() => MapChunk(
  coord: const ChunkCoord(-1, 2),
  layers: [
    ChunkLayer(name: 'ground', tiles: List.filled(tilesPerChunk, 1)),
    ChunkLayer(
      name: 'overlay',
      tiles: List.filled(tilesPerChunk, 2),
      aboveEntities: true,
    ),
  ],
  collision: Uint8List(tilesPerChunk ~/ 8),
);

void main() {
  group('ChunkComponent', () {
    test('is placed at the chunk position in world pixels', () {
      final component = ChunkComponent(
        chunk: _chunk(),
        tileRenderer: _RecordingTileRenderer(),
      );
      expect(component.position, equals(Vector2(-256, 512)));
      expect(component.size, equals(Vector2.all(256)));
    });

    testWithFlameGame('records only the matching layers', (game) async {
      final ground = _RecordingTileRenderer();
      final overlay = _RecordingTileRenderer();

      await game.ensureAddAll([
        ChunkComponent(chunk: _chunk(), tileRenderer: ground),
        ChunkComponent(chunk: _chunk(), tileRenderer: overlay, overlay: true),
      ]);

      expect(ground.calls, hasLength(tilesPerChunk));
      expect(ground.calls.every((call) => call.$1 == 1), isTrue);
      expect(ground.calls[1].$2, equals(const Rect.fromLTWH(8, 0, 8, 8)));
      expect(overlay.calls.every((call) => call.$1 == 2), isTrue);
    });

    test('hasLayers tells whether anything would be drawn', () {
      final chunk = MapChunk(
        coord: const ChunkCoord(0, 0),
        layers: [ChunkLayer(name: 'ground', tiles: const [])],
        collision: Uint8List(0),
      );
      final renderer = _RecordingTileRenderer();
      expect(
        ChunkComponent(chunk: chunk, tileRenderer: renderer).hasLayers,
        isTrue,
      );
      expect(
        ChunkComponent(
          chunk: chunk,
          tileRenderer: renderer,
          overlay: true,
        ).hasLayers,
        isFalse,
      );
    });

    testWithFlameGame('draws the recorded picture while mounted', (game) async {
      registerFallbackValue(_FakePicture());
      final component = ChunkComponent(
        chunk: _chunk(),
        tileRenderer: DebugTileRenderer(),
      );
      final canvas = _MockCanvas();

      component.render(canvas);
      verifyNever(() => canvas.drawPicture(any()));

      await game.ensureAdd(component);
      component.render(canvas);
      verify(() => canvas.drawPicture(any())).called(1);

      game.remove(component);
      await game.ready();
      component.render(canvas);
      verifyNever(() => canvas.drawPicture(any()));
    });
  });
}
