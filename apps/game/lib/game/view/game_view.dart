import 'package:craftaria/game/client_world.dart';
import 'package:craftaria/game/craftaria_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';

/// Hosts a [CraftariaGame] for [world].
class GameView extends StatefulWidget {
  /// Creates a [GameView].
  const GameView({required this.world, super.key});

  /// World to render.
  final ClientWorld world;

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  late final CraftariaGame _game = CraftariaGame(clientWorld: widget.world);

  @override
  Widget build(BuildContext context) => GameWidget(game: _game);
}
