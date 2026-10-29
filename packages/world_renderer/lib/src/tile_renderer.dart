import 'dart:ui';

import 'package:craftaria_map/craftaria_map.dart';

/// Draws a single tile into a destination rectangle.
///
/// The game ships with [DebugTileRenderer] until real tile art exists; a
/// sprite sheet backed implementation will replace it.
abstract interface class TileRenderer {
  /// Draws the tile [tileId] into [destination].
  void render(Canvas canvas, int tileId, Rect destination);
}

/// Draws every tile as a flat color. Development only, not art.
class DebugTileRenderer implements TileRenderer {
  /// Creates a [DebugTileRenderer], optionally overriding [colors].
  DebugTileRenderer({Map<int, Color> colors = defaultColors})
    : _paints = {
        for (final MapEntry(:key, :value) in colors.entries)
          key: Paint()..color = value,
      };

  /// Colors per tile id.
  static const defaultColors = <int, Color>{
    TileId.grass: Color(0xFF4C9A3B),
    TileId.sand: Color(0xFFD8C27A),
    TileId.water: Color(0xFF2F5FA8),
    TileId.stone: Color(0xFF6E6E6E),
    TileId.pine: Color(0xFF1F4A1A),
    TileId.birch: Color(0xFF8FA86A),
    TileId.ironwood: Color(0xFF3A3050),
    TileId.pineStump: Color(0xFF6B4A2B),
    TileId.birchStump: Color(0xFFB09A78),
    TileId.ironwoodStump: Color(0xFF4A3A3A),
  };

  /// Used for ids missing from the palette so they stand out.
  static final Paint unknownPaint = Paint()..color = const Color(0xFFFF00FF);

  final Map<int, Paint> _paints;

  @override
  void render(Canvas canvas, int tileId, Rect destination) {
    if (tileId == TileId.empty) return;
    canvas.drawRect(destination, _paints[tileId] ?? unknownPaint);
  }
}
