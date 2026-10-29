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

  /// Blocking pine tree.
  static const pine = 16;

  /// Blocking birch tree.
  static const birch = 17;

  /// Blocking ironwood tree.
  static const ironwood = 18;

  /// Blocking stump of a cut pine.
  static const pineStump = 19;

  /// Blocking stump of a cut birch.
  static const birchStump = 20;

  /// Blocking stump of a cut ironwood.
  static const ironwoodStump = 21;

  static const Set<int> _solid = {
    water,
    stone,
    pine,
    birch,
    ironwood,
    pineStump,
    birchStump,
    ironwoodStump,
  };

  static const Set<int> _trees = {pine, birch, ironwood};

  /// Whether [id] is a tree that can be cut.
  static bool isTree(int id) => _trees.contains(id);

  /// Whether tiles with [id] block movement.
  static bool isSolid(int id) => _solid.contains(id);
}
