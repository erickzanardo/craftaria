import 'package:auth_repository/auth_repository.dart';
import 'package:craftaria/config/app_config.dart';
import 'package:craftaria/session/session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Root widget: provides app-wide dependencies.
class App extends StatelessWidget {
  /// Creates an [App].
  const App({
    required this.config,
    required this.authRepository,
    required this.gameClientFactory,
    super.key,
  });

  /// Build-time configuration.
  final AppConfig config;

  /// Provides the session token.
  final AuthRepository authRepository;

  /// Creates a fresh connection for every session.
  final GameClientFactory gameClientFactory;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: config),
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: gameClientFactory),
      ],
      child: MaterialApp(
        title: 'Craftaria',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4C9A3B),
            brightness: Brightness.dark,
          ),
        ),
        home: const SessionPage(),
      ),
    );
  }
}
