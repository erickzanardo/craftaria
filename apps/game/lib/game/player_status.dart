import 'package:craftaria_protocol/craftaria_protocol.dart';
import 'package:equatable/equatable.dart';

/// Display data of an item type, sent by the server.
class ItemInfo extends Equatable {
  /// Creates an [ItemInfo].
  const ItemInfo({required this.id, required this.name, this.maxStack = 1});

  /// Stable item id, e.g. `pine_log`.
  final String id;

  /// Display name.
  final String name;

  /// Most items a slot holds.
  final int maxStack;

  @override
  List<Object> get props => [id, name, maxStack];
}

/// A stack of items in an inventory slot.
class ItemSlot extends Equatable {
  /// Creates an [ItemSlot].
  const ItemSlot({required this.itemId, required this.count});

  /// Item id.
  final String itemId;

  /// How many items are in the slot.
  final int count;

  @override
  List<Object> get props => [itemId, count];
}

/// Progress in one skill.
class SkillProgress extends Equatable {
  /// Creates a [SkillProgress].
  const SkillProgress({
    required this.level,
    required this.xp,
    required this.levelXp,
    required this.nextLevelXp,
  });

  /// Converts from the protobuf message.
  factory SkillProgress.fromProto(SkillUpdate update) => SkillProgress(
    level: update.level,
    xp: update.xp.toInt(),
    levelXp: update.levelXp.toInt(),
    nextLevelXp: update.nextLevelXp.toInt(),
  );

  /// Current level.
  final int level;

  /// Total XP.
  final int xp;

  /// Total XP at which the current level started.
  final int levelXp;

  /// Total XP for the next level; equal to [levelXp] at the cap.
  final int nextLevelXp;

  /// Progress through the current level, from 0 to 1.
  double get fraction => nextLevelXp == levelXp
      ? 1
      : ((xp - levelXp) / (nextLevelXp - levelXp)).clamp(0, 1);

  @override
  List<Object> get props => [level, xp, levelXp, nextLevelXp];
}

/// The local player's items, skills and action, as told by the server.
class PlayerStatus extends Equatable {
  /// Creates a [PlayerStatus].
  const PlayerStatus({
    this.items = const {},
    this.slots = const [],
    this.equipped,
    this.skills = const {},
    this.gathering = false,
  });

  /// Display data for every item, by id.
  final Map<String, ItemInfo> items;

  /// Inventory slots; null for empty ones.
  final List<ItemSlot?> slots;

  /// Item id of the equipped tool.
  final String? equipped;

  /// Progress per skill id.
  final Map<String, SkillProgress> skills;

  /// Whether the player is gathering.
  final bool gathering;

  /// Display name of [itemId], falling back to the id itself.
  String nameOf(String itemId) => items[itemId]?.name ?? itemId;

  /// A copy with the given fields replaced.
  PlayerStatus copyWith({
    Map<String, ItemInfo>? items,
    List<ItemSlot?>? slots,
    String? Function()? equipped,
    Map<String, SkillProgress>? skills,
    bool? gathering,
  }) => PlayerStatus(
    items: items ?? this.items,
    slots: slots ?? this.slots,
    equipped: equipped != null ? equipped() : this.equipped,
    skills: skills ?? this.skills,
    gathering: gathering ?? this.gathering,
  );

  @override
  List<Object?> get props => [items, slots, equipped, skills, gathering];
}
