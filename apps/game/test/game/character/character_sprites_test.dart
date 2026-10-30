import 'dart:typed_data';

import 'package:craftaria/game/game.dart';
import 'package:flame/extensions.dart';
import 'package:flutter_test/flutter_test.dart';

/// One RGBA pixel per entry of [colors] (0xRRGGBB), all opaque except
/// [transparent] ones.
Uint8List _pixels(List<int> colors, {Set<int> transparent = const {}}) =>
    Uint8List.fromList([
      for (final (i, color) in colors.indexed) ...[
        (color >> 16) & 0xFF,
        (color >> 8) & 0xFF,
        color & 0xFF,
        if (transparent.contains(i)) 0 else 0xFF,
      ],
    ]);

void main() {
  group('recolor', () {
    test('repaints mapped visible colors and leaves the rest', () {
      final pixels = _pixels(
        [CharacterMask.skin, CharacterMask.shirt, 0x090A14, CharacterMask.skin],
        transparent: {3},
      );
      final result = recolor(pixels, {
        CharacterMask.skin: 0x4D2B32,
        CharacterMask.shirt: 0x172038,
      });
      expect(
        result,
        equals(
          _pixels(
            [0x4D2B32, 0x172038, 0x090A14, CharacterMask.skin],
            transparent: {3},
          ),
        ),
      );
      // The source is left untouched.
      expect(pixels.sublist(0, 3), equals([0xFF, 0xFF, 0xFF]));
    });
  });

  group('CharacterSprites', () {
    late Image sheet;
    late CharacterSprites sprites;

    // A 2x1 sheet: a skin pixel and a pants pixel.
    setUp(() async {
      sheet = await ImageExtension.fromPixels(
        _pixels([CharacterMask.skin, CharacterMask.pants]),
        2,
        1,
      );
      sprites = await CharacterSprites.load(
        sheet,
        palette: () => [for (var i = 0; i < 46; i++) i],
      );
    });

    test('makes each look once, tinted with its palette colors', () async {
      const look = CharacterLook(skin: 12, shirt: 20, pants: 30);
      expect(sprites.spriteFor(null), isNull);
      expect(sprites.spriteFor(look), isNull);
      expect(sprites.spriteFor(look), isNull);

      await sprites.settled;
      final sprite = sprites.spriteFor(look)!;
      expect(identical(sprite, sprites.spriteFor(look)), isTrue);
      expect(sprite.srcSize, equals(Vector2.all(characterSpriteSize)));
      expect(await sprite.image.pixelsInUint8(), equals(_pixels([12, 30])));
    });

    test('draws nothing for colors outside the palette', () async {
      const look = CharacterLook(skin: 12, shirt: 20, pants: 46);
      expect(sprites.spriteFor(look), isNull);
      await sprites.settled;
      expect(sprites.spriteFor(look), isNull);
    });
  });
}
