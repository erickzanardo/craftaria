import 'dart:collection';

import 'package:craftaria_sim/src/movement.dart';

// Client-only: the server never pathfinds, so this is not mirrored in
// server/world.

/// A world tile.
typedef Tile = ({int x, int y});

/// Most tiles a search visits before giving up.
const maxPathNodes = 4096;

const _steps = <Tile>[(x: 1, y: 0), (x: -1, y: 0), (x: 0, y: 1), (x: 0, y: -1)];

/// Whether [tile] is one of the 8 tiles around [target] (the reach rule in
/// spec/interaction.md).
bool isAdjacent(Tile tile, Tile target) {
  final dx = (tile.x - target.x).abs();
  final dy = (tile.y - target.y).abs();
  return dx <= 1 && dy <= 1 && (dx != 0 || dy != 0);
}

/// Shortest 4-connected path of walkable tiles from [start] to a tile next
/// to [target], excluding [start]. Empty when [start] is already next to
/// [target]; null when no such tile is reachable within [maxNodes].
List<Tile>? findPathNextTo({
  required Tile start,
  required Tile target,
  required BlockedFn isBlocked,
  int maxNodes = maxPathNodes,
}) {
  final cameFrom = <Tile, Tile?>{start: null};
  final queue = Queue<Tile>()..add(start);
  while (queue.isNotEmpty && cameFrom.length <= maxNodes) {
    final tile = queue.removeFirst();
    if (isAdjacent(tile, target)) {
      final path = <Tile>[];
      for (Tile? at = tile; at != start; at = cameFrom[at]) {
        path.add(at!);
      }
      return path.reversed.toList();
    }
    for (final step in _steps) {
      final next = (x: tile.x + step.x, y: tile.y + step.y);
      if (cameFrom.containsKey(next) || isBlocked(next.x, next.y)) continue;
      cameFrom[next] = tile;
      queue.add(next);
    }
  }
  return null;
}
