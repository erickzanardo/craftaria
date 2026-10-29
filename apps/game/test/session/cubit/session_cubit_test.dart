import 'dart:async';

import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:craftaria/config/app_config.dart';
import 'package:craftaria/session/session.dart';
import 'package:craftaria_protocol/craftaria_protocol.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

void main() {
  final config = AppConfig(apiUri: Uri.parse('http://localhost:8787/'));

  group('SessionCubit', () {
    late MockAuthRepository authRepository;
    late StreamController<ServerMessage> messages;
    late MockGameClient client;

    setUp(() {
      authRepository = MockAuthRepository();
      when(authRepository.token).thenAnswer((_) async => 'token');
      when(authRepository.signOut).thenAnswer((_) async {});
      messages = StreamController.broadcast();
      client = mockGameClient(messages);
    });

    SessionCubit build() => SessionCubit(
      authRepository: authRepository,
      gameClientFactory: () => client,
      config: config,
    );

    test('starts in the initial state', () {
      expect(build().state, equals(const SessionState()));
    });

    blocTest<SessionCubit, SessionState>(
      'connects with the token and becomes connected on welcome',
      build: build,
      act: (cubit) async {
        await cubit.connect();
        messages.add(welcome());
      },
      expect: () => [
        isA<SessionState>()
            .having((s) => s.status, 'status', SessionStatus.connecting)
            .having((s) => s.world, 'world', isNotNull),
        isA<SessionState>()
            .having((s) => s.status, 'status', SessionStatus.connected)
            .having((s) => s.world, 'world', isNotNull),
      ],
      verify: (_) {
        verify(
          () => client.connect(config.zoneSocketUri, token: 'token'),
        ).called(1);
      },
    );

    blocTest<SessionCubit, SessionState>(
      'ignores other messages and stream errors',
      build: build,
      act: (cubit) async {
        await cubit.connect();
        messages
          ..add(snapshot({}))
          ..addError(Exception('bad frame'));
      },
      expect: () => [
        isA<SessionState>().having(
          (s) => s.status,
          'status',
          SessionStatus.connecting,
        ),
      ],
    );

    blocTest<SessionCubit, SessionState>(
      'fails when authentication fails',
      build: build,
      setUp: () =>
          when(authRepository.token).thenThrow(const AuthException('offline')),
      act: (cubit) => cubit.connect(),
      skip: 1,
      expect: () => [
        const SessionState(status: SessionStatus.failure, error: 'offline'),
      ],
    );

    blocTest<SessionCubit, SessionState>(
      'fails when the socket cannot connect',
      build: build,
      setUp: () => when(
        () => client.connect(any(), token: any(named: 'token')),
      ).thenThrow(Exception('refused')),
      act: (cubit) => cubit.connect(),
      skip: 1,
      expect: () => [
        const SessionState(
          status: SessionStatus.failure,
          error: 'Could not reach the game server.',
        ),
      ],
    );

    blocTest<SessionCubit, SessionState>(
      'signs out when the server rejects the token',
      build: build,
      act: (cubit) async {
        await cubit.connect();
        messages.add(
          ServerMessage(
            error: ServerError(
              code: ErrorCode.ERROR_CODE_UNAUTHORIZED,
              message: 'invalid token',
            ),
          ),
        );
        await messages.close();
      },
      skip: 1,
      expect: () => [
        const SessionState(
          status: SessionStatus.failure,
          error: 'invalid token',
        ),
      ],
      verify: (_) => verify(authRepository.signOut).called(1),
    );

    blocTest<SessionCubit, SessionState>(
      'keeps the token for other server errors',
      build: build,
      act: (cubit) async {
        await cubit.connect();
        messages.add(
          ServerMessage(
            error: ServerError(
              code: ErrorCode.ERROR_CODE_REPLACED,
              message: 'logged in elsewhere',
            ),
          ),
        );
      },
      skip: 1,
      expect: () => [
        const SessionState(
          status: SessionStatus.failure,
          error: 'logged in elsewhere',
        ),
      ],
      verify: (_) => verifyNever(authRepository.signOut),
    );

    blocTest<SessionCubit, SessionState>(
      'becomes disconnected when the server closes the connection',
      build: build,
      act: (cubit) async {
        await cubit.connect();
        await messages.close();
      },
      skip: 1,
      expect: () => [const SessionState(status: SessionStatus.disconnected)],
    );

    blocTest<SessionCubit, SessionState>(
      'reconnecting tears down the previous connection',
      build: build,
      act: (cubit) async {
        await cubit.connect();
        await cubit.connect();
      },
      skip: 1,
      expect: () => [
        isA<SessionState>().having(
          (s) => s.status,
          'status',
          SessionStatus.connecting,
        ),
      ],
      verify: (_) => verify(client.close).called(greaterThanOrEqualTo(1)),
    );
  });
}
