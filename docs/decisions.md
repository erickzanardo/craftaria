# Design decisions

Why things are the way they are. Add an entry when a decision is made or
changed; don't silently rewrite history.

## Game

- **Genre**: top-down sandbox/crafting MMO. Low-res pixel art: 8×8 px tiles.
- **Scale**: tiny to start, under 50 concurrent players. Keep infrastructure
  minimal; shard further only when needed.
- **World**: hybrid. Handcrafted hubs/towns plus procedural wilderness. Until
  the editor exists, the area within 8 tiles of the origin is forced to open
  grass as a stand-in hub.

## Game rules and skills

- Game rules live in `spec/` as markdown, separate from `docs/` (which is
  about the code). The spec is the source of truth for rules; the code must
  match, and both change in the same commit.
- Progression is per skill, built around gathering and crafting. No overall
  character level. Levels 1–100 on an exponential curve (XP per level
  doubles every 10 levels).
- Gathering skills share one model: a **tool** (tier, level requirement,
  speed) and **resource nodes** (minimum tool tier, XP, yield range,
  depleted form, regrow time). Action time shrinks with both level and tool
  speed. New gathering skills should reuse it rather than invent their own.
- Content tables (items, tools, nodes, XP curve) live in server code only.
  The client gets display data (item names, XP for the next level, action
  durations) from the server, so the tables are never duplicated in Dart.
- Interaction is click-to-act: the client pathfinds next to the target with
  normal movement inputs, then sends the action. The action shares the
  movement input queue so the server applies it after the walk.
- Depleted resource nodes stay solid (stumps block like trees), so a node
  never regrows on top of a player.

## Art

- All art is drawn by the author in Aseprite. **Never generate or commit
  placeholder art**, including golden test images.
- The game consumes **exported PNG sprite sheets**. Animation data (frame
  timings, sequences) is **hardcoded in code**; the author provides the
  values. No Aseprite JSON parsing.
- Sheets live in `apps/game/assets/images/` and are loaded through Flame's
  image cache. Characters are 8x8 cells in `characters.png`, drawn with their
  bottom edge (the feet) on the bottom of the (smaller) hitbox.
- Character sheets paint tinted parts with **mask colors** (skin `#ffffff`,
  shirt `#ba46e0`, pants `#b3ff00`; `CharacterMask` in the client). The
  client recolors the whole sheet once per look and caches it, so every
  frame of a future animation is tinted the same way.
- The palette (Apollo, `sprites/apollo.hex`) and which colors each part
  allows are game rules: the server owns them (`appearance.ts`), validates
  picks and sends both in `Welcome`. A look travels as palette indexes.
- Until sprites exist, everything renders as debug colors and rectangles
  behind the `TileRenderer` interface (`packages/world_renderer`).

## Client

- Flutter + Flame, **web only for now**. Mobile is planned, so platform
  specifics stay behind interfaces (`GameTransport`, `TokenStorage`,
  `MovementInput`).
- Very Good Ventures standards: very_good_analysis, bloc, layered packages,
  100% test coverage.
- The camera uses whole-number zoom only (`targetViewHeight` 180 px) to keep
  pixels crisp.

## Server

- TypeScript on Cloudflare: a Worker for the HTTP API, **one Durable Object
  per zone**, Pages for the web client (not set up yet).
- **Fully authoritative**: clients send movement intents only. The client
  predicts its own player and replays unacknowledged inputs; other players
  are interpolated 100 ms in the past.
- 20 Hz tick. Positions are integer sub-pixels (16 per pixel) so the Dart and
  TS simulations match exactly.
- Procedural generation runs **server-side only**; clients receive chunks.
- Inputs use a token bucket (one per tick on average, burst of 3), so sending
  inputs faster doesn't make a player faster.

## Protocol and map format

- Protobuf for both the wire protocol and the map format, generated for Dart
  and TS from `proto/` with buf. Chunks stay protobuf "until it hurts"; a
  hand-rolled binary format was considered and deferred.
- One map format for the generator, the planned editor and stored edits:
  32×32-tile chunks with tile layers, a collision bitset, placed entities and
  per-tile state. See [map-format.md](map-format.md).
- A character's look rides on every `EntityState` (three varints) rather
  than in a separate join message; fine at this scale. Players without one
  are still sent, so the local player can reconcile, but clients don't draw
  them.
- Auth tokens travel in the first `Hello` message, not the URL, to keep them
  out of logs.

## Auth

- Guest login first: the server issues an HMAC-signed guest token and the
  client stores it. Account linking comes later on top of it.

## Map editor

- A separate Flutter app in the monorepo (`apps/editor`, not created yet),
  reusing `craftaria_map` and `world_renderer`.

## Repo and licensing

- Public on GitHub. Code is AGPL-3.0-only; art, audio and branding are all
  rights reserved (`ASSETS_LICENSE.md`).
- No CLA: the project is too small to need one. Contributions come in under
  AGPL. Revisit if relicensing ever matters.
- Monorepo: Dart pub workspace plus pnpm workspace. pnpm runs as
  `npx pnpm@10.34.9`.
- Squash merges only; `main` is protected and requires every CI check.
