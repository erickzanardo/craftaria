import 'dart:async';

import 'package:craftaria/character/character.dart';
import 'package:craftaria/game/game.dart';
import 'package:craftaria/hud/hud.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

void main() {
  group('GameView', () {
    testWidgets('hosts the game with the HUD', (tester) async {
      final world = ClientWorld(client: mockGameClient(StreamController()))
        ..handle(welcome());
      await tester.pumpWidget(MaterialApp(home: GameView(world: world)));
      expect(find.byType(GameWidget<CraftariaGame>), findsOneWidget);
      expect(find.byType(HudOverlay), findsOneWidget);
      expect(find.byType(CharacterCreator), findsNothing);
    });

    testWidgets('creates the character first, then shows the HUD', (
      tester,
    ) async {
      final client = mockGameClient(StreamController());
      final world = ClientWorld(client: client)..handle(welcome(look: null));
      await tester.pumpWidget(MaterialApp(home: GameView(world: world)));
      expect(find.byType(CharacterCreator), findsOneWidget);
      expect(find.byType(HudOverlay), findsNothing);

      await tester.tap(find.text('Play'));
      await tester.pump();
      verify(() => client.sendAppearance(testLook.toProto())).called(1);
      expect(find.byType(HudOverlay), findsOneWidget);
    });
  });
}
