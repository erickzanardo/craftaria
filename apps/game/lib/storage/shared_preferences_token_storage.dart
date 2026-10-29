import 'package:auth_repository/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// [TokenStorage] backed by shared preferences (local storage on web).
class SharedPreferencesTokenStorage implements TokenStorage {
  /// Creates a [SharedPreferencesTokenStorage].
  const SharedPreferencesTokenStorage(this._preferences);

  /// Preferences key holding the token.
  static const key = 'craftaria.session_token';

  final SharedPreferences _preferences;

  @override
  Future<String?> read() async => _preferences.getString(key);

  @override
  Future<void> write(String token) => _preferences.setString(key, token);

  @override
  Future<void> clear() => _preferences.remove(key);
}
