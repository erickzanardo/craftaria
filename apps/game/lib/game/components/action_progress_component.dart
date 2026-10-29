import 'dart:ui';

import 'package:craftaria/game/components/player_component.dart';
import 'package:craftaria_sim/craftaria_sim.dart';
import 'package:flame/components.dart';

/// Debug progress bar over the local player while an action runs.
class ActionProgressComponent extends PositionComponent {
  /// Creates an [ActionProgressComponent] following [locate] and showing
  /// [progress] (0 to 1, null when idle).
  ActionProgressComponent({required this.locate, required this.progress})
    : super(
        size: Vector2(barWidth, barHeight),
        anchor: Anchor.bottomCenter,
        priority: CraftariaLayers.entities + 1,
      );

  /// Width of the bar in world pixels.
  static const barWidth = 10.0;

  /// Height of the bar in world pixels.
  static const barHeight = 2.0;

  /// Gap between the player's center and the bar's bottom, in pixels.
  static const offset = 5.0;

  /// Color of the empty bar.
  static const backgroundColor = Color(0xFF202020);

  /// Color of the filled part.
  static const fillColor = Color(0xFF66D9E8);

  /// Where the player is, or null while unknown.
  final Position? Function() locate;

  /// Current progress, or null while idle.
  final double? Function() progress;

  final _background = Paint()..color = backgroundColor;
  final _fill = Paint()..color = fillColor;

  @override
  void update(double dt) {
    super.update(dt);
    final current = locate();
    if (current != null) {
      position.setValues(current.pixelX, current.pixelY - offset);
    }
  }

  @override
  void render(Canvas canvas) {
    final value = progress();
    if (value == null || locate() == null) return;
    canvas
      ..drawRect(size.toRect(), _background)
      ..drawRect(Rect.fromLTWH(0, 0, size.x * value, size.y), _fill);
  }
}
