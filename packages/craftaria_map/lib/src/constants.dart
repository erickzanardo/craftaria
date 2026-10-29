// Keep in sync with server/world/src/constants.ts.

/// Width and height of a tile in pixels.
const tileSize = 8;

/// Width and height of a chunk in tiles.
const chunkSize = 32;

/// Number of tiles in a chunk.
const int tilesPerChunk = chunkSize * chunkSize;

/// Division rounding towards negative infinity, matching `Math.floor(a / b)`
/// on the server. Dart's `~/` truncates towards zero instead.
int floorDiv(int a, int b) {
  final quotient = a ~/ b;
  return (a % b != 0 && (a < 0) != (b < 0)) ? quotient - 1 : quotient;
}
