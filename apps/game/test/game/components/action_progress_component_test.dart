import 'dart:ui';

import 'package:craftaria/game/components/action_progress_component.dart';
import 'package:craftaria_sim/craftaria_sim.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockCanvas extends Mock implements Canvas {}

void main() {
  setUpAll(() {
    registerFallbackValue(Rect.zero);
    registerFallbackValue(Paint());
  });

  group('ActionProgressComponent', () {
    test('sits above the located player', () {
      final component = ActionProgressComponent(
        locate: () => const Position(160, 320),
        progress: () => null,
      )..update(0);
      expect(
        component.position,
        equals(Vector2(10, 20 - ActionProgressComponent.offset)),
      );

      final unknown = ActionProgressComponent(
        locate: () => null,
        progress: () => 0.5,
      )..update(0);
      expect(unknown.position, equals(Vector2.zero()));
    });

    test('draws a filled bar only while an action runs', () {
      double? progress;
      Position? position = const Position(0, 0);
      final component = ActionProgressComponent(
        locate: () => position,
        progress: () => progress,
      );
      final canvas = _MockCanvas();

      component.render(canvas);
      verifyNever(() => canvas.drawRect(any(), any()));

      progress = 0.5;
      component.render(canvas);
      final rects = verify(
        () => canvas.drawRect(captureAny(), any()),
      ).captured.cast<Rect>();
      expect(rects.last.width, equals(ActionProgressComponent.barWidth / 2));

      position = null;
      component.render(canvas);
      verifyNever(() => canvas.drawRect(any(), any()));
    });

    testWithFlameGame('can be mounted', (game) async {
      await game.ensureAdd(
        ActionProgressComponent(locate: () => null, progress: () => null),
      );
    });
  });
}
