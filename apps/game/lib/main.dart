import 'package:auth_repository/auth_repository.dart';
import 'package:craftaria/app/app.dart';
import 'package:craftaria/bootstrap.dart';
import 'package:craftaria/config/app_config.dart';
import 'package:craftaria/storage/shared_preferences_token_storage.dart';
import 'package:game_client/game_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() => bootstrap(() async {
  final config = AppConfig.fromEnvironment();
  final preferences = await SharedPreferences.getInstance();
  return App(
    config: config,
    authRepository: AuthRepository(
      apiUri: config.apiUri,
      storage: SharedPreferencesTokenStorage(preferences),
    ),
    gameClientFactory: () => GameClient(transport: WebSocketTransport()),
  );
});
