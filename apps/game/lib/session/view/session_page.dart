import 'dart:async';

import 'package:craftaria/config/app_config.dart';
import 'package:craftaria/game/view/game_view.dart';
import 'package:craftaria/session/cubit/session_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Connects to the game and shows it once welcomed.
class SessionPage extends StatelessWidget {
  /// Creates a [SessionPage].
  const SessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = SessionCubit(
          authRepository: context.read(),
          gameClientFactory: context.read(),
          config: context.read<AppConfig>(),
        );
        unawaited(cubit.connect());
        return cubit;
      },
      child: const SessionView(),
    );
  }
}

/// Shows the state of the session.
class SessionView extends StatelessWidget {
  /// Creates a [SessionView].
  const SessionView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SessionCubit>().state;
    final world = state.world;
    return Scaffold(
      body: switch (state.status) {
        SessionStatus.connected when world != null => GameView(
          key: ObjectKey(world),
          world: world,
        ),
        SessionStatus.failure => _Message(
          text: state.error ?? 'Something went wrong.',
        ),
        SessionStatus.disconnected => const _Message(
          text: 'Disconnected from the server.',
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => context.read<SessionCubit>().connect(),
            child: const Text('Reconnect'),
          ),
        ],
      ),
    );
  }
}
