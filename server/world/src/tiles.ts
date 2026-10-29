// Tile ids are part of the map format. Never renumber an existing id.
// Keep in sync with packages/craftaria_map/lib/src/tile_id.dart.

export const TileId = {
  empty: 0,
  grass: 1,
  sand: 2,
  water: 3,
  stone: 4,
  tree: 16,
} as const;

export type TileId = (typeof TileId)[keyof typeof TileId];

const solidTiles: ReadonlySet<number> = new Set([
  TileId.water,
  TileId.stone,
  TileId.tree,
]);

export function isSolidTile(id: number): boolean {
  return solidTiles.has(id);
}
