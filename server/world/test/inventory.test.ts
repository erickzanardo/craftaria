import { describe, expect, it } from "vitest";
import { INVENTORY_SLOTS, Inventory, itemDef } from "../src/index.ts";

describe("Inventory", () => {
  it("starts empty with the spec's slot count", () => {
    const inventory = new Inventory(itemDef);
    expect(inventory.slots).toHaveLength(INVENTORY_SLOTS);
    expect(inventory.slots.every((slot) => slot === undefined)).toBe(true);
    expect(inventory.equipped).toBeUndefined();
    expect(inventory.equippedTool).toBeUndefined();
  });

  it("tops up stacks before using empty slots", () => {
    const inventory = new Inventory(itemDef, 3);
    expect(inventory.add("pine_log", 30)).toBe(30);
    expect(inventory.add("birch_log")).toBe(1);
    expect(inventory.add("pine_log", 30)).toBe(30);
    expect(inventory.slots).toEqual([
      { itemId: "pine_log", count: 50 },
      { itemId: "birch_log", count: 1 },
      { itemId: "pine_log", count: 10 },
    ]);
  });

  it("adds what fits and reports room", () => {
    const inventory = new Inventory(itemDef, 2);
    expect(inventory.roomFor("pine_log", 200)).toBe(100);
    expect(inventory.roomFor("pine_log")).toBe(1);
    expect(inventory.add("stone_axe", 3)).toBe(2);
    expect(inventory.roomFor("pine_log")).toBe(0);
    expect(inventory.add("pine_log")).toBe(0);
  });

  it("ignores unknown items", () => {
    const inventory = new Inventory(itemDef, 2);
    expect(inventory.roomFor("nope")).toBe(0);
    expect(inventory.add("nope")).toBe(0);
  });

  it("equips tools by swapping with the equipped one", () => {
    const inventory = new Inventory(itemDef, 3);
    inventory.add("pine_log");
    inventory.add("bronze_axe");
    expect(inventory.toolAt(0)).toBeUndefined();
    expect(inventory.toolAt(2)).toBeUndefined();
    expect(inventory.equip(0)).toBe(false);

    expect(inventory.equip(1)).toBe(true);
    expect(inventory.equipped).toBe("bronze_axe");
    expect(inventory.slots[1]).toBeUndefined();

    inventory.add("iron_axe");
    expect(inventory.equip(1)).toBe(true);
    expect(inventory.equippedTool?.id).toBe("iron_axe");
    expect(inventory.slots[1]).toEqual({ itemId: "bronze_axe", count: 1 });
  });
});
