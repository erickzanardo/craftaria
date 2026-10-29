import { describe, expect, it } from "vitest";
import {
  generateChunk,
  heightAt,
  BIRCH_DISTANCE,
  HUB_RADIUS,
  IRONWOOD_DISTANCE,
  random01,
  TileId,
  tileIndex,
  treeFor,
  World,
} from "../src/index.ts";

describe("worldgen", () => {
  it("is deterministic for a seed", () => {
    expect(generateChunk(42, 1, -1)).toEqual(generateChunk(42, 1, -1));
    expect(generateChunk(42, 1, -1)).not.toEqual(generateChunk(43, 1, -1));
  });

  it("random01 and heightAt stay in [0, 1)", () => {
    for (let i = -50; i < 50; i++) {
      for (const value of [random01(7, i, i * 3), heightAt(7, i, -i)]) {
        expect(value).toBeGreaterThanOrEqual(0);
        expect(value).toBeLessThan(1);
      }
    }
  });

  it("keeps the hub around the origin walkable grass", () => {
    const chunk = generateChunk(1234, 0, 0);
    const [ground, decoration] = chunk.layers;
    for (let y = 0; y < HUB_RADIUS; y++) {
      expect(ground!.tiles[tileIndex(0, y)]).toBe(TileId.grass);
      expect(decoration!.tiles[tileIndex(0, y)]).toBe(TileId.empty);
    }
  });

  it("grows better trees further from the origin", () => {
    expect(treeFor(10, 0, 0)).toBe(TileId.pine);
    expect(treeFor(BIRCH_DISTANCE, 0, 0.29)).toBe(TileId.birch);
    expect(treeFor(BIRCH_DISTANCE, 0, 0.3)).toBe(TileId.pine);
    expect(treeFor(BIRCH_DISTANCE - 1, 0, 0)).toBe(TileId.pine);
    expect(treeFor(0, -IRONWOOD_DISTANCE, 0.19)).toBe(TileId.ironwood);
    expect(treeFor(0, -IRONWOOD_DISTANCE, 0.49)).toBe(TileId.birch);
    expect(treeFor(0, -IRONWOOD_DISTANCE, 0.5)).toBe(TileId.pine);
  });

  it("produces every generated tile type somewhere", () => {
    const seen = new Set<number>();
    for (let cy = -3; cy <= 3; cy++) {
      for (let cx = -3; cx <= 3; cx++) {
        for (const layer of generateChunk(99, cx, cy).layers) {
          for (const tile of layer.tiles) seen.add(tile);
        }
      }
    }
    expect([...seen].sort((a, b) => a - b)).toEqual(
      Object.values(TileId)
        .filter(
          (id) =>
            id !== TileId.pineStump &&
            id !== TileId.birchStump &&
            id !== TileId.ironwoodStump,
        )
        .sort((a, b) => a - b),
    );
  });
});

describe("World", () => {
  it("caches chunks and answers collision in world tiles", () => {
    const world = new World(5);
    expect(world.chunk(-1, 0)).toBe(world.chunk(-1, 0));

    const chunk = world.chunk(-1, -1);
    const blocked = (index: number) =>
      ((chunk.collision[index >> 3] ?? 0) & (1 << (index & 7))) !== 0;
    for (let index = 0; index < 64; index++) {
      const lx = index % 32;
      const ly = Math.floor(index / 32);
      expect(world.isBlocked(-32 + lx, -32 + ly)).toBe(blocked(index));
    }
  });
});

describe("World edits", () => {
  it("reads and edits tiles by layer, updating collision", () => {
    const world = new World(5);
    world.setTile(-40, 3, "decoration", TileId.pine);
    expect(world.tileAt(-40, 3, "decoration")).toBe(TileId.pine);
    expect(world.tileAt(-40, 3, "nope")).toBe(0);
    expect(world.isBlocked(-40, 3)).toBe(true);

    const change = world.setTile(-40, 3, "decoration", TileId.empty);
    expect(change).toEqual({
      cx: -2,
      cy: 0,
      layer: "decoration",
      index: tileIndex(24, 3),
      tileId: TileId.empty,
      blocked: world.isBlocked(-40, 3),
    });
    expect(world.chunk(-2, 0).layers[1]!.tiles[tileIndex(24, 3)]).toBe(
      TileId.empty,
    );
    expect(world.setTile(0, 0, "nope", TileId.pine)).toBeUndefined();
  });
});
