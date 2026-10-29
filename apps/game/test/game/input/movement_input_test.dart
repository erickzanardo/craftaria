import 'package:craftaria/game/input/movement_input.dart';
import 'package:craftaria_sim/craftaria_sim.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('KeyboardMovementInput', () {
    test('starts idle', () {
      expect(KeyboardMovementInput().intent, equals(MoveIntent.idle));
    });

    test('maps arrows and WASD to directions', () {
      final input = KeyboardMovementInput();
      final cases = {
        {LogicalKeyboardKey.arrowRight}: const MoveIntent(1, 0),
        {LogicalKeyboardKey.keyA}: const MoveIntent(-1, 0),
        {LogicalKeyboardKey.keyW, LogicalKeyboardKey.keyD}: const MoveIntent(
          1,
          -1,
        ),
        {LogicalKeyboardKey.arrowDown}: const MoveIntent(0, 1),
        {LogicalKeyboardKey.arrowLeft, LogicalKeyboardKey.arrowRight}:
            MoveIntent.idle,
      };
      for (final MapEntry(key: keys, value: intent) in cases.entries) {
        expect(input.onKeysPressed(keys), isTrue);
        expect(input.intent, equals(intent));
      }
    });

    test('reports non-movement keys as unhandled', () {
      final input = KeyboardMovementInput();
      expect(input.onKeysPressed({LogicalKeyboardKey.keyQ}), isFalse);
      expect(input.intent, equals(MoveIntent.idle));
    });
  });
}
