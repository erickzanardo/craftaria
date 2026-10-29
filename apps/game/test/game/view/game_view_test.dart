import 'dart:async';

import 'package:craftaria/game/game.dart';
import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('GameView', () {
    testWidgets('hosts the game', (tester) async {
      final world = ClientWorld(client: mockGameClient(StreamController()));
      await tester.pumpWidget(GameView(world: world));
      expect(find.byType(GameWidget<CraftariaGame>), findsOneWidget);
    });
  });
}
