// Every item and resource node in the game. New skills register theirs here.

import type { ItemDef } from "./items/items.ts";
import type { ResourceNodeDef } from "./skills/gathering.ts";
import { TREES, WOODCUTTING_ITEMS } from "./skills/woodcutting.ts";

export const ITEMS: readonly ItemDef[] = [...WOODCUTTING_ITEMS];

const itemsById = new Map(ITEMS.map((item) => [item.id, item]));

export function itemDef(id: string): ItemDef | undefined {
  return itemsById.get(id);
}

const nodesByTile = new Map<number, ResourceNodeDef>(
  TREES.map((node) => [node.tileId, node]),
);

/** The resource node a tile id is, if any. */
export function resourceNodeForTile(
  tileId: number,
): ResourceNodeDef | undefined {
  return nodesByTile.get(tileId);
}
