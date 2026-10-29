import 'dart:async';

import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:craftaria/config/app_config.dart';
import 'package:craftaria/game/game.dart';
import 'package:craftaria/session/session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_client/game_client.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

void main() {
  group('SessionPage', () {
    testWidgets('creates a cubit and connects', (tester) async {
      final authRepository = MockAuthRepository();
      final tokenRequested = Completer<String>();
      when(authRepository.token).thenAnswer((_) => tokenRequested.future);
      GameClient factory() => mockGameClient(StreamController());

      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(
              value: AppConfig(apiUri: Uri.parse('http://localhost:8787/')),
            ),
            RepositoryProvider<AuthRepository>.value(value: authRepository),
            RepositoryProvider<GameClientFactory>.value(value: factory),
          ],
          child: const MaterialApp(home: SessionPage()),
        ),
      );

      expect(find.byType(SessionView), findsOneWidget);
      verify(authRepository.token).called(1);
    });
  });

  group('SessionView', () {
    late _MockSessionCubit cubit;

    setUp(() {
      cubit = _MockSessionCubit();
      when(cubit.connect).thenAnswer((_) async {});
    });

    Future<void> pump(WidgetTester tester, SessionState state) {
      when(() => cubit.state).thenReturn(state);
      return tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<SessionCubit>.value(
            value: cubit,
            child: const SessionView(),
          ),
        ),
      );
    }

    testWidgets('shows progress while connecting', (tester) async {
      await pump(tester, const SessionState(status: SessionStatus.connecting));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows the game when connected', (tester) async {
      final world = ClientWorld(client: mockGameClient(StreamController()));
      await pump(
        tester,
        SessionState(status: SessionStatus.connected, world: world),
      );
      expect(find.byType(GameView), findsOneWidget);
    });

    testWidgets('shows failures and reconnects', (tester) async {
      await pump(
        tester,
        const SessionState(status: SessionStatus.failure, error: 'nope'),
      );
      expect(find.text('nope'), findsOneWidget);

      await tester.tap(find.text('Reconnect'));
      verify(cubit.connect).called(1);
    });

    testWidgets('has a fallback failure message', (tester) async {
      await pump(tester, const SessionState(status: SessionStatus.failure));
      expect(find.text('Something went wrong.'), findsOneWidget);
    });

    testWidgets('shows disconnects', (tester) async {
      await pump(
        tester,
        const SessionState(status: SessionStatus.disconnected),
      );
      expect(find.text('Disconnected from the server.'), findsOneWidget);
    });
  });
}
