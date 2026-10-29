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
