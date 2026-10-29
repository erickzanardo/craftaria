import type { Chunk } from "@craftaria/protocol";
import { chunkKey, chunkOfTile, isBlockedInChunk } from "./chunk.ts";
import { CHUNK_SIZE } from "./constants.ts";
import { generateChunk } from "./worldgen.ts";

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

  readonly isBlocked = (tileX: number, tileY: number): boolean => {
    const { cx, cy } = chunkOfTile(tileX, tileY);
    return isBlockedInChunk(
      this.chunk(cx, cy),
      tileX - cx * CHUNK_SIZE,
      tileY - cy * CHUNK_SIZE,
    );
  };
}
