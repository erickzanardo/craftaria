import 'package:bloc_test/bloc_test.dart';
import 'package:craftaria/game/game.dart';
import 'package:craftaria/hud/hud.dart';
import 'package:craftaria_protocol/craftaria_protocol.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockHudCubit extends MockCubit<HudState> implements HudCubit {}

const _status = PlayerStatus(
  items: {
    'pine_log': ItemInfo(id: 'pine_log', name: 'Pine log', maxStack: 50),
    'bronze_axe': ItemInfo(id: 'bronze_axe', name: 'Bronze axe'),
    'stone_axe': ItemInfo(id: 'stone_axe', name: 'Stone axe'),
  },
  slots: [
    ItemSlot(itemId: 'pine_log', count: 12),
    ItemSlot(itemId: 'bronze_axe', count: 1),
    null,
  ],
  equipped: 'stone_axe',
  skills: {
    'woodcutting': SkillProgress(
      level: 2,
      xp: 100,
      levelXp: 80,
      nextLevelXp: 166,
    ),
  },
);

void main() {
  group('HudOverlay', () {
    late _MockHudCubit cubit;

    setUp(() {
      cubit = _MockHudCubit();
    });

    Future<void> pump(
      WidgetTester tester,
      HudState state, {
      bool showDebug = false,
    }) async {
      when(() => cubit.state).thenReturn(state);
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<HudCubit>.value(
            value: cubit,
            child: HudOverlay(showDebug: showDebug),
          ),
        ),
      );
    }

    testWidgets('shows skills, the equipped tool and the inventory', (
      tester,
    ) async {
      await pump(tester, const HudState(status: _status));

      expect(find.text('Woodcutting 2'), findsOneWidget);
      expect(find.text('100 / 166 XP'), findsOneWidget);
      expect(find.text('Equipped: Stone axe'), findsOneWidget);
      expect(find.text('Pine log\n×12'), findsOneWidget);
      expect(find.text('Bronze axe'), findsOneWidget);
      expect(find.byType(InventorySlot), findsNWidgets(3));
      expect(find.byType(DebugPanel), findsNothing);
      expect(find.byType(NoticeBanner), findsNothing);
    });

    testWidgets('shows nothing equipped and no skills before they arrive', (
      tester,
    ) async {
      await pump(tester, const HudState());
      expect(find.text('Equipped: nothing'), findsOneWidget);
      expect(find.byType(SkillBar), findsNothing);
    });

    testWidgets('tapping a filled slot equips it', (tester) async {
      await pump(tester, const HudState(status: _status));
      await tester.tap(find.text('Bronze axe'));
      await tester.tap(find.byType(InventorySlot).last);
      verify(() => cubit.equip(1)).called(1);
      verifyNever(() => cubit.equip(2));
    });

    testWidgets('shows notices', (tester) async {
      await pump(
        tester,
        const HudState(notice: NoticeCode.NOTICE_CODE_TOOL_TOO_WEAK),
      );
      expect(find.text('Your tool is not good enough.'), findsOneWidget);
    });

    testWidgets('falls back to the code for unknown notices', (tester) async {
      await pump(
        tester,
        const HudState(notice: NoticeCode.NOTICE_CODE_UNSPECIFIED),
      );
      expect(find.text('NOTICE_CODE_UNSPECIFIED'), findsOneWidget);
    });

    testWidgets('has a text for every notice code', (tester) async {
      for (final code in NoticeCode.values) {
        if (code == NoticeCode.NOTICE_CODE_UNSPECIFIED) continue;
        expect(noticeTexts[code], isNotNull, reason: code.name);
      }
    });

    testWidgets('debug panel grants items and XP', (tester) async {
      await pump(tester, const HudState(), showDebug: true);
      await tester.tap(find.text('+ bronze_axe'));
      await tester.tap(find.text('+ iron_axe'));
      await tester.tap(find.text('+ 5000 woodcutting XP'));
      verify(() => cubit.debugGrantItem('bronze_axe')).called(1);
      verify(() => cubit.debugGrantItem('iron_axe')).called(1);
      verify(() => cubit.debugGrantXp('woodcutting', 5000)).called(1);
    });

    testWidgets('shows the debug panel by default in debug builds', (
      tester,
    ) async {
      when(() => cubit.state).thenReturn(const HudState());
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<HudCubit>.value(
            value: cubit,
            child: const HudOverlay(),
          ),
        ),
      );
      expect(find.byType(DebugPanel), findsOneWidget);
    });
  });
}
