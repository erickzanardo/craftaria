import { create } from "@bufbuild/protobuf";
import {
  type Chunk,
  ChunkSchema,
  TileLayerSchema,
} from "@craftaria/protocol";
import { CHUNK_SIZE } from "./constants.ts";
import { floorDiv } from "./movement.ts";
import { isSolidTile } from "./tiles.ts";

export const TILES_PER_CHUNK = CHUNK_SIZE * CHUNK_SIZE;

export interface ChunkCoord {
  readonly cx: number;
  readonly cy: number;
}

export function chunkKey(cx: number, cy: number): string {
  return `${cx},${cy}`;
}

export function chunkOfTile(tileX: number, tileY: number): ChunkCoord {
  return { cx: floorDiv(tileX, CHUNK_SIZE), cy: floorDiv(tileY, CHUNK_SIZE) };
}

export function tileIndex(localX: number, localY: number): number {
  return localY * CHUNK_SIZE + localX;
}

export interface LayerInput {
  readonly name: string;
  readonly tiles: readonly number[];
  readonly aboveEntities?: boolean;
}

/** Builds a chunk, deriving the collision bitset from the layers' tiles. */
export function buildChunk(
  cx: number,
  cy: number,
  layers: readonly LayerInput[],
): Chunk {
  const collision = new Uint8Array(TILES_PER_CHUNK / 8);
  for (const layer of layers) {
    layer.tiles.forEach((id, index) => {
      if (isSolidTile(id)) collision[index >> 3]! |= 1 << (index & 7);
    });
  }

  return create(ChunkSchema, {
    cx,
    cy,
    collision,
    layers: layers.map((layer) =>
      create(TileLayerSchema, {
        name: layer.name,
        tiles: [...layer.tiles],
        aboveEntities: layer.aboveEntities ?? false,
      }),
    ),
  });
}

export function isBlockedInChunk(
  chunk: Chunk,
  localX: number,
  localY: number,
): boolean {
  const index = tileIndex(localX, localY);
  return ((chunk.collision[index >> 3] ?? 0) & (1 << (index & 7))) !== 0;
}

/**
 * Sets one tile of the layer named [layer] and its collision bit, in place.
 * Returns false when the chunk has no such layer.
 */
export function setTileInChunk(
  chunk: Chunk,
  layer: string,
  index: number,
  tileId: number,
): boolean {
  const target = chunk.layers.find((candidate) => candidate.name === layer);
  if (target === undefined) return false;
  target.tiles[index] = tileId;

  const blocked = chunk.layers.some((candidate) =>
    isSolidTile(candidate.tiles[index]!),
  );
  const mask = 1 << (index & 7);
  if (blocked) chunk.collision[index >> 3]! |= mask;
  else chunk.collision[index >> 3]! &= ~mask;
  return true;
}
