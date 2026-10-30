import 'package:craftaria/character/cubit/character_creator_cubit.dart';
import 'package:craftaria/game/client_world.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Lets the player create their character for [world].
class CharacterCreatorPage extends StatelessWidget {
  /// Creates a [CharacterCreatorPage].
  const CharacterCreatorPage({required this.world, super.key});

  /// World the character is created in.
  final ClientWorld world;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => CharacterCreatorCubit(world: world),
    child: const CharacterCreator(),
  );
}

/// Debug-styled panel to pick the skin, shirt and pants colors. The game
/// behind it previews the picks on the player. Plain boxes until UI art
/// exists.
class CharacterCreator extends StatelessWidget {
  /// Creates a [CharacterCreator].
  const CharacterCreator({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CharacterCreatorCubit>();
    final look = cubit.state;
    return DefaultTextStyle(
      style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 12),
      child: Stack(
        children: [
          // Keeps clicks from reaching the world while creating.
          const ModalBarrier(dismissible: false),
          Positioned(
            left: 8,
            top: 8,
            bottom: 8,
            child: Container(
              width: 280,
              padding: const EdgeInsets.all(8),
              color: const Color(0xCC000000),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Create your character'),
                    const SizedBox(height: 8),
                    ColorPicker(
                      key: const Key('skin'),
                      label: 'Skin',
                      palette: cubit.palette,
                      choices: cubit.skinColors,
                      selected: look.skin,
                      onPicked: cubit.pickSkin,
                    ),
                    ColorPicker(
                      key: const Key('shirt'),
                      label: 'Shirt',
                      palette: cubit.palette,
                      choices: cubit.clothingColors,
                      selected: look.shirt,
                      onPicked: cubit.pickShirt,
                    ),
                    ColorPicker(
                      key: const Key('pants'),
                      label: 'Pants',
                      palette: cubit.palette,
                      choices: cubit.clothingColors,
                      selected: look.pants,
                      onPicked: cubit.pickPants,
                    ),
                    FilledButton(
                      onPressed: cubit.create,
                      child: const Text('Play'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A row of palette swatches to pick one color from.
class ColorPicker extends StatelessWidget {
  /// Creates a [ColorPicker].
  const ColorPicker({
    required this.label,
    required this.palette,
    required this.choices,
    required this.selected,
    required this.onPicked,
    super.key,
  });

  /// What the color is for.
  final String label;

  /// The game palette as 0xRRGGBB colors.
  final List<int> palette;

  /// Palette indexes to pick from.
  final List<int> choices;

  /// Palette index currently picked.
  final int selected;

  /// Called with the palette index tapped.
  final ValueChanged<int> onPicked;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 4),
          Wrap(
            children: [
              for (final index in choices)
                Swatch(
                  key: ValueKey(index),
                  color: Color(0xFF000000 | palette[index]),
                  selected: index == selected,
                  onTap: () => onPicked(index),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// One palette color, outlined when picked.
class Swatch extends StatelessWidget {
  /// Creates a [Swatch].
  const Swatch({
    required this.color,
    required this.selected,
    required this.onTap,
    super.key,
  });

  /// Side of a swatch in logical pixels.
  static const size = 24.0;

  /// Color shown.
  final Color color;

  /// Whether the color is picked.
  final bool selected;

  /// Called when the swatch is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: size,
      height: size,
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: selected ? const Color(0xFFFFFFFF) : const Color(0x00000000),
          width: 2,
        ),
      ),
    ),
  );
}
