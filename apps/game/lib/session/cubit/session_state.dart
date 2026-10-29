part of 'session_cubit.dart';

/// Lifecycle of a connection to a zone.
enum SessionStatus {
  /// Not started.
  initial,

  /// Authenticating and opening the socket.
  connecting,

  /// Welcomed by the server; [SessionState.world] is live.
  connected,

  /// The server closed the connection.
  disconnected,

  /// Something went wrong; see [SessionState.error].
  failure,
}

/// State of [SessionCubit].
class SessionState extends Equatable {
  /// Creates a [SessionState].
  const SessionState({
    this.status = SessionStatus.initial,
    this.world,
    this.error,
  });

  /// Current status.
  final SessionStatus status;

  /// The world of the current connection, once connecting started.
  final ClientWorld? world;

  /// Human readable failure reason.
  final String? error;

  @override
  List<Object?> get props => [status, world, error];
}
