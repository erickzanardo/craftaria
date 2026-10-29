import type { SkillId } from "../skills/skills.ts";

/** What a tool is used for. One category per gathering skill. */
export type ToolCategory = "axe";

export interface ToolStats {
  readonly category: ToolCategory;
  readonly skill: SkillId;
  /** Quality, starting at 1. */
  readonly tier: number;
  /** Skill level needed to equip and use the tool. */
  readonly levelRequirement: number;
  /** Multiplier on action time; lower is faster. */
  readonly speed: number;
}

/** An item type (spec/items.md). */
export interface ItemDef {
  /** Stable id used in the protocol. */
  readonly id: string;
  readonly name: string;
  readonly maxStack: number;
  readonly tool?: ToolStats;
}
