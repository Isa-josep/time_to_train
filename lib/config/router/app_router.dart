import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_to_train/features/presentation/screens.dart';
import 'package:time_to_train/features/presentation/providers/auth_provider.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (BuildContext context, GoRouterState state) {
      final isAuthenticated = authState.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/';
      final isRegistering = state.matchedLocation == '/register_screen';

      if (!isAuthenticated && !isLoggingIn && !isRegistering) return '/';
      if (isAuthenticated && (isLoggingIn || isRegistering)) return '/home_view';

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home_view',
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        path: '/theme_changer_screen',
        builder: (context, state) => const ThemeChangerScreen(),
      ),
      GoRoute(
        path: '/graphic_screen',
        builder: (context, state) => const GraphScreen(),
      ),
      GoRoute(
        path: '/register_screen',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/imc_screen',
        builder: (context, state) => const ImcScreen(),
      ),
    ],
  );
});
