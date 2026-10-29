# Game spec

The rules and mechanics of Craftaria, written for humans. This is the source
of truth for *what the game does*; [docs/](../docs) explains *how and why the
code is built*.

The server implements these rules and must match them. When a rule or a
number changes, change the spec and the code in the same commit.

## Conventions

- Time is given in seconds and in server ticks (20 ticks per second). The
  code works in ticks.
- Values marked *tunable* are placeholders for balancing. Change them freely,
  but keep the spec and the code in step.
- Every file ends with **Open questions**: things not decided yet. Code must
  not depend on an answer to an open question.
- Ids in `code font` (`pine_log`, `woodcutting`) are stable identifiers that
  appear in the protocol and in saved data. Don't rename them.

## Index

- [skills.md](skills.md): skills, XP and levels, and the gathering model
  every gathering skill follows.
- [skills/woodcutting.md](skills/woodcutting.md): axes and trees.
- [items.md](items.md): items, the inventory and equipment.
- [interaction.md](interaction.md): how players act on the world.
