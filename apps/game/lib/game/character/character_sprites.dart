import 'dart:typed_data';

import 'package:craftaria/game/character/character_look.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

/// Size in pixels of a character sprite.
const characterSpriteSize = 8.0;

/// Colors the character sheet paints each tinted part with, as 0xRRGGBB.
abstract final class CharacterMask {
  /// Skin.
  static const skin = 0xFFFFFF;

  /// Shirt.
  static const shirt = 0xBA46E0;

  /// Pants.
  static const pants = 0xB3FF00;
}

/// A copy of the RGBA [pixels] with every visible pixel whose color is a key
/// of [colors] repainted with its value, keeping its alpha. Colors are
/// 0xRRGGBB.
Uint8List recolor(Uint8List pixels, Map<int, int> colors) {
  final result = Uint8List.fromList(pixels);
  for (var i = 0; i < result.length; i += 4) {
    if (result[i + 3] == 0) continue;
    final color = (result[i] << 16) | (result[i + 1] << 8) | result[i + 2];
    final replacement = colors[color];
    if (replacement == null) continue;
    result
      ..[i] = (replacement >> 16) & 0xFF
      ..[i + 1] = (replacement >> 8) & 0xFF
      ..[i + 2] = replacement & 0xFF;
  }
  return result;
}

/// Character sprites tinted per [CharacterLook], made on demand from the
/// character sheet and cached.
class CharacterSprites {
  CharacterSprites._(this._sheet, this._pixels, this._palette);

  /// Reads the pixels of [sheet]. [palette] gives the 0xRRGGBB colors looks
  /// index into.
  static Future<CharacterSprites> load(
    Image sheet, {
    required List<int> Function() palette,
  }) async => CharacterSprites._(sheet, await sheet.pixelsInUint8(), palette);

  final Image _sheet;
  final Uint8List _pixels;
  final List<int> Function() _palette;
  final _sprites = <CharacterLook, Sprite?>{};
  final _pending = <Future<void>>[];

  /// The sprite of [look], or null while it is being made or when [look]
  /// is null or outside the palette.
  Sprite? spriteFor(CharacterLook? look) {
    if (look == null) return null;
    if (_sprites.containsKey(look)) return _sprites[look];
    _sprites[look] = null;
    final palette = _palette();
    final colors = [look.skin, look.shirt, look.pants];
    if (colors.any((index) => index >= palette.length)) return null;
    final pixels = recolor(_pixels, {
      CharacterMask.skin: palette[look.skin],
      CharacterMask.shirt: palette[look.shirt],
      CharacterMask.pants: palette[look.pants],
    });
    _pending.add(
      ImageExtension.fromPixels(pixels, _sheet.width, _sheet.height).then(
        (image) => _sprites[look] = Sprite(
          image,
          srcSize: Vector2.all(characterSpriteSize),
        ),
      ),
    );
    return null;
  }

  /// Completes once every sprite asked for so far is made.
  Future<void> get settled => Future.wait(_pending);
}
