# Skills

Craftaria is about gathering and crafting, so player progression is a set of
**skills**, each levelled on its own by doing it. There is no overall
character level.

| Id | Skill | Kind |
| --- | --- | --- |
| `woodcutting` | Woodcutting | gathering |

## XP and levels

Every action in a skill grants XP in that skill. Levels go from **1** to
**100** (the cap). XP keeps accumulating past the cap; the level stops at 100.

The total XP needed to reach level `L` is:

```
xpForLevel(L) = round(1115 × (2^((L − 1) / 10) − 1))
```

The XP needed per level doubles every 10 levels, so the grind gets long:
levels 90 to 100 take about as much XP as levels 1 to 90 together.

| Level | Total XP | XP from previous level |
| --- | --- | --- |
| 1 | 0 | |
| 2 | 80 | 80 |
| 5 | 356 | 98 |
| 10 | 966 | 140 |
| 20 | 3,046 | 278 |
| 30 | 7,208 | 558 |
| 40 | 15,530 | 1,114 |
| 50 | 32,176 | 2,230 |
| 60 | 65,466 | 4,459 |
| 70 | 132,047 | 8,917 |
| 80 | 265,210 | 17,835 |
| 90 | 531,535 | 35,670 |
| 100 | 1,064,185 | 71,340 |

The constants (1115 and doubling every 10 levels) are *tunable*.

## Gathering

Gathering skills (woodcutting now; mining, fishing and others later) all
follow the same model.

### Tools

A gathering skill needs a **tool** of the skill's category (an axe for
woodcutting). Every tool has:

- **Tier**: its quality, starting at 1. A better tool has a higher tier.
- **Level requirement**: the skill level needed to equip it and use it.
- **Speed**: a multiplier on action time. Lower is faster.

The tool must be in the player's equipped tool slot (see
[items.md](items.md)).

### Resource nodes

Things in the world that a skill gathers from (trees for woodcutting) are
**resource nodes**. Every node type has:

- **Minimum tool tier**: the equipped tool must be at least this tier.
- **Product**: the item each successful action yields.
- **XP per yield**.
- **Base time**: the time one action takes at level 1 with a speed-1.00 tool.
- **Yield range**: how many products the node gives before it is depleted.
  The count is rolled uniformly in the range on the first action against a
  fresh node.
- **Depleted form**: what the node turns into when it runs out (a stump).
- **Regrow time**: how long the depleted form takes to turn back into a
  fresh node.

Nodes have no level requirement of their own; the tool's tier and level
requirement gate them.

### Action time

One action, which yields one product, takes:

```
ticks = max(20, round(baseTicks × levelFactor × toolSpeed))
levelFactor = 1 − 0.5 × (level − 1) / 99
```

So level 100 halves the time of level 1, and no action is shorter than one
second (20 ticks). The level used is the player's level when the action
starts. A level-up during an action speeds up the next one.

### The action loop

Starting to gather begins a loop: after each action completes, the player
gets one product and the XP, and the next action starts at once. The loop
stops when:

- the player moves or cancels it
- the node is depleted
- the inventory has no room for the product
- the player no longer meets the requirements (for example, they unequipped
  the tool)

When gathering can't start or stops, the player is told why: no tool
equipped, tool too weak, level too low for the tool, inventory full, out of
reach, or nothing to gather there.

## Open questions

- Should nodes ever have a level requirement of their own, separate from the
  tool?
- Should there be a chance-based element (bonus yields, rare drops)?
- Rested XP or other catch-up mechanics?
- Non-gathering skills (crafting): how do they gain XP and get gated?
