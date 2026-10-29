import 'package:craftaria_map/craftaria_map.dart';
import 'package:craftaria_sim/src/constants.dart';
import 'package:craftaria_sim/src/movement.dart';
import 'package:craftaria_sim/src/pathfinding.dart';
import 'package:craftaria_sim/src/position.dart';

/// Turns a path of tiles into one [MoveIntent] per tick.
///
/// Each tick it picks the direction whose simulated step gets closest to the
/// center of the next tile on the path, so collisions are handled exactly as
/// the server handles them. A tile counts as reached once the player's
/// center is on it.
class PathWalker {
  /// Creates a [PathWalker] along [path].
  PathWalker({required List<Tile> path, required this.isBlocked})
    : _path = List.of(path);

  /// Collision used to simulate candidate steps.
  final BlockedFn isBlocked;

  final List<Tile> _path;

  bool _stuck = false;

  static const _directions = [
    MoveIntent(1, 0),
    MoveIntent(-1, 0),
    MoveIntent(0, 1),
    MoveIntent(0, -1),
    MoveIntent(1, 1),
    MoveIntent(1, -1),
    MoveIntent(-1, 1),
    MoveIntent(-1, -1),
  ];

  /// Whether every tile of the path has been reached.
  bool get arrived => _path.isEmpty;

  /// Whether no step gets closer to the next tile, so the walk can't go on.
  bool get stuck => _stuck;

  /// The intent for this tick from [position], or [MoveIntent.idle] once
  /// arrived or stuck.
  MoveIntent next(Position position) {
    _dropReached(position);
    if (arrived || _stuck) return MoveIntent.idle;

    final target = _path.first;
    final goalX = target.x * tileSubpixels + tileSubpixels ~/ 2;
    final goalY = target.y * tileSubpixels + tileSubpixels ~/ 2;
    int distance(Position p) =>
        (p.x - goalX) * (p.x - goalX) + (p.y - goalY) * (p.y - goalY);

    var best = MoveIntent.idle;
    var bestDistance = distance(position);
    for (final intent in _directions) {
      final candidate = distance(step(position, intent, isBlocked));
      if (candidate < bestDistance) {
        best = intent;
        bestDistance = candidate;
      }
    }
    _stuck = best.isIdle;
    return best;
  }

  void _dropReached(Position position) {
    final tile = (
      x: floorDiv(position.x, tileSubpixels),
      y: floorDiv(position.y, tileSubpixels),
    );
    // The player may cut a corner and reach a later tile first.
    final index = _path.indexOf(tile);
    if (index >= 0) _path.removeRange(0, index + 1);
  }
}
