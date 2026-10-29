import { describe, expect, it } from "vitest";
import {
  buildChunk,
  CHUNK_SIZE,
  chunkKey,
  chunkOfTile,
  isBlockedInChunk,
  isSolidTile,
  TileId,
  tileIndex,
  TILES_PER_CHUNK,
} from "../src/index.ts";

describe("chunk", () => {
  it("chunkKey joins coordinates", () => {
    expect(chunkKey(-1, 2)).toBe("-1,2");
  });

  it("chunkOfTile floors negative tiles", () => {
    expect(chunkOfTile(0, CHUNK_SIZE - 1)).toEqual({ cx: 0, cy: 0 });
    expect(chunkOfTile(-1, CHUNK_SIZE)).toEqual({ cx: -1, cy: 1 });
  });

  it("buildChunk derives collision from every layer", () => {
    const ground = new Array<number>(TILES_PER_CHUNK).fill(TileId.grass);
    const decoration = new Array<number>(TILES_PER_CHUNK).fill(TileId.empty);
    ground[tileIndex(1, 0)] = TileId.water;
    decoration[tileIndex(5, 9)] = TileId.tree;

    const chunk = buildChunk(3, -4, [
      { name: "ground", tiles: ground },
      { name: "decoration", tiles: decoration, aboveEntities: true },
    ]);

    expect(chunk.cx).toBe(3);
    expect(chunk.cy).toBe(-4);
    expect(chunk.collision).toHaveLength(TILES_PER_CHUNK / 8);
    expect(chunk.layers.map((l) => l.aboveEntities)).toEqual([false, true]);
    expect(isBlockedInChunk(chunk, 0, 0)).toBe(false);
    expect(isBlockedInChunk(chunk, 1, 0)).toBe(true);
    expect(isBlockedInChunk(chunk, 5, 9)).toBe(true);
  });

  it("isBlockedInChunk treats missing collision as walkable", () => {
    const chunk = buildChunk(0, 0, []);
    chunk.collision = new Uint8Array();
    expect(isBlockedInChunk(chunk, 0, 0)).toBe(false);
  });

  it("isSolidTile", () => {
    expect(isSolidTile(TileId.grass)).toBe(false);
    expect(isSolidTile(TileId.stone)).toBe(true);
  });
});
