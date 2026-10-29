// Keep in sync with server/world/src/tiles.ts.

/// Tile ids of the map format. Never renumber an existing id.
abstract final class TileId {
  /// No tile.
  static const empty = 0;

  /// Walkable grass.
  static const grass = 1;

  /// Walkable sand.
  static const sand = 2;

  /// Blocking water.
  static const water = 3;

  /// Blocking stone.
  static const stone = 4;

  /// Blocking tree.
  static const tree = 16;

  static const Set<int> _solid = {water, stone, tree};

  /// Whether tiles with [id] block movement.
  static bool isSolid(int id) => _solid.contains(id);
}
