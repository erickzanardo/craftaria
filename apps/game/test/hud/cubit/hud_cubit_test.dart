import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:craftaria/game/game.dart';
import 'package:craftaria/hud/hud.dart';
import 'package:craftaria_protocol/craftaria_protocol.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockClientWorld extends Mock implements ClientWorld {}

void main() {
  group('HudCubit', () {
    late _MockClientWorld world;
    late StreamController<PlayerStatus> statuses;
    late StreamController<NoticeCode> notices;

    setUp(() {
      world = _MockClientWorld();
      statuses = StreamController.broadcast();
      notices = StreamController.broadcast();
      when(
        () => world.status,
      ).thenReturn(const PlayerStatus(equipped: 'stone_axe'));
      when(() => world.statusChanges).thenAnswer((_) => statuses.stream);
      when(() => world.notices).thenAnswer((_) => notices.stream);
    });

    test('starts from the current status', () {
      expect(
        HudCubit(world: world).state,
        equals(const HudState(status: PlayerStatus(equipped: 'stone_axe'))),
      );
    });

    blocTest<HudCubit, HudState>(
      'follows status changes',
      build: () => HudCubit(world: world),
      act: (_) => statuses.add(const PlayerStatus(gathering: true)),
      expect: () => [const HudState(status: PlayerStatus(gathering: true))],
    );

    const short = Duration(milliseconds: 10);

    test('shows the latest notice for a while', () async {
      final cubit = HudCubit(world: world, noticeDuration: short);
      notices
        ..add(NoticeCode.NOTICE_CODE_DEPLETED)
        ..add(NoticeCode.NOTICE_CODE_INVENTORY_FULL);
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state.notice, NoticeCode.NOTICE_CODE_INVENTORY_FULL);

      await Future<void>.delayed(short * 3);
      expect(cubit.state.notice, isNull);
      await cubit.close();
    });

    test('cancels a pending notice timer on close', () async {
      final cubit = HudCubit(world: world, noticeDuration: short);
      notices.add(NoticeCode.NOTICE_CODE_DEPLETED);
      await Future<void>.delayed(Duration.zero);
      await cubit.close();
      // Emitting after close would throw.
      await Future<void>.delayed(short * 3);
      expect(cubit.isClosed, isTrue);
    });

    test('uses the default notice duration', () {
      expect(
        HudCubit(world: world).noticeDuration,
        equals(defaultNoticeDuration),
      );
    });

    test('passes player actions to the world', () {
      HudCubit(world: world)
        ..equip(2)
        ..debugGrantItem('iron_axe')
        ..debugGrantXp('woodcutting', 5);
      verify(() => world.equip(2)).called(1);
      verify(() => world.debugGrantItem('iron_axe', 1)).called(1);
      verify(() => world.debugGrantXp('woodcutting', 5)).called(1);
    });
  });
}
