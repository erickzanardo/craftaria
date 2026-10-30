import 'dart:async';

import 'package:craftaria/character/character.dart';
import 'package:craftaria/game/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('CharacterCreator', () {
    late ClientWorld world;

    setUp(() {
      world = ClientWorld(client: mockGameClient(StreamController()))
        ..handle(welcome(look: null));
    });

    Future<void> pump(WidgetTester tester) => tester.pumpWidget(
      MaterialApp(home: CharacterCreatorPage(world: world)),
    );

    Swatch swatch(WidgetTester tester, String part, int index) =>
        tester.widget<Swatch>(
          find.descendant(
            of: find.byKey(Key(part)),
            matching: find.byKey(ValueKey(index)),
          ),
        );

    testWidgets('offers skin colors for skin and the rest for clothes', (
      tester,
    ) async {
      await pump(tester);
      Finder swatches(String part) => find.descendant(
        of: find.byKey(Key(part)),
        matching: find.byType(Swatch),
      );
      expect(swatches('skin'), findsNWidgets(testSkinColors.length));
      expect(swatches('shirt'), findsNWidgets(38));
      expect(swatches('pants'), findsNWidgets(38));
      expect(
        swatch(tester, 'skin', 13).color,
        equals(Color(0xFF000000 | testPalette[13])),
      );
    });

    testWidgets('marks and previews each pick', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await pump(tester);
      expect(swatch(tester, 'skin', 12).selected, isTrue);

      for (final (part, index) in [('skin', 14), ('shirt', 5), ('pants', 6)]) {
        await tester.tap(
          find.descendant(
            of: find.byKey(Key(part)),
            matching: find.byKey(ValueKey(index)),
          ),
        );
        await tester.pump();
        expect(swatch(tester, part, index).selected, isTrue);
      }
      expect(swatch(tester, 'skin', 12).selected, isFalse);
      expect(
        world.previewLook,
        equals(const CharacterLook(skin: 14, shirt: 5, pants: 6)),
      );

      await tester.tap(find.text('Play'));
      expect(
        world.status.look,
        equals(const CharacterLook(skin: 14, shirt: 5, pants: 6)),
      );
    });
  });
}
