import 'package:craftaria_protocol/craftaria_protocol.dart';
import 'package:equatable/equatable.dart';

/// How a character looks: one palette index per tinted part.
class CharacterLook extends Equatable {
  /// Creates a [CharacterLook].
  const CharacterLook({
    required this.skin,
    required this.shirt,
    required this.pants,
  });

  /// Converts from the protobuf message.
  factory CharacterLook.fromProto(Appearance appearance) => CharacterLook(
    skin: appearance.skin,
    shirt: appearance.shirt,
    pants: appearance.pants,
  );

  /// Palette index of the skin.
  final int skin;

  /// Palette index of the shirt.
  final int shirt;

  /// Palette index of the pants.
  final int pants;

  /// Converts to the protobuf message.
  Appearance toProto() => Appearance(skin: skin, shirt: shirt, pants: pants);

  /// A copy with the given parts replaced.
  CharacterLook copyWith({int? skin, int? shirt, int? pants}) => CharacterLook(
    skin: skin ?? this.skin,
    shirt: shirt ?? this.shirt,
    pants: pants ?? this.pants,
  );

  @override
  List<Object> get props => [skin, shirt, pants];
}
