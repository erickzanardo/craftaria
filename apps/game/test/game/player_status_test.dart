import 'package:craftaria/game/player_status.dart';
import 'package:craftaria_protocol/craftaria_protocol.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SkillProgress', () {
    test('converts from protobuf and computes the level fraction', () {
      final progress = SkillProgress.fromProto(
        SkillUpdate(
          skillId: 'woodcutting',
          level: 2,
          xp: Int64(123),
          levelXp: Int64(80),
          nextLevelXp: Int64(166),
        ),
      );
      expect(
        progress,
        equals(
          const SkillProgress(level: 2, xp: 123, levelXp: 80, nextLevelXp: 166),
        ),
      );
      expect(progress.fraction, closeTo(0.5, 0.01));
    });

    test('is full at the level cap', () {
      const capped = SkillProgress(
        level: 100,
        xp: 2000000,
        levelXp: 1064185,
        nextLevelXp: 1064185,
      );
      expect(capped.fraction, equals(1));
    });
  });

  group('PlayerStatus', () {
    test('names items, falling back to the id', () {
      const status = PlayerStatus(
        items: {'pine_log': ItemInfo(id: 'pine_log', name: 'Pine log')},
      );
      expect(status.nameOf('pine_log'), equals('Pine log'));
      expect(status.nameOf('mystery'), equals('mystery'));
    });

    test('copyWith replaces only the given fields', () {
      const status = PlayerStatus(equipped: 'stone_axe');
      expect(status.copyWith(), equals(status));
      expect(status.copyWith(equipped: () => null).equipped, isNull);
      final changed = status.copyWith(
        slots: const [
          ItemSlot(itemId: 'pine_log', count: 2),
          null,
        ],
        skills: const {
          'woodcutting': SkillProgress(
            level: 1,
            xp: 0,
            levelXp: 0,
            nextLevelXp: 80,
          ),
        },
        gathering: true,
        items: const {'a': ItemInfo(id: 'a', name: 'A', maxStack: 5)},
      );
      expect(changed.equipped, equals('stone_axe'));
      expect(changed.gathering, isTrue);
      expect(changed.slots, hasLength(2));
      expect(changed.skills.keys, equals(['woodcutting']));
      expect(changed.items['a']!.maxStack, equals(5));
    });
  });
}
