import 'dart:ui';

import 'package:craftaria/game/components/player_component.dart';
import 'package:craftaria_sim/craftaria_sim.dart';
import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PlayerComponent', () {
    test('follows the located position in pixels', () {
      Position? position;
      final component = PlayerComponent(
        playerId: 'me',
        locate: () => position,
        color: const Color(0xFFFFFFFF),
      );
      expect(component.priority, equals(CraftariaLayers.entities));
      expect(component.size, equals(Vector2.all(6)));

      component.update(0);
      expect(component.position, equals(Vector2.zero()));

      position = const Position(160, -32);
      component.update(0);
      expect(component.position, equals(Vector2(10, -2)));
    });
  });
}
