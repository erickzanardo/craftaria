# Craftaria

A small top-down sandbox/crafting MMO. Flutter + Flame client, TypeScript
server on Cloudflare Workers and Durable Objects.

> All art is hand drawn by the author. Until sprites land, the game renders
> flat debug colors and rectangles.

## Layout

```
apps/
  game/                 Flutter + Flame client (web for now)
packages/               Dart, one pub workspace
  auth_repository/      guest tokens, storage-agnostic
  craftaria_map/        map format model (chunks, layers, collision, tile ids)
  craftaria_protocol/   generated protobuf code
  craftaria_sim/        movement, prediction, interpolation (mirrors server/world)
  game_client/          transport interface + WebSocket implementation
  world_renderer/       Flame chunk rendering, swappable tile renderer
server/                 TypeScript, one pnpm workspace
  protocol/             generated protobuf code
  world/                movement, worldgen, zone simulation (pure TS)
  worker/               Worker (HTTP API) + Zone Durable Object
proto/                  .proto sources of truth for the wire and map format
fixtures/               cross-language test vectors
docs/                   design notes
```

## How it fits together

- **Server is authoritative.** Clients send movement *intents* (`MoveInput`)
  at 20 Hz; the `Zone` Durable Object simulates, then broadcasts snapshots.
- **Client predicts** its own player with the same rules
  (`craftaria_sim` ⇄ `server/world`) and replays unacknowledged inputs on
  each snapshot. Other players are interpolated 100 ms in the past.
- **Positions are integer sub-pixels** (16 per pixel) so both simulations are
  bit-identical; `fixtures/movement_cases.json` is checked by both test suites.
- **Chunks** are 32×32 tiles of 8×8 px. Procedural chunks are generated
  server-side only and streamed to clients; see
  [docs/map-format.md](docs/map-format.md).
- **One Durable Object per zone.** Today there is a single zone, `overworld`.

## Prerequisites

- Flutter (stable, see `.github/workflows/dart.yml` for the pinned version)
- Node 22+ with Corepack (`corepack enable` or prefix commands with `corepack`)
- [very_good_cli](https://cli.vgv.dev) for coverage-gated tests (optional)

## Running locally

```sh
pnpm install
flutter pub get

# Server: create a local secret (never committed), then start wrangler.
cp server/worker/.dev.vars.example server/worker/.dev.vars
# edit .dev.vars, e.g. AUTH_SECRET=$(openssl rand -base64 48)
pnpm dev                                   # http://localhost:8787

# Client, in another terminal. Port 8080 matches ALLOWED_ORIGINS.
cd apps/game
flutter run -d chrome --web-port 8080
```

Point the client somewhere else with
`--dart-define=CRAFTARIA_API_URL=https://your-worker.example/`.

Open two browser tabs to see two players.

## Common tasks

| Task | Command |
| --- | --- |
| Regenerate protobuf code (Dart + TS) | `pnpm proto` |
| Regenerate movement fixtures | `pnpm --filter @craftaria/world fixtures` |
| Server tests / typecheck | `pnpm test` / `pnpm typecheck` |
| Dart package tests | `very_good test --coverage --min-coverage 100` in the package |

## Secrets

This repository is public. Never commit credentials.

- The token signing key is the `AUTH_SECRET` binding: `wrangler secret put
  AUTH_SECRET` in production, `server/worker/.dev.vars` locally (gitignored).
- Cloudflare account id and API token come from `CLOUDFLARE_ACCOUNT_ID` and
  `CLOUDFLARE_API_TOKEN` in your shell or CI secrets, not `wrangler.toml`.
- Client configuration (`--dart-define`) is compiled into the public web
  build, so it must never contain secrets.
- CI runs gitleaks on every push and pull request.

See [SECURITY.md](SECURITY.md) to report a vulnerability.
