import 'package:craftaria/character/character.dart';
import 'package:craftaria/game/client_world.dart';
import 'package:craftaria/game/craftaria_game.dart';
import 'package:craftaria/hud/hud.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Hosts a [CraftariaGame] for [world] with the HUD over it, or the
/// character creator until the player has a character.
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
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => HudCubit(world: widget.world),
    child: Stack(
      children: [
        GameWidget(game: _game),
        BlocSelector<HudCubit, HudState, bool>(
          selector: (state) => state.status.look == null,
          builder: (context, creating) => creating
              ? CharacterCreatorPage(world: widget.world)
              : const HudOverlay(),
        ),
      ],
    ),
  );
}
