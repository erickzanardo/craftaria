// Woodcutting content from spec/skills/woodcutting.md. Tunable.

import { TICK_RATE } from "../constants.ts";
import type { ItemDef } from "../items/items.ts";
import { TileId } from "../tiles.ts";
import type { ResourceNodeDef } from "./gathering.ts";
import { SkillId } from "./skills.ts";

const seconds = (value: number) => value * TICK_RATE;

const axe = (
  id: string,
  name: string,
  tier: number,
  levelRequirement: number,
  speed: number,
): ItemDef => ({
  id,
  name,
  maxStack: 1,
  tool: {
    category: "axe",
    skill: SkillId.woodcutting,
    tier,
    levelRequirement,
    speed,
  },
});

const log = (id: string, name: string): ItemDef => ({
  id,
  name,
  maxStack: 50,
});

export const WOODCUTTING_ITEMS: readonly ItemDef[] = [
  axe("stone_axe", "Stone axe", 1, 1, 1),
  axe("bronze_axe", "Bronze axe", 2, 20, 0.85),
  axe("iron_axe", "Iron axe", 3, 40, 0.7),
  log("pine_log", "Pine log"),
  log("birch_log", "Birch log"),
  log("ironwood_log", "Ironwood log"),
];

const tree = (
  id: string,
  tileId: number,
  depletedTileId: number,
  minToolTier: number,
  xp: number,
  baseSeconds: number,
  minYield: number,
  maxYield: number,
  regrowSeconds: number,
): ResourceNodeDef => ({
  id,
  skill: SkillId.woodcutting,
  tileId,
  depletedTileId,
  toolCategory: "axe",
  minToolTier,
  product: `${id}_log`,
  xp,
  baseTicks: seconds(baseSeconds),
  minYield,
  maxYield,
  regrowTicks: seconds(regrowSeconds),
});

export const TREES: readonly ResourceNodeDef[] = [
  tree("pine", TileId.pine, TileId.pineStump, 1, 25, 4, 3, 6, 30),
  tree("birch", TileId.birch, TileId.birchStump, 2, 60, 6, 3, 5, 60),
  tree("ironwood", TileId.ironwood, TileId.ironwoodStump, 3, 140, 9, 2, 4, 120),
];

/** Item every new player starts with equipped. */
export const STARTER_TOOL = "stone_axe";
