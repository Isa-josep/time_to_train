import 'package:go_router/go_router.dart';
import 'package:time_to_train/presentation/screens/homes_creen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeView(),
    ),

    

  ],
);
