part of 'hud_cubit.dart';

/// State of [HudCubit].
class HudState extends Equatable {
  /// Creates a [HudState].
  const HudState({this.status = const PlayerStatus(), this.notice});

  /// The local player's items, skills and action.
  final PlayerStatus status;

  /// The latest notice to show, if any.
  final NoticeCode? notice;

  /// A copy with the given fields replaced.
  HudState copyWith({PlayerStatus? status, NoticeCode? Function()? notice}) =>
      HudState(
        status: status ?? this.status,
        notice: notice != null ? notice() : this.notice,
      );

  @override
  List<Object?> get props => [status, notice];
}
