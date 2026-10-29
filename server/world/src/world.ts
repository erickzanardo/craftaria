import type { Chunk } from "@craftaria/protocol";
import {
  chunkKey,
  chunkOfTile,
  isBlockedInChunk,
  setTileInChunk,
  tileIndex,
} from "./chunk.ts";
import { CHUNK_SIZE } from "./constants.ts";
import { generateChunk } from "./worldgen.ts";

/** One edited tile, as sent to the players who have its chunk. */
export interface TileChange {
  readonly cx: number;
  readonly cy: number;
  readonly layer: string;
  readonly index: number;
  readonly tileId: number;
  readonly blocked: boolean;
}

/**
 * Source of chunks for a zone. Chunks nobody has edited are generated on
 * demand from the seed; edited chunks will come from storage once world
 * editing exists.
 */
export class World {
  readonly #chunks = new Map<string, Chunk>();

  constructor(readonly seed: number) {}

  chunk(cx: number, cy: number): Chunk {
    const key = chunkKey(cx, cy);
    let chunk = this.#chunks.get(key);
    if (chunk === undefined) {
      chunk = generateChunk(this.seed, cx, cy);
      this.#chunks.set(key, chunk);
    }
    return chunk;
  }

  /** Tile id of a world tile in the layer named [layer], 0 if missing. */
  tileAt(tileX: number, tileY: number, layer: string): number {
    const { cx, cy } = chunkOfTile(tileX, tileY);
    const index = tileIndex(tileX - cx * CHUNK_SIZE, tileY - cy * CHUNK_SIZE);
    const target = this.chunk(cx, cy).layers.find((l) => l.name === layer);
    return target?.tiles[index] ?? 0;
  }

  /**
   * Edits a world tile in place, so players who load the chunk later get the
   * edit. Edits live in memory only for now and are lost on restart.
   */
  setTile(
    tileX: number,
    tileY: number,
    layer: string,
    tileId: number,
  ): TileChange | undefined {
    const { cx, cy } = chunkOfTile(tileX, tileY);
    const index = tileIndex(tileX - cx * CHUNK_SIZE, tileY - cy * CHUNK_SIZE);
    const chunk = this.chunk(cx, cy);
    if (!setTileInChunk(chunk, layer, index, tileId)) return undefined;
    return {
      cx,
      cy,
      layer,
      index,
      tileId,
      blocked: isBlockedInChunk(
        chunk,
        tileX - cx * CHUNK_SIZE,
        tileY - cy * CHUNK_SIZE,
      ),
    };
  }

  readonly isBlocked = (tileX: number, tileY: number): boolean => {
    const { cx, cy } = chunkOfTile(tileX, tileY);
    return isBlockedInChunk(
      this.chunk(cx, cy),
      tileX - cx * CHUNK_SIZE,
      tileY - cy * CHUNK_SIZE,
    );
  };
}
