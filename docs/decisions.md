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

## Art

- All art is drawn by the author in Aseprite. **Never generate or commit
  placeholder art**, including golden test images.
- The game consumes **exported PNG sprite sheets**. Animation data (frame
  timings, sequences) is **hardcoded in code**; the author provides the
  values. No Aseprite JSON parsing.
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
