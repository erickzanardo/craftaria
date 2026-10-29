import { describe, expect, it } from "vitest";
import {
  actionTicks,
  isSolidTile,
  Notice,
  resourceNodeForTile,
  SkillId,
  TILE_SUBPIXELS,
  TileId,
  xpForLevel,
  ZoneSimulation,
  type ZoneWorld,
} from "../src/index.ts";

const pine = resourceNodeForTile(TileId.pine)!;
const birch = resourceNodeForTile(TileId.birch)!;

/** A world with nothing but the decoration tiles set in it. */
function fakeWorld(tiles: Record<string, number>): ZoneWorld {
  const key = (x: number, y: number) => `${x},${y}`;
  return {
    isBlocked: (x, y) => isSolidTile(tiles[key(x, y)] ?? 0),
    tileAt: (x, y, layer) => (layer === "decoration" ? (tiles[key(x, y)] ?? 0) : 0),
    setTile: (x, y, layer, tileId) => {
      if (layer !== "decoration") return undefined;
      tiles[key(x, y)] = tileId;
      return { cx: 0, cy: 0, layer, index: y * 32 + x, tileId, blocked: isSolidTile(tileId) };
    },
  };
}

/** Center of a tile in sub-pixels. */
const at = (tileX: number, tileY: number) => ({
  x: tileX * TILE_SUBPIXELS + TILE_SUBPIXELS / 2,
  y: tileY * TILE_SUBPIXELS + TILE_SUBPIXELS / 2,
});

function setup(tiles: Record<string, number> = { "2,1": TileId.pine }) {
  const sim = new ZoneSimulation(fakeWorld(tiles), { random: () => 0 });
  const player = sim.addPlayer("a", at(1, 1));
  return { sim, player, tiles };
}

const steps = (sim: ZoneSimulation, count: number) => {
  for (let i = 0; i < count; i++) sim.step();
};

