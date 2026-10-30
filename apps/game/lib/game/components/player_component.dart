import 'dart:ui';

import 'package:craftaria/game/character/character_look.dart';
import 'package:craftaria/game/character/character_sprites.dart';
import 'package:craftaria_sim/craftaria_sim.dart';
import 'package:flame/components.dart';

/// Half the hitbox size in pixels.
const double _halfHitbox = playerHalfExtent / subpixelsPerPixel;

/// Places the sprite so its bottom edge, the character's feet, sits on the
/// bottom of the hitbox centered on the player's position.
const _feetAnchor = Anchor(
  0.5,
  (characterSpriteSize - _halfHitbox) / characterSpriteSize,
);

/// Draws a player with the sprite of their character look.
class PlayerComponent extends PositionComponent {
  /// Creates a [PlayerComponent] that follows [locate] and [look] every
  /// frame, drawing with [sprites].
  PlayerComponent({
    required this.playerId,
    required this.locate,
    required this.look,
    required this.sprites,
  }) : super(
         size: Vector2.all(characterSpriteSize),
         anchor: _feetAnchor,
         priority: CraftariaLayers.entities,
       );

  /// Id of the player drawn.
  final String playerId;

  /// Current position of the player, or null while unknown.
  final Position? Function() locate;

  /// Current look of the player, or null while unknown.
  final CharacterLook? Function() look;

  /// Tinted character sprites.
  final CharacterSprites sprites;

  Sprite? _sprite;

  @override
  void update(double dt) {
    super.update(dt);
    _sprite = sprites.spriteFor(look());
    final current = locate();
    if (current != null) position.setValues(current.pixelX, current.pixelY);
  }

  // Nothing is drawn until the look's sprite is made.
  @override
  void render(Canvas canvas) => _sprite?.render(canvas, size: size);
}

/// Draw order of world components.
abstract final class CraftariaLayers {
  /// Tile layers below entities.
  static const ground = 0;

  /// Players and objects.
  static const entities = 50;

  /// Tile layers above entities.
  static const overlay = 100;
}
