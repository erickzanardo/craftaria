import 'dart:convert';
import 'dart:io';

import 'package:craftaria_sim/craftaria_sim.dart';
import 'package:test/test.dart';

/// Shared with server/world so both simulations stay bit-identical.
final _fixture =
    jsonDecode(File('../../fixtures/movement_cases.json').readAsStringSync())
        as Map<String, dynamic>;

void main() {
  final blocked = {
    for (final tile in _fixture['blocked'] as List<dynamic>)
      (tile as List<dynamic>).join(','),
  };
  bool isBlocked(int x, int y) => blocked.contains('$x,$y');

  group('step', () {
    for (final testCase in _fixture['cases'] as List<dynamic>) {
      final data = testCase as Map<String, dynamic>;
      final start = data['start'] as Map<String, dynamic>;

      test('matches fixture: ${data['name']}', () {
        var position = Position(start['x'] as int, start['y'] as int);
        final actual = [
          for (final input in data['inputs'] as List<dynamic>)
            () {
              final [dx as int, dy as int] = input as List<dynamic>;
              position = step(position, MoveIntent(dx, dy), isBlocked);
              return [position.x, position.y];
            }(),
        ];
        expect(actual, equals(data['expected']));
      });
    }
  });
}
