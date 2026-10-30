import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:craftaria/character/character.dart';
import 'package:craftaria/game/game.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

void main() {
  group('CharacterCreatorCubit', () {
    late MockGameClient client;
    late ClientWorld world;

    setUp(() {
      client = mockGameClient(StreamController());
      world = ClientWorld(client: client)..handle(welcome(look: null));
    });

    test('starts from the first allowed colors and previews them', () {
      final cubit = CharacterCreatorCubit(world: world);
      expect(cubit.state, equals(testLook));
      expect(cubit.palette, equals(testPalette));
      expect(cubit.skinColors, equals(testSkinColors));
      expect(cubit.clothingColors, isNot(contains(12)));
      expect(cubit.clothingColors, hasLength(38));
      expect(world.previewLook, equals(testLook));
    });

    blocTest<CharacterCreatorCubit, CharacterLook>(
      'picks colors, previewing each pick',
      build: () => CharacterCreatorCubit(world: world),
      act: (cubit) => cubit
        ..pickSkin(14)
        ..pickShirt(5)
        ..pickPants(6),
      expect: () => const [
        CharacterLook(skin: 14, shirt: 0, pants: 1),
        CharacterLook(skin: 14, shirt: 5, pants: 1),
        CharacterLook(skin: 14, shirt: 5, pants: 6),
      ],
      verify: (_) => expect(
        world.previewLook,
        equals(const CharacterLook(skin: 14, shirt: 5, pants: 6)),
      ),
    );

    blocTest<CharacterCreatorCubit, CharacterLook>(
      'creates the character with the picked colors',
      build: () => CharacterCreatorCubit(world: world),
      act: (cubit) => cubit
        ..pickSkin(14)
        ..create(),
      verify: (_) {
        const look = CharacterLook(skin: 14, shirt: 0, pants: 1);
        verify(() => client.sendAppearance(look.toProto())).called(1);
        expect(world.status.look, equals(look));
      },
    );
  });
}
