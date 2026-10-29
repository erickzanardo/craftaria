# Craftaria: notes for coding agents

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
  then run `pnpm --filter @craftaria/world fixtures` and both test suites.
- **Protocol changes** go in `proto/`, then `pnpm proto`. Bump
  `PROTOCOL_VERSION` / `protocolVersion` on breaking changes. Never hand-edit
  generated code.
- **Dart standards**: very_good_analysis, bloc, layered packages, 100% test
  coverage (`very_good test --coverage --min-coverage 100`).
- **Server standards**: strict TypeScript, vitest with 100% coverage on logic.
  Durable Object glue stays thin; logic lives in testable classes
  (`ZoneServer`, `ZoneSimulation`).
- Platform-specific code hides behind interfaces (`GameTransport`,
  `TokenStorage`, `MovementInput`) so mobile can be added later.
