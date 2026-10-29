import 'package:craftaria_sim/src/movement.dart';
import 'package:craftaria_sim/src/position.dart';

/// An input the server has not acknowledged yet.
typedef PendingInput = ({int seq, MoveIntent intent});

/// The local player, predicted ahead of the authoritative server.
///
/// Inputs are applied immediately and remembered until a snapshot
/// acknowledges them. On every snapshot the server position is taken as the
/// truth and the unacknowledged inputs are replayed on top of it.
class PredictedPlayer {
  /// Creates a [PredictedPlayer] at [position].
  PredictedPlayer({required Position position, required this.isBlocked})
    : _position = position,
      _previous = position;

  /// Collision used for prediction.
  final BlockedFn isBlocked;

  final _pending = <PendingInput>[];
  Position _position;
  Position _previous;
  int _seq = 0;

  /// Predicted position after the latest input.
  Position get position => _position;

  /// Position before the latest input, for render interpolation.
  Position get previous => _previous;

  /// Inputs not acknowledged by the server yet.
  List<PendingInput> get pending => List.unmodifiable(_pending);

  /// Applies [intent] locally and returns the input to send to the server.
  PendingInput apply(MoveIntent intent) {
    final input = (seq: ++_seq, intent: intent);
    _pending.add(input);
    _previous = _position;
    _position = step(_position, intent, isBlocked);
    return input;
  }

  /// Takes the next sequence number for a non-movement input (such as a
  /// gather) that must stay ordered with the moves.
  int reserveSeq() => ++_seq;

  /// Marks a tick without movement, so render interpolation settles.
  void hold() => _previous = _position;

  /// Rebases the prediction on the server state.
  void reconcile({required Position server, required int lastInputSeq}) {
    _pending.removeWhere((input) => input.seq <= lastInputSeq);
    var position = server;
    for (final input in _pending) {
      position = step(position, input.intent, isBlocked);
    }
    _position = position;
  }
}
