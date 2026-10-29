import 'package:craftaria_map/craftaria_map.dart';

// Keep in sync with server/world/src/constants.ts.

/// Positions are integers in sub-pixels so simulation is deterministic.
const subpixelsPerPixel = 16;

/// Width and height of a tile in sub-pixels.
const int tileSubpixels = tileSize * subpixelsPerPixel;

/// Simulation ticks per second, on both client and server.
const tickRate = 20;

/// Duration of one simulation tick in seconds.
const double tickSeconds = 1 / tickRate;

/// Sub-pixels a player moves per tick along a single axis.
const playerSpeed = 40;

/// Sub-pixels a player moves per tick on each axis when moving diagonally.
const playerDiagonalSpeed = 28;

/// Half the side of the player's square hitbox, in sub-pixels (3px).
const playerHalfExtent = 48;
