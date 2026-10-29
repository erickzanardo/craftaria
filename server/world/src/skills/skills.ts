import { levelForXp } from "./xp.ts";

/** Stable skill ids, as used in the protocol (spec/skills.md). */
export const SkillId = {
  woodcutting: "woodcutting",
} as const;

export type SkillId = (typeof SkillId)[keyof typeof SkillId];

export const ALL_SKILLS: readonly SkillId[] = Object.values(SkillId);

export function isSkillId(value: string): value is SkillId {
  return (ALL_SKILLS as readonly string[]).includes(value);
}

/** XP of one player in every skill. */
export class PlayerSkills {
  readonly #xp = new Map<SkillId, number>();

  xp(skill: SkillId): number {
    return this.#xp.get(skill) ?? 0;
  }

  level(skill: SkillId): number {
    return levelForXp(this.xp(skill));
  }

  /** Adds XP, returning whether the skill gained a level. */
  addXp(skill: SkillId, amount: number): boolean {
    const before = this.level(skill);
    this.#xp.set(skill, this.xp(skill) + Math.max(0, Math.floor(amount)));
    return this.level(skill) > before;
  }
}
