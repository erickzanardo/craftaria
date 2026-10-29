import type { ItemDef } from "./items.ts";

/** Slots in a player's inventory (spec/items.md). Tunable. */
export const INVENTORY_SLOTS = 28;

export interface ItemStack {
  readonly itemId: string;
  count: number;
}

export type ItemLookup = (id: string) => ItemDef | undefined;

/** A player's inventory slots and equipped tool. */
export class Inventory {
  readonly slots: (ItemStack | undefined)[];
  /** Item id of the equipped tool, if any. */
  equipped: string | undefined;

  constructor(
    private readonly lookup: ItemLookup,
    size: number = INVENTORY_SLOTS,
  ) {
    this.slots = new Array<ItemStack | undefined>(size).fill(undefined);
  }

  /** How many of [itemId] fit, up to [count]. */
  roomFor(itemId: string, count: number = 1): number {
    const def = this.lookup(itemId);
    if (def === undefined) return 0;
    let room = 0;
    for (const stack of this.slots) {
      room +=
        stack === undefined
          ? def.maxStack
          : stack.itemId === itemId
            ? def.maxStack - stack.count
            : 0;
      if (room >= count) return count;
    }
    return room;
  }

  /**
   * Adds up to [count] of [itemId], topping up existing stacks first, then
   * filling empty slots. Returns how many were added.
   */
  add(itemId: string, count: number = 1): number {
    const def = this.lookup(itemId);
    if (def === undefined) return 0;
    let left = count;
    for (const stack of this.slots) {
      if (left === 0) break;
      if (stack?.itemId !== itemId) continue;
      const moved = Math.min(left, def.maxStack - stack.count);
      stack.count += moved;
      left -= moved;
    }
    for (let i = 0; i < this.slots.length && left > 0; i++) {
      if (this.slots[i] !== undefined) continue;
      const moved = Math.min(left, def.maxStack);
      this.slots[i] = { itemId, count: moved };
      left -= moved;
    }
    return count - left;
  }

  /** The tool in [slot], if that slot holds one. */
  toolAt(slot: number): ItemDef | undefined {
    const stack = this.slots[slot];
    if (stack === undefined) return undefined;
    const def = this.lookup(stack.itemId);
    return def?.tool === undefined ? undefined : def;
  }

  /** The equipped tool's definition. */
  get equippedTool(): ItemDef | undefined {
    return this.equipped === undefined ? undefined : this.lookup(this.equipped);
  }

  /**
   * Equips the tool in [slot], putting the previously equipped tool in its
   * place. Requirements are the caller's to check. Returns false if the slot
   * holds no tool.
   */
  equip(slot: number): boolean {
    const tool = this.toolAt(slot);
    if (tool === undefined) return false;
    const previous = this.equipped;
    this.equipped = tool.id;
    this.slots[slot] =
      previous === undefined ? undefined : { itemId: previous, count: 1 };
    return true;
  }
}
