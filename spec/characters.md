# Characters

## Creating a character

When a player joins without a character they create one before playing: they
pick a **skin**, a **shirt** and a **pants** color. Until they do, other
players don't see them.

Colors come from the game palette, Apollo (`sprites/apollo.hex`, 46 colors,
indexed from 0 as in Aseprite):

| Part | Allowed palette indexes |
| --- | --- |
| Skin | 12 to 19 (the brown ramps) |
| Shirt | any index except 12 to 19 |
| Pants | any index except 12 to 19 |

Shirt and pants may be the same color. The server ignores a character whose
colors break these rules.

A character is kept like progress: it survives reconnects while the zone is
up, and nothing is saved yet (see [docs/roadmap.md](../docs/roadmap.md)).

## Open questions

- Can a player change their character after creating it? The server accepts
  a new one at any time, but there is no way to ask for it in the game.
- Names, hair, and more character parts.
