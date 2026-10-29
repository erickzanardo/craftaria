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

## Known gaps

- A socket that connects but never sends `Hello` is never timed out.
- No rate limit on `POST /auth/guest`.
- `World` keeps every generated chunk in memory.
- Nothing is saved: positions reset and players respawn at the origin when a
  zone restarts.
- The Durable Object adapter (`zone_durable_object.ts`) has no unit tests;
  its logic lives in the fully tested `ZoneServer`.
- Visibility is "everyone in the zone"; fine for under 50 players.
- No deploy pipeline; the game only runs locally.
- No sprites or animation yet (waiting on art).

## Next steps (in no fixed order)

- First crafting interaction, e.g. chopping a tree or placing a block, with
  edits stored in the zone's Durable Object SQLite storage.
- Save player positions and inventory.
- Deploy: Worker plus Durable Object, and the web client on Pages.
- Map editor app (`apps/editor`) and handcrafted hubs.
- Replace debug rendering once sprites exist.
- Mobile: touch `MovementInput`, platform storage.
