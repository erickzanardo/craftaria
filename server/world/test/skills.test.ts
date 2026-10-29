import { describe, expect, it } from "vitest";
import {
  actionTicks,
  ALL_SKILLS,
  checkGather,
  Inventory,
  isSkillId,
  itemDef,
  levelForXp,
  MAX_LEVEL,
  MIN_ACTION_TICKS,
  Notice,
  PlayerSkills,
  progressFor,
  resourceNodeForTile,
  SkillId,
  TileId,
  TREES,
  xpForLevel,
} from "../src/index.ts";

describe("xp", () => {
  it("matches the spec table", () => {
    expect(xpForLevel(1)).toBe(0);
    expect(xpForLevel(2)).toBe(80);
    expect(xpForLevel(10)).toBe(966);
    expect(xpForLevel(50)).toBe(32176);
    expect(xpForLevel(100)).toBe(1064185);
  });

  it("is strictly increasing and clamps out of range levels", () => {
    for (let level = 2; level <= MAX_LEVEL; level++) {
      expect(xpForLevel(level)).toBeGreaterThan(xpForLevel(level - 1));
    }
    expect(xpForLevel(0)).toBe(0);
    expect(xpForLevel(500)).toBe(xpForLevel(MAX_LEVEL));
  });

  it("makes the last ten levels about half the grind", () => {
    const share = (xpForLevel(100) - xpForLevel(90)) / xpForLevel(100);
    expect(share).toBeCloseTo(0.5, 2);
  });

  it("finds the level for an XP total", () => {
    expect(levelForXp(0)).toBe(1);
    expect(levelForXp(79)).toBe(1);
    expect(levelForXp(80)).toBe(2);
    expect(levelForXp(xpForLevel(37))).toBe(37);
    expect(levelForXp(xpForLevel(37) - 1)).toBe(36);
    expect(levelForXp(1e9)).toBe(MAX_LEVEL);
  });

  it("describes progress towards the next level", () => {
    expect(progressFor(100)).toEqual({
      level: 2,
      xp: 100,
      levelXp: 80,
      nextLevelXp: 166,
    });
    const capped = progressFor(2e6);
    expect(capped.level).toBe(MAX_LEVEL);
    expect(capped.nextLevelXp).toBe(capped.levelXp);
  });
});

describe("PlayerSkills", () => {
  it("adds XP and reports level-ups", () => {
    const skills = new PlayerSkills();
    expect(skills.level(SkillId.woodcutting)).toBe(1);
    expect(skills.addXp(SkillId.woodcutting, 79)).toBe(false);
    expect(skills.addXp(SkillId.woodcutting, 1)).toBe(true);
    expect(skills.xp(SkillId.woodcutting)).toBe(80);
    expect(skills.addXp(SkillId.woodcutting, -10)).toBe(false);
    expect(skills.xp(SkillId.woodcutting)).toBe(80);
  });

  it("recognises skill ids", () => {
    expect(ALL_SKILLS).toContain("woodcutting");
    expect(isSkillId("woodcutting")).toBe(true);
    expect(isSkillId("juggling")).toBe(false);
  });
});

describe("gathering", () => {
  it("shortens actions with level and tool speed, down to a minimum", () => {
    expect(actionTicks(80, 1, 1)).toBe(80);
    expect(actionTicks(80, 100, 1)).toBe(40);
    expect(actionTicks(80, 1, 0.7)).toBe(56);
    expect(actionTicks(180, 40, 0.7)).toBe(101);
    expect(actionTicks(10, 100, 0.5)).toBe(MIN_ACTION_TICKS);
  });

  const pine = resourceNodeForTile(TileId.pine)!;
  const birch = resourceNodeForTile(TileId.birch)!;

  const setup = (equipped: string | undefined, xp = 0) => {
    const skills = new PlayerSkills();
    skills.addXp(SkillId.woodcutting, xp);
    const inventory = new Inventory(itemDef);
    inventory.equipped = equipped;
    return { skills, inventory };
  };

  it("checks tool, tier, level and room", () => {
    const check = (equipped: string | undefined, node = pine, xp = 0) => {
      const { skills, inventory } = setup(equipped, xp);
      return checkGather(node, skills, inventory);
    };
    expect(check(undefined)).toBe(Notice.noTool);
    expect(check("pine_log")).toBe(Notice.noTool);
    expect(check("stone_axe", birch)).toBe(Notice.toolTooWeak);
    expect(check("bronze_axe", birch)).toBe(Notice.levelTooLow);
    expect(check("bronze_axe", birch, xpForLevel(20))).toBeUndefined();
    expect(check("stone_axe")).toBeUndefined();

    const { skills, inventory } = setup("stone_axe");
    inventory.add("pine_log", 50 * inventory.slots.length);
    expect(checkGather(pine, skills, inventory)).toBe(Notice.inventoryFull);
  });

  it("maps every tree tile to a node whose product exists", () => {
    for (const tree of TREES) {
      expect(resourceNodeForTile(tree.tileId)).toBe(tree);
      expect(itemDef(tree.product)).toBeDefined();
    }
    expect(resourceNodeForTile(TileId.grass)).toBeUndefined();
  });
});
