import 'dart:convert';

import 'package:auth_repository/src/token_storage.dart';
import 'package:http/http.dart' as http;

/// Thrown when the server cannot authenticate the player.
class AuthException implements Exception {
  /// Creates an [AuthException].
  const AuthException(this.message);

  /// What went wrong.
  final String message;

  @override
  String toString() => 'AuthException: $message';
}

/// Obtains and remembers the token used to join the game.
///
/// Players start as guests: the first launch asks the server for a guest
/// token and later launches reuse it. Account linking will build on this.
class AuthRepository {
  /// Creates an [AuthRepository] talking to the API at [apiUri].
  AuthRepository({
    required Uri apiUri,
    required TokenStorage storage,
    http.Client? httpClient,
  }) : _apiUri = apiUri,
       _storage = storage,
       _http = httpClient ?? http.Client();

  final Uri _apiUri;
  final TokenStorage _storage;
  final http.Client _http;

  /// The stored token, or a new guest token when none is stored.
  Future<String> token() async {
    final stored = await _storage.read();
    if (stored != null) return stored;

    final http.Response response;
    try {
      response = await _http.post(_apiUri.resolve('auth/guest'));
    } on Exception catch (error) {
      throw AuthException('could not reach the server: $error');
    }
    if (response.statusCode != 200) {
      throw AuthException('guest sign in failed (${response.statusCode})');
    }

    final body = jsonDecode(response.body);
    if (body is! Map<String, dynamic> || body['token'] is! String) {
      throw const AuthException('unexpected response');
    }
    final token = body['token'] as String;
    await _storage.write(token);
    return token;
  }

  /// Forgets the stored token, e.g. after the server rejected it.
  Future<void> signOut() => _storage.clear();
}
