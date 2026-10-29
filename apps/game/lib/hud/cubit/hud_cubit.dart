import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:craftaria/game/client_world.dart';
import 'package:craftaria/game/player_status.dart';
import 'package:craftaria_protocol/craftaria_protocol.dart';
import 'package:equatable/equatable.dart';

part 'hud_state.dart';

/// How long a notice stays on screen by default.
const defaultNoticeDuration = Duration(seconds: 3);

/// Feeds the HUD from a [ClientWorld] and sends the player's HUD actions.
class HudCubit extends Cubit<HudState> {
  /// Creates a [HudCubit] for [world], showing notices for
  /// [noticeDuration].
  HudCubit({
    required ClientWorld world,
    this.noticeDuration = defaultNoticeDuration,
  }) : _world = world,
       super(HudState(status: world.status)) {
    _subscriptions = [
      world.statusChanges.listen(
        (status) => emit(state.copyWith(status: status)),
      ),
      world.notices.listen(_showNotice),
    ];
  }

  /// How long a notice stays on screen.
  final Duration noticeDuration;

  final ClientWorld _world;
  late final List<StreamSubscription<Object>> _subscriptions;
  Timer? _noticeTimer;

  /// Equips the tool in inventory [slot].
  void equip(int slot) => _world.equip(slot);

  /// Development only: asks the server for items.
  void debugGrantItem(String itemId, {int count = 1}) =>
      _world.debugGrantItem(itemId, count);

  /// Development only: asks the server for XP.
  void debugGrantXp(String skillId, int amount) =>
      _world.debugGrantXp(skillId, amount);

  void _showNotice(NoticeCode code) {
    _noticeTimer?.cancel();
    emit(state.copyWith(notice: () => code));
    _noticeTimer = Timer(
      noticeDuration,
      () => emit(state.copyWith(notice: () => null)),
    );
  }

  @override
  Future<void> close() async {
    _noticeTimer?.cancel();
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    await super.close();
  }
}
