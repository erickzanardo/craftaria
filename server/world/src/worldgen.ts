import type { Chunk } from "@craftaria/protocol";
import { buildChunk, TILES_PER_CHUNK } from "./chunk.ts";
import { CHUNK_SIZE } from "./constants.ts";
import { TileId } from "./tiles.ts";

/** Tiles around the origin kept clear so players always spawn on grass. */
export const HUB_RADIUS = 8;

function hash(seed: number, x: number, y: number): number {
  let h = seed ^ Math.imul(x, 0x27d4eb2d) ^ Math.imul(y, 0x165667b1);
  h = Math.imul(h ^ (h >>> 15), 0x85ebca6b);
  h = Math.imul(h ^ (h >>> 13), 0xc2b2ae35);
  return (h ^ (h >>> 16)) >>> 0;
}

/** Deterministic pseudo random number in [0, 1). */
export function random01(seed: number, x: number, y: number): number {
  return hash(seed, x, y) / 0x100000000;
}

function smooth(t: number): number {
  return t * t * (3 - 2 * t);
}

function valueNoise(seed: number, x: number, y: number, scale: number) {
  const gx = Math.floor(x / scale);
  const gy = Math.floor(y / scale);
  const tx = smooth(x / scale - gx);
  const ty = smooth(y / scale - gy);
  const a = random01(seed, gx, gy);
  const b = random01(seed, gx + 1, gy);
  const c = random01(seed, gx, gy + 1);
  const d = random01(seed, gx + 1, gy + 1);
  const top = a + (b - a) * tx;
  const bottom = c + (d - c) * tx;
  return top + (bottom - top) * ty;
}

/** Terrain height in [0, 1) for a world tile. */
export function heightAt(seed: number, tileX: number, tileY: number): number {
  return (
    valueNoise(seed, tileX, tileY, 24) * 0.7 +
    valueNoise(seed + 1, tileX, tileY, 6) * 0.3
  );
}

function groundFor(height: number): number {
  if (height < 0.3) return TileId.water;
  if (height < 0.36) return TileId.sand;
  if (height < 0.72) return TileId.grass;
  return TileId.stone;
}

export function generateChunk(seed: number, cx: number, cy: number): Chunk {
  const ground = new Array<number>(TILES_PER_CHUNK);
  const decoration = new Array<number>(TILES_PER_CHUNK).fill(TileId.empty);

  for (let ly = 0; ly < CHUNK_SIZE; ly++) {
    for (let lx = 0; lx < CHUNK_SIZE; lx++) {
      const tx = cx * CHUNK_SIZE + lx;
      const ty = cy * CHUNK_SIZE + ly;
      const index = ly * CHUNK_SIZE + lx;
      const inHub = tx * tx + ty * ty <= HUB_RADIUS * HUB_RADIUS;

      const tile = inHub ? TileId.grass : groundFor(heightAt(seed, tx, ty));
      ground[index] = tile;
      if (!inHub && tile === TileId.grass && random01(seed + 2, tx, ty) < 0.04) {
        decoration[index] = TileId.tree;
      }
    }
  }

  return buildChunk(cx, cy, [
    { name: "ground", tiles: ground },
    { name: "decoration", tiles: decoration },
  ]);
}
