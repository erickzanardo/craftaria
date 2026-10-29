// XP curve from spec/skills.md. Tunable.

/** Highest level a skill can reach. XP keeps accumulating past it. */
export const MAX_LEVEL = 100;

/** XP needed for level 2 is roughly XP_SCALE × (2^(1/10) − 1). */
const XP_SCALE = 1115;

/** XP needed per level doubles every this many levels. */
const DOUBLING_LEVELS = 10;

/** Total XP to reach each level; index 0 is level 1. */
const XP_TABLE: readonly number[] = Array.from({ length: MAX_LEVEL }, (_, i) =>
  Math.round(XP_SCALE * (2 ** (i / DOUBLING_LEVELS) - 1)),
);

/** Total XP needed to reach [level], clamped to 1..MAX_LEVEL. */
export function xpForLevel(level: number): number {
  const clamped = Math.min(Math.max(Math.floor(level), 1), MAX_LEVEL);
  return XP_TABLE[clamped - 1]!;
}

/** Level reached with [xp] total XP. */
export function levelForXp(xp: number): number {
  let level = 1;
  while (level < MAX_LEVEL && XP_TABLE[level]! <= xp) level++;
  return level;
}

export interface LevelProgress {
  readonly level: number;
  readonly xp: number;
  /** Total XP at which the current level started. */
  readonly levelXp: number;
  /** Total XP for the next level; equals [levelXp] at the cap. */
  readonly nextLevelXp: number;
}

export function progressFor(xp: number): LevelProgress {
  const level = levelForXp(xp);
  return {
    level,
    xp,
    levelXp: xpForLevel(level),
    nextLevelXp: level === MAX_LEVEL ? xpForLevel(level) : xpForLevel(level + 1),
  };
}
