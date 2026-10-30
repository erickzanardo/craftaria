import { describe, expect, it } from "vitest";
import { isValidAppearance, PALETTE, SKIN_COLORS } from "../src/index.ts";

describe("appearance", () => {
  it("holds the 46 Apollo colors, with skin taken from the brown ramps", () => {
    expect(PALETTE).toHaveLength(46);
    expect(PALETTE[0]).toBe(0x172038);
    expect(SKIN_COLORS.map((index) => PALETTE[index])).toEqual([
      0x4d2b32, 0x7a4841, 0xad7757, 0xc09473, 0xd7b594, 0xe7d5b3, 0x341c27, 0x602c2c,
    ]);
  });

  it("takes skin from the skin colors and clothes from the rest", () => {
    expect(isValidAppearance({ skin: 12, shirt: 0, pants: 45 })).toBe(true);
    expect(isValidAppearance({ skin: 19, shirt: 20, pants: 11 })).toBe(true);
    expect(isValidAppearance({ skin: 11, shirt: 0, pants: 1 })).toBe(false);
    expect(isValidAppearance({ skin: 20, shirt: 0, pants: 1 })).toBe(false);
    expect(isValidAppearance({ skin: 12, shirt: 12, pants: 1 })).toBe(false);
    expect(isValidAppearance({ skin: 12, shirt: 0, pants: 19 })).toBe(false);
    expect(isValidAppearance({ skin: 12, shirt: 46, pants: 1 })).toBe(false);
    expect(isValidAppearance({ skin: 12, shirt: 0, pants: -1 })).toBe(false);
    expect(isValidAppearance({ skin: 12, shirt: 0.5, pants: 1 })).toBe(false);
  });
});
