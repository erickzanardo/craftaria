import 'package:bloc/bloc.dart';
import 'package:craftaria/game/character/character_look.dart';
import 'package:craftaria/game/client_world.dart';

/// Picks the colors of a new character, previewing them on the local player,
/// and creates it.
class CharacterCreatorCubit extends Cubit<CharacterLook> {
  /// Creates a [CharacterCreatorCubit] for [world], starting from the first
  /// allowed colors.
  CharacterCreatorCubit({required ClientWorld world})
    : _world = world,
      palette = world.status.palette,
      skinColors = world.status.skinColors,
      clothingColors = world.status.clothingColors,
      super(
        CharacterLook(
          skin: world.status.skinColors.first,
          shirt: world.status.clothingColors.first,
          pants: world.status.clothingColors[1],
        ),
      ) {
    _world.previewLook = state;
  }

  final ClientWorld _world;

  /// The game palette as 0xRRGGBB colors.
  final List<int> palette;

  /// Palette indexes to pick the skin from.
  final List<int> skinColors;

  /// Palette indexes to pick the shirt and the pants from.
  final List<int> clothingColors;

  /// Picks the skin color.
  void pickSkin(int index) => emit(state.copyWith(skin: index));

  /// Picks the shirt color.
  void pickShirt(int index) => emit(state.copyWith(shirt: index));

  /// Picks the pants color.
  void pickPants(int index) => emit(state.copyWith(pants: index));

  /// Creates the character with the picked colors.
  void create() => _world.createCharacter(state);

  @override
  void onChange(Change<CharacterLook> change) {
    super.onChange(change);
    _world.previewLook = change.nextState;
  }
}
