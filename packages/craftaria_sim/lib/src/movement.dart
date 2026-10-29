import 'package:craftaria_map/craftaria_map.dart';
import 'package:craftaria_sim/src/constants.dart';
import 'package:craftaria_sim/src/position.dart';

// Port of server/world/src/movement.ts. Both implementations are checked
// against fixtures/movement_cases.json; change them together.

/// Whether the tile at world tile coordinates blocks movement.
typedef BlockedFn = bool Function(int tileX, int tileY);

/// Moves a hitbox centered on [along] by [delta] on one axis, stopping flush
/// against the first blocked tile. [perp] is the center on the other axis and
/// [isBlocked] takes (alongTile, perpTile).
int _moveAxis(int along, int perp, int delta, BlockedFn isBlocked) {
  if (delta == 0) return along;

  final target = along + delta;
  final edge = delta > 0
      ? target + playerHalfExtent - 1
      : target - playerHalfExtent;
  final edgeTile = floorDiv(edge, tileSubpixels);
  final perpStart = floorDiv(perp - playerHalfExtent, tileSubpixels);
  final perpEnd = floorDiv(perp + playerHalfExtent - 1, tileSubpixels);

  for (var p = perpStart; p <= perpEnd; p++) {
    if (isBlocked(edgeTile, p)) {
      return delta > 0
          ? edgeTile * tileSubpixels - playerHalfExtent
          : (edgeTile + 1) * tileSubpixels + playerHalfExtent;
    }
  }
  return target;
}

/// Advances a player by one simulation tick.
Position step(Position position, MoveIntent intent, BlockedFn isBlocked) {
  final dx = intent.dx.sign;
  final dy = intent.dy.sign;
  final speed = dx != 0 && dy != 0 ? playerDiagonalSpeed : playerSpeed;

  final x = _moveAxis(position.x, position.y, dx * speed, isBlocked);
  final y = _moveAxis(position.y, x, dy * speed, (a, p) => isBlocked(p, a));
  return Position(x, y);
}
