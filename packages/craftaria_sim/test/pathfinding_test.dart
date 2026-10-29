import 'package:craftaria_sim/craftaria_sim.dart';
import 'package:test/test.dart';

/// A map from rows of text: `#` blocks, anything else is open. Outside the
/// rows everything is open.
BlockedFn _map(List<String> rows) =>
    (x, y) =>
        y >= 0 &&
        y < rows.length &&
        x >= 0 &&
        x < rows[y].length &&
        rows[y][x] == '#';

void main() {
  group('isAdjacent', () {
    test('counts the 8 surrounding tiles only', () {
      const target = (x: 5, y: 5);
      expect(isAdjacent((x: 4, y: 4), target), isTrue);
      expect(isAdjacent((x: 5, y: 6), target), isTrue);
      expect(isAdjacent(target, target), isFalse);
      expect(isAdjacent((x: 7, y: 5), target), isFalse);
    });
  });

  group('findPathNextTo', () {
    test('is empty when already next to the target', () {
      expect(
        findPathNextTo(
          start: (x: 0, y: 0),
          target: (x: 1, y: 1),
          isBlocked: _map([]),
        ),
        isEmpty,
      );
    });

    test('goes around walls with 4-connected steps', () {
      final isBlocked = _map(['.....', '.###.', '.#T#.', '.#.#.', '.....']);
      final path = findPathNextTo(
        start: (x: 2, y: 4),
        target: (x: 2, y: 2),
        isBlocked: isBlocked,
      );
      // (2, 3) is open and next to the tree.
      expect(path, equals([(x: 2, y: 3)]));

      final wall = _map(['', '..#', '..#', '..#', '']);
      final around = findPathNextTo(
        start: (x: 0, y: 2),
        target: (x: 4, y: 2),
        isBlocked: wall,
      )!;
      expect(isAdjacent(around.last, (x: 4, y: 2)), isTrue);
      for (final tile in around) {
        expect(wall(tile.x, tile.y), isFalse);
      }
    });

    test('is null when nothing next to the target is reachable', () {
      final isBlocked = _map(['#####', '#...#', '#.T.#', '#...#', '#####']);
      expect(
        findPathNextTo(
          start: (x: 7, y: 2),
          target: (x: 2, y: 2),
          isBlocked: isBlocked,
          maxNodes: 200,
        ),
        isNull,
      );
    });
  });

  group('PathWalker', () {
    final isBlocked = _map([
      '#######',
      '#.....#',
      '#.###.#',
      '#.#T#.#',
      '#.....#',
      '#######',
    ]);

    Position center(int x, int y) => Position(
      x * tileSubpixels + tileSubpixels ~/ 2,
      y * tileSubpixels + tileSubpixels ~/ 2,
    );

    int walk(PathWalker walker, Position start, {int maxTicks = 200}) {
      var position = start;
      for (var tick = 0; tick < maxTicks; tick++) {
        final intent = walker.next(position);
        if (walker.arrived || walker.stuck) return tick;
        position = step(position, intent, isBlocked);
      }
      fail('did not arrive');
    }

    test('walks a path with turns from any offset in the start tile', () {
      // From the top right corner down and around to below the tree.
      for (final (dx, dy) in [(0, 0), (-16, 16), (16, -16), (12, 4)]) {
        final start = center(5, 1);
        final position = Position(start.x + dx, start.y + dy);
        final path = findPathNextTo(
          start: (x: 5, y: 1),
          target: (x: 3, y: 3),
          isBlocked: isBlocked,
        )!;
        final walker = PathWalker(path: path, isBlocked: isBlocked);
        walk(walker, position);
        expect(walker.arrived, isTrue, reason: 'offset ($dx, $dy)');
        expect(walker.next(position), equals(MoveIntent.idle));
      }
    });

    test('is arrived at once for an empty path', () {
      final walker = PathWalker(path: const [], isBlocked: isBlocked);
      expect(walker.arrived, isTrue);
      expect(walker.next(center(1, 1)), equals(MoveIntent.idle));
    });

    test('gets stuck when the next tile is walled off', () {
      final walker = PathWalker(
        path: const [(x: 3, y: 1), (x: 3, y: 2)],
        isBlocked: isBlocked,
      );
      walk(walker, center(3, 1));
      expect(walker.stuck, isTrue);
      expect(walker.arrived, isFalse);
      expect(walker.next(center(3, 1)), equals(MoveIntent.idle));
    });
  });
}
