import 'dart:async';

import 'package:auth_repository/auth_repository.dart';
import 'package:craftaria/app/app.dart';
import 'package:craftaria/config/app_config.dart';
import 'package:craftaria/session/session.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

void main() {
  group('App', () {
    testWidgets('starts a session', (tester) async {
      final authRepository = MockAuthRepository();
      when(
        authRepository.token,
      ).thenThrow(const AuthException('server unavailable'));

      await tester.pumpWidget(
        App(
          config: AppConfig(apiUri: Uri.parse('http://localhost:8787/')),
          authRepository: authRepository,
          gameClientFactory: () => mockGameClient(StreamController()),
        ),
      );

      expect(find.byType(SessionPage), findsOneWidget);
    });
  });
}
