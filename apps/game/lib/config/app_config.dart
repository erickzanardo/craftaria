/// Build-time configuration, passed with `--dart-define`.
///
/// Only public values belong here: anything compiled into the client ships
/// to every player.
class AppConfig {
  /// Creates an [AppConfig].
  const AppConfig({required this.apiUri, this.zone = 'overworld'});

  /// Reads `CRAFTARIA_API_URL`, defaulting to a local `wrangler dev`.
  factory AppConfig.fromEnvironment() => AppConfig(
    apiUri: Uri.parse(
      const String.fromEnvironment(
        'CRAFTARIA_API_URL',
        defaultValue: 'http://localhost:8787/',
      ),
    ),
  );

  /// Base URL of the HTTP API. Must end with a slash.
  final Uri apiUri;

  /// Zone to join.
  final String zone;

  /// WebSocket URL of [zone].
  Uri get zoneSocketUri => apiUri
      .resolve('zones/$zone/ws')
      .replace(scheme: apiUri.scheme == 'https' ? 'wss' : 'ws');
}
