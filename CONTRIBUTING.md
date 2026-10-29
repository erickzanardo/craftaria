# Contributing to Craftaria

Thanks for your interest! Bug reports, ideas and code contributions are
welcome.

## Licensing in short

- **Code** is licensed under [AGPL-3.0-only](LICENSE). You can study it,
  learn from it and fork it. If you run or distribute a modified version,
  including as a game server other people play on, you must publish its
  complete source under the AGPL.
- **Art and audio** are proprietary, see [ASSETS_LICENSE.md](ASSETS_LICENSE.md).
  They cannot be used outside Craftaria. Forks must replace them.
- **Contributions** require signing the [CLA](CLA.md) once. A bot comments on
  your first pull request with instructions. You keep the copyright in your
  work; the CLA lets the maintainer relicense the project in the future.

## Art

All art is drawn by the maintainer. Please do not submit sprites, tiles,
audio or other assets, including generated or placeholder ones. If a feature
needs art, render it with debug shapes and colors in code and mention it in
the pull request.

## Development

See the [README](README.md) for setup. Before opening a pull request:

- Dart: `dart format`, `flutter analyze` and
  `very_good test --coverage --min-coverage 100` in every package you touched.
- Server: `pnpm typecheck` and `pnpm test`.
- Protocol changes go in `proto/`, followed by `pnpm proto`. Never edit
  generated code by hand.
- Movement rules exist in both `packages/craftaria_sim` and `server/world`.
  Change both, then regenerate `fixtures/` with
  `pnpm --filter @craftaria/world fixtures`.

## Secrets

This repository is public. Never commit credentials, tokens, `.dev.vars` or
`.env` files. CI scans every pull request for secrets.
