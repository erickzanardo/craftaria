import type { Inventory } from "../items/inventory.ts";
import type { ToolCategory } from "../items/items.ts";
import type { PlayerSkills, SkillId } from "./skills.ts";

/** Shortest possible action: one second. */
export const MIN_ACTION_TICKS = 20;

/** Layer that holds resource nodes in a chunk. */
export const NODE_LAYER = "decoration";

/** A kind of thing in the world a gathering skill takes from (spec/skills.md). */
export interface ResourceNodeDef {
  readonly id: string;
  readonly skill: SkillId;
  /** Tile id of the fresh node. */
  readonly tileId: number;
  /** Tile id the node turns into when depleted. */
  readonly depletedTileId: number;
  readonly toolCategory: ToolCategory;
  readonly minToolTier: number;
  /** Item id of each yield. */
  readonly product: string;
  readonly xp: number;
  /** Action time at level 1 with a speed 1.00 tool. */
  readonly baseTicks: number;
  readonly minYield: number;
  readonly maxYield: number;
  readonly regrowTicks: number;
}

/** Why gathering can't start or had to stop. */
export const Notice = {
  nothingToGather: "nothing_to_gather",
  outOfReach: "out_of_reach",
  noTool: "no_tool",
  toolTooWeak: "tool_too_weak",
  levelTooLow: "level_too_low",
  inventoryFull: "inventory_full",
  depleted: "depleted",
} as const;

export type Notice = (typeof Notice)[keyof typeof Notice];

/** Ticks one action takes (spec/skills.md#action-time). */
export function actionTicks(
  baseTicks: number,
  level: number,
  toolSpeed: number,
): number {
  const levelFactor = 1 - (0.5 * (level - 1)) / 99;
  return Math.max(
    MIN_ACTION_TICKS,
    Math.round(baseTicks * levelFactor * toolSpeed),
  );
}

/**
 * Checks whether a player can take one yield from [node], returning the
 * reason when they can't. Reach is the caller's to check.
 */
export function checkGather(
  node: ResourceNodeDef,
  skills: PlayerSkills,
  inventory: Inventory,
): Notice | undefined {
  const tool = inventory.equippedTool?.tool;
  if (tool === undefined || tool.category !== node.toolCategory) {
    return Notice.noTool;
  }
  if (tool.tier < node.minToolTier) return Notice.toolTooWeak;
  if (skills.level(tool.skill) < tool.levelRequirement) {
    return Notice.levelTooLow;
  }
  if (inventory.roomFor(node.product) === 0) return Notice.inventoryFull;
  return undefined;
}
