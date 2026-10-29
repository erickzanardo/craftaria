import 'package:craftaria_sim/craftaria_sim.dart';
import 'package:test/test.dart';

void main() {
  group('Position', () {
    test('converts to pixels', () {
      const position = Position(32, -8);
      expect(position.pixelX, equals(2));
      expect(position.pixelY, equals(-0.5));
    });

    test('lerp rounds to sub-pixels', () {
      expect(
        Position.lerp(const Position(0, 0), const Position(10, -10), 0.25),
        equals(const Position(3, -3)),
      );
    });
  });

  group('MoveIntent', () {
    test('supports value equality', () {
      // Non-const instances so equality goes through props.
      // ignore: prefer_const_constructors
      expect(MoveIntent(1, -1), equals(MoveIntent(1, -1)));
    });

    test('isIdle', () {
      expect(MoveIntent.idle.isIdle, isTrue);
      expect(const MoveIntent(1, 0).isIdle, isFalse);
      expect(const MoveIntent(0, -1).isIdle, isFalse);
    });
  });
}
