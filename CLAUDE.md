# Craftaria: notes for coding agents

Read [docs/decisions.md](docs/decisions.md) for why things are the way they
are and [docs/roadmap.md](docs/roadmap.md) for current state and next steps.
Update both when that changes. Game rules and mechanics (skills, items,
numbers) live in [spec/](spec/README.md); change the spec and the code
together.

- **Never create graphical assets** (sprites, tiles, icons, placeholder or
  golden images). All art is drawn by the author. Render with debug shapes and
  colors in code until real assets exist.
- **Licensing**: code is AGPL-3.0-only, assets are all rights reserved
  (`ASSETS_LICENSE.md`), contributions come in under AGPL. Don't add dependencies
  with licenses incompatible with AGPL-3.0.
- **Public repo: no secrets.** Secrets go in wrangler secrets or gitignored
  `.dev.vars`; no account ids in `wrangler.toml`.
- **Keep the two simulations identical.** `packages/craftaria_sim` mirrors
  `server/world/src/movement.ts`; constants mirror `server/world/src/constants.ts`
  and tile ids mirror `server/world/src/tiles.ts`. Change both sides together,
  then run `npx pnpm@10.34.9 --filter @craftaria/world fixtures` and both test suites.
- **Protocol changes** go in `proto/`, then `npx pnpm@10.34.9 proto`. Bump
  `PROTOCOL_VERSION` / `protocolVersion` on breaking changes. Never hand-edit
  generated code.
- **Dart standards**: very_good_analysis, bloc, layered packages, 100% test
  coverage (`very_good test --coverage --min-coverage 100`).
- **Server standards**: strict TypeScript, vitest with 100% coverage on logic.
  Durable Object glue stays thin; logic lives in testable classes
  (`ZoneServer`, `ZoneSimulation`).
- Run pnpm as `npx pnpm@10.34.9 …` (the `packageManager` version); update
  the docs if that version changes.
- **Game content data** (items, skills, trees, XP curve) is owned by the
  server (`server/world/src/skills/`, `server/world/src/items/`) and must
  match `spec/`. The client gets display data from the server and never
  duplicates the tables.
- Platform-specific code hides behind interfaces (`GameTransport`,
  `TokenStorage`, `MovementInput`) so mobile can be added later.

## Workflow gotchas

- **Dependabot bumps of `protobuf` / `protoc_plugin`** need the generated code
  regenerated (`npx pnpm@10.34.9 proto`) and committed on the PR branch,
  otherwise nothing compiles and the `generated` check fails.
- **Adding or renaming a Dart package or CI job**: update the matrix in
  `.github/workflows/dart.yml` *and* the required status checks of the `main`
  branch protection (`gh api repos/erickzanardo/craftaria/branches/main/protection`).
  Check names are the job names (`apps/game`, `packages/...`, `build web`,
  `test`, `generated`, `gitleaks`).
- **Squash merges** mean `git branch -d` refuses merged branches; compare the
  trees, then use `-D`.
- **Testing multiplayer locally**: tabs of the same browser share the guest
  token and replace each other; use a private window or a second browser.
- The local client must run on `--web-port 8080` to match `ALLOWED_ORIGINS`.
