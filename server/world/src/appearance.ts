// Character appearance: the colors a player picks when creating their
// character. See spec/characters.md.

/**
 * The game palette (Apollo), as 0xRRGGBB. Mirrors `sprites/apollo.hex`;
 * appearances store indexes into it.
 */
export const PALETTE: readonly number[] = [
  0x172038,
  0x253a5e,
  0x3c5e8b,
  0x4f8fba,
  0x73bed3,
  0xa4dddb,
  0x19332d,
  0x25562e,
  0x468232,
  0x75a743,
  0xa8ca58,
  0xd0da91,
  0x4d2b32,
  0x7a4841,
  0xad7757,
  0xc09473,
  0xd7b594,
  0xe7d5b3,
  0x341c27,
  0x602c2c,
  0x884b2b,
  0xbe772b,
  0xde9e41,
  0xe8c170,
  0x241527,
  0x411d31,
  0x752438,
  0xa53030,
  0xcf573c,
  0xda863e,
  0x1e1d39,
  0x402751,
  0x7a367b,
  0xa23e8c,
  0xc65197,
  0xdf84a5,
  0x090a14,
  0x10141f,
  0x151d28,
  0x202e37,
  0x394a50,
  0x577277,
  0x819796,
  0xa8b5b2,
  0xc7cfcc,
  0xebede9,
];

/** Palette indexes a character's skin can take: the brown ramps. */
export const SKIN_COLORS: readonly number[] = [12, 13, 14, 15, 16, 17, 18, 19];

/** One palette index per tinted part of a character. */
export interface Appearance {
  readonly skin: number;
  readonly shirt: number;
  readonly pants: number;
}

const isClothingColor = (index: number) =>
  Number.isInteger(index) &&
  index >= 0 &&
  index < PALETTE.length &&
  !SKIN_COLORS.includes(index);

/**
 * Whether every color is allowed for its part: skin from [SKIN_COLORS],
 * clothes from the rest of the palette.
 */
export function isValidAppearance({ skin, shirt, pants }: Appearance): boolean {
  return SKIN_COLORS.includes(skin) && isClothingColor(shirt) && isClothingColor(pants);
}
