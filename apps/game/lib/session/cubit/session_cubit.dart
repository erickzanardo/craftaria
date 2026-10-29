import 'dart:async';

import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:craftaria/config/app_config.dart';
import 'package:craftaria/game/client_world.dart';
import 'package:craftaria_protocol/craftaria_protocol.dart';
import 'package:equatable/equatable.dart';
import 'package:game_client/game_client.dart';

part 'session_state.dart';

/// Creates a fresh [GameClient]; each one is good for a single connection.
typedef GameClientFactory = GameClient Function();

/// Authenticates and keeps a connection to a zone.
class SessionCubit extends Cubit<SessionState> {
  /// Creates a [SessionCubit].
  SessionCubit({
    required AuthRepository authRepository,
    required GameClientFactory gameClientFactory,
    required AppConfig config,
  }) : _authRepository = authRepository,
       _gameClientFactory = gameClientFactory,
       _config = config,
       super(const SessionState());

  final AuthRepository _authRepository;
  final GameClientFactory _gameClientFactory;
  final AppConfig _config;

  GameClient? _client;
  StreamSubscription<ServerMessage>? _subscription;

  /// Connects, replacing any previous connection.
  Future<void> connect() async {
    await _teardown();
    final client = _client = _gameClientFactory();
    // Subscribe before connecting so no message is missed.
    final world = ClientWorld(client: client);
    _subscription = client.messages.listen(
      _onMessage,
      onError: (_) {},
      onDone: _onDone,
    );
    emit(SessionState(status: SessionStatus.connecting, world: world));

    try {
      final token = await _authRepository.token();
      await client.connect(_config.zoneSocketUri, token: token);
    } on AuthException catch (error) {
      emit(SessionState(status: SessionStatus.failure, error: error.message));
    } on Exception {
      emit(
        const SessionState(
          status: SessionStatus.failure,
          error: 'Could not reach the game server.',
        ),
      );
    }
  }

  void _onMessage(ServerMessage message) {
    switch (message.whichPayload()) {
      case ServerMessage_Payload.welcome:
        emit(SessionState(status: SessionStatus.connected, world: state.world));
      case ServerMessage_Payload.error:
        if (message.error.code == ErrorCode.ERROR_CODE_UNAUTHORIZED) {
          unawaited(_authRepository.signOut());
        }
        emit(
          SessionState(
            status: SessionStatus.failure,
            error: message.error.message,
          ),
        );
      case _:
        break;
    }
  }

  void _onDone() {
    if (state.status == SessionStatus.failure) return;
    emit(const SessionState(status: SessionStatus.disconnected));
  }

  Future<void> _teardown() async {
    await _subscription?.cancel();
    await state.world?.dispose();
    await _client?.close();
    _subscription = null;
    _client = null;
  }

  @override
  Future<void> close() async {
    await _teardown();
    await super.close();
  }
}
