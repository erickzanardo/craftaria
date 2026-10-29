import 'package:craftaria_sim/src/constants.dart';
import 'package:equatable/equatable.dart';

/// A position in integer sub-pixels.
class Position extends Equatable {
  /// Creates a [Position].
  const Position(this.x, this.y);

  /// Linear interpolation between [a] and [b], rounded to sub-pixels.
  factory Position.lerp(Position a, Position b, double t) => Position(
    (a.x + (b.x - a.x) * t).round(),
    (a.y + (b.y - a.y) * t).round(),
  );

  /// Horizontal sub-pixels.
  final int x;

  /// Vertical sub-pixels.
  final int y;

  /// Horizontal position in pixels.
  double get pixelX => x / subpixelsPerPixel;

  /// Vertical position in pixels.
  double get pixelY => y / subpixelsPerPixel;

  @override
  List<Object> get props => [x, y];
}

/// Movement intent for one tick. Each axis is -1, 0 or 1.
class MoveIntent extends Equatable {
  /// Creates a [MoveIntent].
  const MoveIntent(this.dx, this.dy);

  /// No movement.
  static const idle = MoveIntent(0, 0);

  /// Horizontal direction.
  final int dx;

  /// Vertical direction.
  final int dy;

  /// Whether the intent moves at all.
  bool get isIdle => dx == 0 && dy == 0;

  @override
  List<Object> get props => [dx, dy];
}
