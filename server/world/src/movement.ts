import {
  PLAYER_DIAGONAL_SPEED,
  PLAYER_HALF_EXTENT,
  PLAYER_SPEED,
  TILE_SUBPIXELS,
} from "./constants.ts";

// This file is mirrored by packages/craftaria_sim/lib/src/movement.dart and
// both implementations are checked against fixtures/movement_cases.json.

export interface Position {
  readonly x: number;
  readonly y: number;
}

export interface MoveIntent {
  readonly dx: number;
  readonly dy: number;
}

/** Whether the tile at world tile coordinates blocks movement. */
export type BlockedFn = (tileX: number, tileY: number) => boolean;

export function floorDiv(a: number, b: number): number {
  return Math.floor(a / b);
}

function sign(value: number): number {
  if (value > 0) return 1;
  if (value < 0) return -1;
  return 0;
}

/**
 * Moves a hitbox centered on `along` by `delta` on one axis, stopping flush
 * against the first blocked tile. `perp` is the hitbox center on the other
 * axis and `isBlocked` takes (alongTile, perpTile).
 *
 * Requires |delta| <= TILE_SUBPIXELS so only the leading edge needs checking.
 */
function moveAxis(
  along: number,
  perp: number,
  delta: number,
  isBlocked: BlockedFn,
): number {
  if (delta === 0) return along;

  const target = along + delta;
  const edge =
    delta > 0 ? target + PLAYER_HALF_EXTENT - 1 : target - PLAYER_HALF_EXTENT;
  const edgeTile = floorDiv(edge, TILE_SUBPIXELS);
  const perpStart = floorDiv(perp - PLAYER_HALF_EXTENT, TILE_SUBPIXELS);
  const perpEnd = floorDiv(perp + PLAYER_HALF_EXTENT - 1, TILE_SUBPIXELS);

  for (let p = perpStart; p <= perpEnd; p++) {
    if (isBlocked(edgeTile, p)) {
      return delta > 0
        ? edgeTile * TILE_SUBPIXELS - PLAYER_HALF_EXTENT
        : (edgeTile + 1) * TILE_SUBPIXELS + PLAYER_HALF_EXTENT;
    }
  }
  return target;
}

/** Advances a player by one simulation tick. */
export function step(
  position: Position,
  intent: MoveIntent,
  isBlocked: BlockedFn,
): Position {
  const dx = sign(intent.dx);
  const dy = sign(intent.dy);
  const speed = dx !== 0 && dy !== 0 ? PLAYER_DIAGONAL_SPEED : PLAYER_SPEED;

  const x = moveAxis(position.x, position.y, dx * speed, isBlocked);
  const y = moveAxis(position.y, x, dy * speed, (a, p) => isBlocked(p, a));
  return { x, y };
}
