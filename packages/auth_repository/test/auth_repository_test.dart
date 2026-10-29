import 'dart:convert';

import 'package:auth_repository/auth_repository.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockHttpClient extends Mock implements http.Client {}

void main() {
  final apiUri = Uri.parse('https://api.example/');

  setUpAll(() => registerFallbackValue(Uri()));

  group('AuthRepository', () {
    late _MockHttpClient httpClient;
    late InMemoryTokenStorage storage;
    late AuthRepository repository;

    setUp(() {
      httpClient = _MockHttpClient();
      storage = InMemoryTokenStorage();
      repository = AuthRepository(
        apiUri: apiUri,
        storage: storage,
        httpClient: httpClient,
      );
    });

    void respond(int status, Object body) {
      when(() => httpClient.post(any())).thenAnswer(
        (_) async =>
            http.Response(body is String ? body : jsonEncode(body), status),
      );
    }

    test('can be created with a default http client', () {
      expect(
        () => AuthRepository(apiUri: apiUri, storage: storage),
        returnsNormally,
      );
    });

    test('returns the stored token without calling the server', () async {
      await storage.write('stored');
      expect(await repository.token(), equals('stored'));
      verifyNever(() => httpClient.post(any()));
    });

    test('requests and stores a guest token', () async {
      respond(200, {'token': 'fresh', 'playerId': 'p'});

      expect(await repository.token(), equals('fresh'));
      expect(await storage.read(), equals('fresh'));
      verify(
        () => httpClient.post(Uri.parse('https://api.example/auth/guest')),
      ).called(1);
    });

    test('throws on non-200 responses', () {
      respond(500, {'error': 'server misconfigured'});
      expect(repository.token, throwsA(isA<AuthException>()));
    });

    test('throws on unexpected bodies', () async {
      for (final body in <Object>[
        [1, 2],
        {'token': 1},
      ]) {
        respond(200, body);
        await expectLater(repository.token, throwsA(isA<AuthException>()));
      }
    });

    test('throws when the server is unreachable', () {
      when(
        () => httpClient.post(any()),
      ).thenThrow(http.ClientException('offline'));
      expect(repository.token, throwsA(isA<AuthException>()));
    });

    test('signOut clears the stored token', () async {
      await storage.write('stored');
      await repository.signOut();
      expect(await storage.read(), isNull);
    });
  });

  group('AuthException', () {
    test('toString includes the message', () {
      expect(const AuthException('nope').toString(), contains('nope'));
    });
  });
}
