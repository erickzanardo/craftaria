/// Persists the session token. Platforms provide implementations (e.g.
/// shared preferences on web and mobile).
abstract interface class TokenStorage {
  /// The stored token, if any.
  Future<String?> read();

  /// Stores [token].
  Future<void> write(String token);

  /// Removes the stored token.
  Future<void> clear();
}

/// [TokenStorage] that forgets everything when the app closes.
class InMemoryTokenStorage implements TokenStorage {
  String? _token;

  @override
  Future<String?> read() async => _token;

  @override
  Future<void> write(String token) async => _token = token;

  @override
  Future<void> clear() async => _token = null;
}
