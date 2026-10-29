import 'package:craftaria_sim/src/position.dart';

/// Buffers timestamped positions of a remote entity and samples them in the
/// past so movement looks smooth despite snapshots arriving in bursts.
class InterpolationBuffer {
  /// Creates an [InterpolationBuffer].
  InterpolationBuffer({
    this.delay = const Duration(milliseconds: 100),
    this.capacity = 32,
  });

  /// How far in the past entities are rendered.
  final Duration delay;

  /// Maximum samples kept.
  final int capacity;

  final _samples = <({Duration time, Position position})>[];

  /// Whether no position was received yet.
  bool get isEmpty => _samples.isEmpty;

  /// Records [position] received at [time].
  void add(Duration time, Position position) {
    _samples.add((time: time, position: position));
    if (_samples.length > capacity) _samples.removeAt(0);
  }

  /// Position to render at [now], or null when no sample exists.
  Position? sample(Duration now) {
    if (_samples.isEmpty) return null;
    final target = now - delay;

    if (target <= _samples.first.time) return _samples.first.position;
    for (var i = 1; i < _samples.length; i++) {
      final b = _samples[i];
      if (target <= b.time) {
        // target > a.time here, otherwise the previous iteration returned.
        final a = _samples[i - 1];
        final t =
            (target - a.time).inMicroseconds / (b.time - a.time).inMicroseconds;
        return Position.lerp(a.position, b.position, t);
      }
    }
    return _samples.last.position;
  }
}
