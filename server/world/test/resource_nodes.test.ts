import { describe, expect, it } from "vitest";
import { ResourceNodes, resourceNodeForTile, TileId } from "../src/index.ts";

const pine = resourceNodeForTile(TileId.pine)!;

describe("ResourceNodes", () => {
  it("rolls the yield count on the first harvest", () => {
    const lowest = new ResourceNodes(() => 0);
    const harvests = (nodes: ResourceNodes) => {
      let count = 1;
      while (!nodes.harvest(1, 2, pine, 0)) count++;
      return count;
    };
    expect(harvests(lowest)).toBe(pine.minYield);
    expect(harvests(new ResourceNodes(() => 0.999))).toBe(pine.maxYield);
  });

  it("tracks nodes separately and schedules regrowth", () => {
    const nodes = new ResourceNodes(() => 0);
    for (let i = 1; i < pine.minYield; i++) {
      expect(nodes.harvest(0, 0, pine, 5)).toBe(false);
    }
    expect(nodes.harvest(1, 0, pine, 5)).toBe(false);
    expect(nodes.harvest(0, 0, pine, 5)).toBe(true);

    expect(nodes.takeDue(5 + pine.regrowTicks - 1)).toEqual([]);
    expect(nodes.takeDue(5 + pine.regrowTicks)).toEqual([
      { tileX: 0, tileY: 0, node: pine },
    ]);
    expect(nodes.takeDue(1e9)).toEqual([]);
  });

  it("defaults to Math.random", () => {
    const nodes = new ResourceNodes();
    let count = 1;
    while (!nodes.harvest(0, 0, pine, 0)) count++;
    expect(count).toBeGreaterThanOrEqual(pine.minYield);
    expect(count).toBeLessThanOrEqual(pine.maxYield);
  });
});
