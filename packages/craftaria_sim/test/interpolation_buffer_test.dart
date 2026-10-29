import 'package:craftaria_sim/craftaria_sim.dart';
import 'package:test/test.dart';

Duration _ms(int value) => Duration(milliseconds: value);

void main() {
  group('InterpolationBuffer', () {
    test('samples nothing when empty', () {
      final buffer = InterpolationBuffer();
      expect(buffer.isEmpty, isTrue);
      expect(buffer.sample(_ms(1000)), isNull);
    });

    test('interpolates between samples in the past', () {
      final buffer = InterpolationBuffer()
        ..add(_ms(1000), const Position(0, 0))
        ..add(_ms(1050), const Position(100, 0));

      expect(buffer.isEmpty, isFalse);
      expect(buffer.sample(_ms(1000)), equals(const Position(0, 0)));
      expect(buffer.sample(_ms(1125)), equals(const Position(50, 0)));
      expect(buffer.sample(_ms(1150)), equals(const Position(100, 0)));
    });

    test('holds the newest position when samples run out', () {
      final buffer = InterpolationBuffer()
        ..add(_ms(0), const Position(0, 0))
        ..add(_ms(50), const Position(10, 10));
      expect(buffer.sample(_ms(5000)), equals(const Position(10, 10)));
    });

    test('drops the oldest samples beyond capacity', () {
      final buffer = InterpolationBuffer(capacity: 2, delay: Duration.zero)
        ..add(_ms(0), const Position(0, 0))
        ..add(_ms(10), const Position(1, 0))
        ..add(_ms(20), const Position(2, 0));
      expect(buffer.sample(_ms(0)), equals(const Position(1, 0)));
    });
  });
}
