// Keep in sync with packages/craftaria_map and packages/craftaria_sim.

/** Width and height of a tile in pixels. */
export const TILE_SIZE = 8;

/** Width and height of a chunk in tiles. */
export const CHUNK_SIZE = 32;

/** Positions are integers in sub-pixels so simulation is deterministic. */
export const SUBPIXELS_PER_PIXEL = 16;

/** Width and height of a tile in sub-pixels. */
export const TILE_SUBPIXELS = TILE_SIZE * SUBPIXELS_PER_PIXEL;

/** Server simulation ticks per second. */
export const TICK_RATE = 20;

/** Sub-pixels a player moves per tick along a single axis. */
export const PLAYER_SPEED = 40;

/** Sub-pixels a player moves per tick on each axis when moving diagonally. */
export const PLAYER_DIAGONAL_SPEED = 28;

/** Half the side of the player's square hitbox, in sub-pixels (3px). */
export const PLAYER_HALF_EXTENT = 48;
