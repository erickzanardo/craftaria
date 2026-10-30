import 'dart:ui';

import 'package:craftaria/game/components/player_component.dart';
import 'package:craftaria/game/game.dart';
import 'package:craftaria_sim/craftaria_sim.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockCanvas extends Mock implements Canvas {}

void main() {
  group('PlayerComponent', () {
    late Image sheet;
    late CharacterSprites sprites;

    setUp(() async {
      sheet = await generateImage(8, 8);
      registerFallbackValue(sheet);
      registerFallbackValue(Rect.zero);
      registerFallbackValue(Paint());
      sprites = await CharacterSprites.load(sheet, palette: () => testPalette);
    });

    test('follows the located position in pixels', () {
      Position? position;
      final component = PlayerComponent(
        playerId: 'me',
        locate: () => position,
        look: () => testLook,
        sprites: sprites,
      );
      expect(component.priority, equals(CraftariaLayers.entities));
      expect(component.size, equals(Vector2.all(characterSpriteSize)));
      // The 6px hitbox spans y -3..3 around the position, so the 8px sprite
      // spans -5..3 to stand on its bottom.
      expect(component.anchor, equals(const Anchor(0.5, 5 / 8)));

      component.update(0);
      expect(component.position, equals(Vector2.zero()));

      position = const Position(160, -32);
      component.update(0);
      expect(component.position, equals(Vector2(10, -2)));
    });

    test('draws the sprite of its look once it is made', () async {
      CharacterLook? look;
      final component = PlayerComponent(
        playerId: 'me',
        locate: () => null,
        look: () => look,
        sprites: sprites,
      );
      final canvas = _MockCanvas();
      component
        ..update(0)
        ..render(canvas);
      verifyNever(() => canvas.drawImageRect(any(), any(), any(), any()));

      look = testLook;
      component
        ..update(0)
        ..render(canvas);
      verifyNever(() => canvas.drawImageRect(any(), any(), any(), any()));

      await sprites.settled;
      component
        ..update(0)
        ..render(canvas);
      verify(() => canvas.drawImageRect(any(), any(), any(), any())).called(1);
    });
  });
}
