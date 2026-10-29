import 'package:craftaria/storage/shared_preferences_token_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('SharedPreferencesTokenStorage', () {
    test('reads, writes and clears the token', () async {
      SharedPreferences.setMockInitialValues({});
      final storage = SharedPreferencesTokenStorage(
        await SharedPreferences.getInstance(),
      );

      expect(await storage.read(), isNull);
      await storage.write('token');
      expect(await storage.read(), equals('token'));
      await storage.clear();
      expect(await storage.read(), isNull);
    });
  });
}
