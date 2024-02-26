import 'package:go_router/go_router.dart';
import 'package:time_to_train/features/presentation/screens.dart';

final appRouter = GoRouter(
  initialLocation: '/',
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
    )
  ],
);
