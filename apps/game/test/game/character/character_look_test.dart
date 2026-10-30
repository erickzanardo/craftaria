import 'package:craftaria/game/game.dart';
import 'package:craftaria_protocol/craftaria_protocol.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CharacterLook', () {
    test('converts to and from protobuf', () {
      const look = CharacterLook(skin: 12, shirt: 0, pants: 1);
      final proto = Appearance(skin: 12, shirt: 0, pants: 1);
      expect(look.toProto(), equals(proto));
      expect(CharacterLook.fromProto(proto), equals(look));
    });

    test('copyWith replaces only the given parts', () {
      const look = CharacterLook(skin: 12, shirt: 0, pants: 1);
      expect(look.copyWith(), equals(look));
      expect(
        look.copyWith(skin: 13, shirt: 2, pants: 3),
        equals(const CharacterLook(skin: 13, shirt: 2, pants: 3)),
      );
    });
  });
}
