import 'package:craftaria/game/player_status.dart';
import 'package:craftaria/hud/cubit/hud_cubit.dart';
import 'package:craftaria_protocol/craftaria_protocol.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Skills shown in the HUD, with their display names.
const hudSkills = {'woodcutting': 'Woodcutting'};

/// What the player is told for each notice.
const noticeTexts = <NoticeCode, String>{
  NoticeCode.NOTICE_CODE_NOTHING_TO_GATHER: 'There is nothing to gather there.',
  NoticeCode.NOTICE_CODE_OUT_OF_REACH: 'That is out of reach.',
  NoticeCode.NOTICE_CODE_NO_TOOL: 'You need to equip a tool for that.',
  NoticeCode.NOTICE_CODE_TOOL_TOO_WEAK: 'Your tool is not good enough.',
  NoticeCode.NOTICE_CODE_LEVEL_TOO_LOW: 'Your level is too low for that tool.',
  NoticeCode.NOTICE_CODE_INVENTORY_FULL: 'Your inventory is full.',
  NoticeCode.NOTICE_CODE_DEPLETED: 'There is nothing left.',
};

/// Debug-styled HUD drawn over the game: skills, inventory and notices.
/// Plain boxes and text until UI art exists.
class HudOverlay extends StatelessWidget {
  /// Creates a [HudOverlay]. [showDebug] adds the debug panel.
  const HudOverlay({super.key, this.showDebug = kDebugMode});

  /// Whether to show the debug panel.
  final bool showDebug;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<HudCubit>().state;
    return DefaultTextStyle(
      style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 12),
      child: Stack(
        children: [
          Positioned(
            left: 8,
            top: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final MapEntry(key: id, value: name) in hudSkills.entries)
                  if (state.status.skills[id] case final progress?)
                    SkillBar(name: name, progress: progress),
                if (showDebug) const DebugPanel(),
              ],
            ),
          ),
          Positioned(
            right: 8,
            bottom: 8,
            child: InventoryPanel(status: state.status),
          ),
          if (state.notice case final notice?)
            Positioned(
              left: 0,
              right: 0,
              top: 8,
              child: Center(child: NoticeBanner(code: notice)),
            ),
        ],
      ),
    );
  }
}

/// Level and XP progress of one skill.
class SkillBar extends StatelessWidget {
  /// Creates a [SkillBar].
  const SkillBar({required this.name, required this.progress, super.key});

  /// Skill display name.
  final String name;

  /// Progress to show.
  final SkillProgress progress;

  @override
  Widget build(BuildContext context) {
    return _Box(
      child: SizedBox(
        width: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$name ${progress.level}'),
            const SizedBox(height: 4),
            LinearProgressIndicator(value: progress.fraction),
            const SizedBox(height: 2),
            Text(
              '${progress.xp} / ${progress.nextLevelXp} XP',
              style: const TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

/// The equipped tool and the inventory grid. Tapping a tool equips it.
class InventoryPanel extends StatelessWidget {
  /// Creates an [InventoryPanel].
  const InventoryPanel({required this.status, super.key});

  /// Status to show.
  final PlayerStatus status;

  /// Slots per row.
  static const columns = 7;

  @override
  Widget build(BuildContext context) {
    final equipped = status.equipped;
    final equippedName = equipped == null ? 'nothing' : status.nameOf(equipped);
    return _Box(
      child: SizedBox(
        width: columns * InventorySlot.size,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Equipped: $equippedName'),
            const SizedBox(height: 4),
            Wrap(
              children: [
                for (final (index, slot) in status.slots.indexed)
                  InventorySlot(
                    slot: slot,
                    name: slot == null ? null : status.nameOf(slot.itemId),
                    onTap: () => context.read<HudCubit>().equip(index),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// One inventory slot, drawn as a box with the item name and count.
class InventorySlot extends StatelessWidget {
  /// Creates an [InventorySlot].
  const InventorySlot({
    required this.slot,
    required this.name,
    required this.onTap,
    super.key,
  });

  /// Side of a slot in logical pixels.
  static const size = 44.0;

  /// The stack in the slot, or null when empty.
  final ItemSlot? slot;

  /// Display name of the item.
  final String? name;

  /// Called when the slot is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final slot = this.slot;
    return GestureDetector(
      onTap: slot == null ? null : onTap,
      child: Container(
        width: size,
        height: size,
        margin: const EdgeInsets.all(1),
        padding: const EdgeInsets.all(2),
        color: const Color(0xFF3A3A3A),
        child: slot == null
            ? null
            : Text(
                slot.count > 1 ? '$name\n×${slot.count}' : name!,
                style: const TextStyle(fontSize: 8),
              ),
      ),
    );
  }
}

/// A short message to the player.
class NoticeBanner extends StatelessWidget {
  /// Creates a [NoticeBanner].
  const NoticeBanner({required this.code, super.key});

  /// What to tell.
  final NoticeCode code;

  @override
  Widget build(BuildContext context) =>
      _Box(child: Text(noticeTexts[code] ?? code.name));
}

/// Development-only buttons to grant items and XP.
class DebugPanel extends StatelessWidget {
  /// Creates a [DebugPanel].
  const DebugPanel({super.key});

  /// Items the panel can grant.
  static const grantable = ['bronze_axe', 'iron_axe'];

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HudCubit>();
    return _Box(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Debug'),
          for (final item in grantable)
            TextButton(
              onPressed: () => cubit.debugGrantItem(item),
              child: Text('+ $item'),
            ),
          TextButton(
            onPressed: () => cubit.debugGrantXp('woodcutting', 5000),
            child: const Text('+ 5000 woodcutting XP'),
          ),
        ],
      ),
    );
  }
}

class _Box extends StatelessWidget {
  const _Box({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 4),
    padding: const EdgeInsets.all(6),
    color: const Color(0xCC000000),
    child: child,
  );
}
