import 'dart:ui';

import 'package:craftaria_map/craftaria_map.dart';
import 'package:flame/components.dart';
import 'package:world_renderer/src/tile_renderer.dart';

/// Renders the layers of a [MapChunk] that sit either below entities or,
/// when [overlay] is true, above them.
///
/// The tiles are recorded into a [Picture] once on load, so a chunk costs a
/// single draw call per frame.
class ChunkComponent extends PositionComponent {
  /// Creates a [ChunkComponent] placed at the chunk's world position.
  ChunkComponent({
    required this.chunk,
    required this.tileRenderer,
    this.overlay = false,
    super.priority,
  }) : super(
         position: Vector2(
           (chunk.coord.cx * chunkSize * tileSize).toDouble(),
           (chunk.coord.cy * chunkSize * tileSize).toDouble(),
         ),
         size: Vector2.all((chunkSize * tileSize).toDouble()),
       );

  /// The chunk being drawn.
  final MapChunk chunk;

  /// Draws each tile.
  final TileRenderer tileRenderer;

  /// Whether this component draws the layers above entities.
  final bool overlay;

  Picture? _picture;

  /// Whether the chunk has any layer for this component to draw.
  bool get hasLayers =>
      chunk.layers.any((layer) => layer.aboveEntities == overlay);

  @override
  Future<void> onLoad() async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    for (final layer in chunk.layers) {
      if (layer.aboveEntities != overlay) continue;
      for (var y = 0; y < chunkSize; y++) {
        for (var x = 0; x < chunkSize; x++) {
          tileRenderer.render(
            canvas,
            layer.tileAt(x, y),
            Rect.fromLTWH(
              (x * tileSize).toDouble(),
              (y * tileSize).toDouble(),
              tileSize.toDouble(),
              tileSize.toDouble(),
            ),
          );
        }
      }
    }
    _picture = recorder.endRecording();
  }

  @override
  void render(Canvas canvas) {
    final picture = _picture;
    if (picture != null) canvas.drawPicture(picture);
  }

  @override
  void onRemove() {
    _picture?.dispose();
    _picture = null;
    super.onRemove();
  }
}