describe("ZoneSimulation gathering", () => {
  it("gives new players a Stone axe and keeps progress across reconnects", () => {
    const { sim, player } = setup();
    expect(player.inventory.equipped).toBe("stone_axe");
    player.inventory.add("pine_log");
    sim.removePlayer("a");
    expect(sim.addPlayer("a").inventory.slots[0]?.itemId).toBe("pine_log");
  });

  it("chops a log per cycle, granting XP, until the tree is a stump", () => {
    const { sim, player, tiles } = setup();
    sim.queueInput("a", { kind: "gather", seq: 1, tileX: 2, tileY: 1 });
    sim.step();

    expect(player.action).toMatchObject({ tileX: 2, tileY: 1, startTick: 0, durationTicks: 80 });
    expect(sim.takePlayerUpdates("a")).toEqual({
      inventory: false,
      skills: [],
      action: true,
      notices: [],
    });

    steps(sim, 80);
    expect(player.inventory.slots[0]).toEqual({ itemId: "pine_log", count: 1 });
    expect(player.skills.xp(SkillId.woodcutting)).toBe(pine.xp);
    expect(player.action?.startTick).toBe(80);
    expect(sim.takePlayerUpdates("a")).toMatchObject({
      inventory: true,
      skills: [SkillId.woodcutting],
      action: true,
    });

    // random() = 0 rolls the minimum yield.
    steps(sim, 80 * (pine.minYield - 1));
    expect(player.inventory.slots[0]?.count).toBe(pine.minYield);
    expect(player.action).toBeUndefined();
    expect(tiles["2,1"]).toBe(TileId.pineStump);
    expect(sim.takeTileChanges()).toEqual([
      expect.objectContaining({ tileId: TileId.pineStump, layer: "decoration" }),
    ]);
    expect(sim.takeTileChanges()).toEqual([]);
    expect(sim.takePlayerUpdates("a")!.notices).toEqual([Notice.depleted]);

    steps(sim, pine.regrowTicks);
    expect(tiles["2,1"]).toBe(TileId.pine);
    expect(sim.takeTileChanges()).toEqual([
      expect.objectContaining({ tileId: TileId.pine }),
    ]);
  });

  it("shortens the next cycle after a level-up", () => {
    const { sim, player } = setup();
    player.skills.addXp(SkillId.woodcutting, xpForLevel(40) - pine.xp);
    sim.queueInput("a", { kind: "gather", seq: 1, tileX: 2, tileY: 1 });
    sim.step();
    expect(player.action?.durationTicks).toBe(actionTicks(80, 39, 1));
    steps(sim, player.action!.durationTicks);
    expect(player.skills.level(SkillId.woodcutting)).toBe(40);
    expect(player.action?.durationTicks).toBe(actionTicks(80, 40, 1));
  });

  it("applies a gather after the moves queued before it", () => {
    const { sim, player } = setup({ "4,1": TileId.pine });
    // Two tiles to walk at 40 sub-pixels per tick: 256 / 40 → 7 moves.
    for (let seq = 1; seq <= 7; seq++) {
      sim.queueInput("a", { kind: "move", seq, dx: 1, dy: 0 });
    }
    sim.queueInput("a", { kind: "gather", seq: 8, tileX: 4, tileY: 1 });
    // The input budget lets 3 inputs through on the first tick, then 1 per tick.
    steps(sim, 5);
    expect(player.action).toBeUndefined();
    sim.step();
    expect(player.action?.tileX).toBe(4);
    expect(player.lastInputSeq).toBe(8);
  });

  it("cancels the action when the player moves or asks to", () => {
    const { sim, player } = setup();
    sim.queueInput("a", { kind: "gather", seq: 1, tileX: 2, tileY: 1 });
    sim.step();
    sim.queueInput("a", { kind: "move", seq: 2, dx: 0, dy: 0 });
    sim.step();
    expect(player.action).toBeDefined();
    sim.queueInput("a", { kind: "move", seq: 3, dx: 0, dy: 1 });
    sim.step();
    expect(player.action).toBeUndefined();

    sim.queueInput("a", { kind: "gather", seq: 4, tileX: 2, tileY: 1 });
    sim.step();
    sim.cancelAction("a");
    sim.cancelAction("ghost");
    expect(player.action).toBeUndefined();
    expect(sim.takePlayerUpdates("a")!.notices).toEqual([]);
  });

  it("explains why gathering can't start", () => {
    const { sim, player } = setup({ "2,1": TileId.birch, "5,5": TileId.pine });
    const notices = (tileX: number, tileY: number, seq: number) => {
      sim.queueInput("a", { kind: "gather", seq, tileX, tileY });
      sim.step();
      return sim.takePlayerUpdates("a")!.notices;
    };
    expect(notices(1, 2, 1)).toEqual([Notice.nothingToGather]);
    expect(notices(5, 5, 2)).toEqual([Notice.outOfReach]);
    expect(notices(2, 1, 3)).toEqual([Notice.toolTooWeak]);
    player.inventory.equipped = undefined;
    expect(notices(2, 1, 4)).toEqual([Notice.noTool]);
    expect(player.action).toBeUndefined();
  });

  it("stops when the inventory fills up or the tree is gone", () => {
    const { sim, player, tiles } = setup();
    player.inventory.add("stone_axe", player.inventory.slots.length - 1);
    player.inventory.add("pine_log", 49);
    sim.queueInput("a", { kind: "gather", seq: 1, tileX: 2, tileY: 1 });
    steps(sim, 81);
    expect(player.action).toBeUndefined();
    expect(sim.takePlayerUpdates("a")!.notices).toEqual([Notice.inventoryFull]);

    // Room again, but someone else cut the tree mid-action.
    player.inventory.slots[0] = undefined;
    sim.queueInput("a", { kind: "gather", seq: 2, tileX: 2, tileY: 1 });
    sim.step();
    tiles["2,1"] = TileId.pineStump;
    steps(sim, 80);
    expect(player.action).toBeUndefined();
    expect(sim.takePlayerUpdates("a")!.notices).toEqual([Notice.depleted]);
  });

  it("stops at the end of a cycle when the tool was swapped for a weaker one", () => {
    const { sim, player } = setup({ "2,1": TileId.birch });
    sim.grantItem("a", "bronze_axe", 1);
    sim.grantXp("a", SkillId.woodcutting, xpForLevel(20));
    sim.equip("a", 0);
    sim.queueInput("a", { kind: "gather", seq: 1, tileX: 2, tileY: 1 });
    sim.step();
    expect(player.action?.node).toBe(birch);

    sim.equip("a", 0);
    expect(player.inventory.equipped).toBe("stone_axe");
    steps(sim, 120);
    expect(player.action).toBeUndefined();
    expect(sim.takePlayerUpdates("a")!.notices).toEqual([Notice.toolTooWeak]);
  });

  it("only equips tools the player has the level for", () => {
    const { sim, player } = setup();
    sim.grantItem("a", "iron_axe", 1);
    sim.grantItem("a", "nope", 1);
    sim.equip("a", 0);
    sim.equip("a", 5);
    sim.equip("ghost", 0);
    expect(player.inventory.equipped).toBe("stone_axe");
    expect(sim.takePlayerUpdates("a")).toEqual({
      inventory: true,
      skills: [],
      action: false,
      notices: [Notice.levelTooLow],
    });

    sim.grantXp("a", SkillId.woodcutting, xpForLevel(40));
    sim.grantXp("ghost", SkillId.woodcutting, 1);
    sim.grantItem("ghost", "pine_log", 1);
    sim.equip("a", 0);
    expect(player.inventory.equipped).toBe("iron_axe");
    expect(sim.takePlayerUpdates("a")).toMatchObject({
      inventory: true,
      skills: [SkillId.woodcutting],
    });
    expect(sim.takePlayerUpdates("ghost")).toBeUndefined();
  });

  it("knows which chunks a player has", () => {
    const { sim } = setup();
    sim.takeUnsentChunks("a");
    expect(sim.hasChunk("a", 0, 0)).toBe(true);
    expect(sim.hasChunk("a", 50, 0)).toBe(false);
    expect(sim.hasChunk("ghost", 0, 0)).toBe(false);
  });

  it("ignores edits the world rejects", () => {
    const world = fakeWorld({ "2,1": TileId.pine });
    const sim = new ZoneSimulation(
      { ...world, setTile: () => undefined },
      { random: () => 0 },
    );
    sim.addPlayer("a", at(1, 1));
    sim.queueInput("a", { kind: "gather", seq: 1, tileX: 2, tileY: 1 });
    steps(sim, 1 + 80 * pine.minYield);
    expect(sim.takeTileChanges()).toEqual([]);
  });
});
