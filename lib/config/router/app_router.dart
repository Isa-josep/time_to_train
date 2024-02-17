import 'package:go_router/go_router.dart';
import 'package:time_to_train/presentation/screens.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeView(),
    ),

    GoRoute(
      path: '/theme_changer_screen',
      builder: (context, state) => const ThemeChangerScreen(),
    ),
  ],
);
