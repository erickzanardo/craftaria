# Roadmap

## Current state

Milestone 1, the walking skeleton, is done and was tested by hand in the
browser:

- guest login, joining the `overworld` zone
- walking with WASD or the arrow keys through a procedurally generated world,
  with collision against water, stone and trees
- other players visible and moving smoothly
- chunks streamed around the player
- CI for Dart, server, generated-code drift and secret scanning

Milestone 2, the first skill, is implemented and unit tested but **not yet
tested by hand in the browser**:

- woodcutting, following the rules in [spec/](../spec/README.md): click a
  tree to walk next to it and chop it; logs and XP per cycle; stumps that
  regrow
- a shared skill/XP framework (levels 1–100) and gathering model for future
  skills
- items, a 28-slot inventory and an equipped tool slot; Stone axe to start
- a debug-drawn HUD (skill bar, inventory, notices) and action progress bar
- dev-only debug commands (`DEBUG_COMMANDS=1`) to grant items and XP

## Known gaps

- A socket that connects but never sends `Hello` is never timed out.
- No rate limit on `POST /auth/guest`.
- `World` keeps every generated chunk in memory.
- Nothing is saved: positions, skills, inventories and world edits (stumps)
  live in zone memory and are lost when a zone restarts. Progress does
  survive a reconnect while the zone is up.
- Players get better axes only through debug commands; there is no smithing
  or trading yet.
- The Durable Object adapter (`zone_durable_object.ts`) has no unit tests;
  its logic lives in the fully tested `ZoneServer`.
- Visibility is "everyone in the zone"; fine for under 50 players.
- No deploy pipeline; the game only runs locally.
- Characters are created by picking skin, shirt and pants colors (debug-styled
  panel); the sprite is static. Tiles are still debug colors; no animation
  yet (waiting on art). A character can't be changed in game after creation.

## Next steps (in no fixed order)

- Test woodcutting by hand and tune the numbers in `spec/`.
- Save player positions, skills and inventory, and store world edits in the
  zone's Durable Object SQLite storage.
- A first crafting skill that uses logs, and a way to obtain better axes.
- More gathering skills on the same model (mining, fishing).
- Deploy: Worker plus Durable Object, and the web client on Pages.
- Map editor app (`apps/editor`) and handcrafted hubs.
- Replace debug tile rendering once tile sprites exist; animate players.
- Mobile: touch `MovementInput`, platform storage.
