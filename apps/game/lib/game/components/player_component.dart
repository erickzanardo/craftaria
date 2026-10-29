import 'dart:ui';

import 'package:craftaria_sim/craftaria_sim.dart';
import 'package:flame/components.dart';

/// Draws a player as its hitbox until player sprites exist.
class PlayerComponent extends RectangleComponent {
  /// Creates a [PlayerComponent] that follows [locate] every frame.
  PlayerComponent({
    required this.playerId,
    required this.locate,
    required Color color,
  }) : super(
         size: Vector2.all(playerHalfExtent * 2 / subpixelsPerPixel),
         anchor: Anchor.center,
         paint: Paint()..color = color,
         priority: CraftariaLayers.entities,
       );

  /// Id of the player drawn.
  final String playerId;

  /// Current position of the player, or null while unknown.
  final Position? Function() locate;

  @override
  void update(double dt) {
    super.update(dt);
    final current = locate();
    if (current != null) position.setValues(current.pixelX, current.pixelY);
  }
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
