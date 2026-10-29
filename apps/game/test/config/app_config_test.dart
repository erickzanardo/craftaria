import 'package:craftaria/config/app_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppConfig', () {
    test('defaults to a local wrangler dev server', () {
      final config = AppConfig.fromEnvironment();
      expect(config.apiUri, equals(Uri.parse('http://localhost:8787/')));
      expect(config.zone, equals('overworld'));
    });

    test('derives the zone socket url', () {
      expect(
        AppConfig(apiUri: Uri.parse('http://localhost:8787/')).zoneSocketUri,
        equals(Uri.parse('ws://localhost:8787/zones/overworld/ws')),
      );
      expect(
        AppConfig(
          apiUri: Uri.parse('https://api.example/v1/'),
          zone: 'caves',
        ).zoneSocketUri,
        equals(Uri.parse('wss://api.example/v1/zones/caves/ws')),
      );
    });
  });
}
