import 'dart:ui';

import 'package:canvas_test/canvas_test.dart';
import 'package:craftaria_map/craftaria_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:world_renderer/world_renderer.dart';

void main() {
  group('DebugTileRenderer', () {
    const destination = Rect.fromLTWH(8, 8, 8, 8);

    test('draws known tiles with their color', () {
      final canvas = MockCanvas();
      DebugTileRenderer().render(canvas, TileId.grass, destination);
      expect(
        canvas,
        MockCanvas()..drawRect(
          destination,
          Paint()..color = DebugTileRenderer.defaultColors[TileId.grass]!,
        ),
      );
    });

    test('draws unknown tiles in magenta', () {
      final canvas = MockCanvas();
      DebugTileRenderer(colors: const {}).render(canvas, 999, destination);
      expect(
        canvas,
        MockCanvas()..drawRect(destination, DebugTileRenderer.unknownPaint),
      );
    });

    test('skips empty tiles', () {
      final canvas = MockCanvas();
      DebugTileRenderer().render(canvas, TileId.empty, destination);
      expect(canvas, MockCanvas());
    });
  });
}
