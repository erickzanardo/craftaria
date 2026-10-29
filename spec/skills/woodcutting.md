# Woodcutting

Cut trees with an axe to get logs. Follows the gathering model in
[skills.md](../skills.md). Skill id: `woodcutting`.

## Axes

Axes are woodcutting tools. All values are *tunable*.

| Item id | Axe | Tier | Level | Speed |
| --- | --- | --- | --- | --- |
| `stone_axe` | Stone axe | 1 | 1 | 1.00 |
| `bronze_axe` | Bronze axe | 2 | 20 | 0.85 |
| `iron_axe` | Iron axe | 3 | 40 | 0.70 |

Every player starts with a Stone axe equipped. How players get better axes
(smithing, trading) isn't designed yet.

## Trees

All values are *tunable*.

| Tree | Min axe tier | Log | XP per log | Base time | Logs | Regrow |
| --- | --- | --- | --- | --- | --- | --- |
| Pine | 1 | `pine_log` | 25 | 4 s (80 ticks) | 3–6 | 30 s |
| Birch | 2 | `birch_log` | 60 | 6 s (120 ticks) | 3–5 | 60 s |
| Ironwood | 3 | `ironwood_log` | 140 | 9 s (180 ticks) | 2–4 | 120 s |

A depleted tree becomes a stump of its kind. Stumps block movement like
trees do, so a tree never regrows on top of a player.

Example action times (ticks):

| | Level 1 | Level 20 | Level 40 | Level 100 |
| --- | --- | --- | --- | --- |
| Pine, Stone axe | 80 | 72 | 64 | 40 |
| Pine, Iron axe | 56 | 51 | 45 | 28 |
| Ironwood, Iron axe | — | — | 101 | 63 |

## Where trees grow

In the generated wilderness, better trees grow further from the origin, so
progressing means exploring outward. By distance from the origin, in tiles:

| Distance | Pine | Birch | Ironwood |
| --- | --- | --- | --- |
| under 48 | 100% | | |
| 48 to 127 | 70% | 30% | |
| 128 and more | 50% | 30% | 20% |

Tree density doesn't change with distance. The distances and the mix are
*tunable*. Handcrafted areas place their trees by hand.

## Open questions

- Do trees drop anything besides logs (seeds, sap, bird nests)?
- Should players be able to plant trees?
- Is a regrown tree still a lasting world edit, or does a stump ever vanish?
