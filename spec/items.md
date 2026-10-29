# Items

## Item types

Every item has a stable id, a display name and a maximum stack size.

| Item id | Name | Max stack | Kind |
| --- | --- | --- | --- |
| `stone_axe` | Stone axe | 1 | woodcutting tool, see [woodcutting](skills/woodcutting.md) |
| `bronze_axe` | Bronze axe | 1 | woodcutting tool |
| `iron_axe` | Iron axe | 1 | woodcutting tool |
| `pine_log` | Pine log | 50 | material |
| `birch_log` | Birch log | 50 | material |
| `ironwood_log` | Ironwood log | 50 | material |

Tools never stack. Stack sizes are *tunable*.

## Inventory

Every player carries an inventory of **28 slots** (*tunable*). A slot is
empty or holds a stack of one item type.

A new item goes into the first existing stack of the same type with room,
then into the first empty slot. If it doesn't fit anywhere, it isn't picked
up: gathering stops with "inventory full".

## Equipment

Players have one **equipped tool** slot, separate from the inventory.
Equipping a tool from an inventory slot swaps it with the equipped tool: the
previously equipped tool, if any, takes the slot the new one came from. A
player can only equip a tool whose level requirement they meet.

## Starting kit

A new player starts with a Stone axe equipped and an empty inventory.

## Open questions

- Dropping, destroying and trading items.
- Armour and other equipment slots.
- Banks or storage beyond the inventory.
- Does anything happen to items on death?
