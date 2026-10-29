import 'package:craftaria_sim/craftaria_sim.dart';
import 'package:flutter/services.dart';

/// Source of the local player's movement intent.
///
/// Keyboard for web and desktop now; a touch joystick will implement this
/// for mobile.
abstract interface class MovementInput {
  /// The intent for the current tick.
  MoveIntent get intent;
}

/// [MovementInput] from arrow keys and WASD.
class KeyboardMovementInput implements MovementInput {
  static final Set<LogicalKeyboardKey> _left = {
    LogicalKeyboardKey.arrowLeft,
    LogicalKeyboardKey.keyA,
  };
  static final Set<LogicalKeyboardKey> _right = {
    LogicalKeyboardKey.arrowRight,
    LogicalKeyboardKey.keyD,
  };
  static final Set<LogicalKeyboardKey> _up = {
    LogicalKeyboardKey.arrowUp,
    LogicalKeyboardKey.keyW,
  };
  static final Set<LogicalKeyboardKey> _down = {
    LogicalKeyboardKey.arrowDown,
    LogicalKeyboardKey.keyS,
  };

  MoveIntent _intent = MoveIntent.idle;

  @override
  MoveIntent get intent => _intent;

  /// Updates the intent from the keys currently held. Returns whether any of
  /// them is a movement key.
  bool onKeysPressed(Set<LogicalKeyboardKey> keys) {
    bool any(Set<LogicalKeyboardKey> group) => keys.any(group.contains);
    final left = any(_left);
    final right = any(_right);
    final up = any(_up);
    final down = any(_down);
    _intent = MoveIntent(
      (right ? 1 : 0) - (left ? 1 : 0),
      (down ? 1 : 0) - (up ? 1 : 0),
    );
    return left || right || up || down;
  }
}
