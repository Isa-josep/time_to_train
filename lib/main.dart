import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_to_train/config/router/app_router.dart';
import 'package:time_to_train/config/theme/app_theme.dart';
import 'package:time_to_train/features/presentation/providers/theme_provider.dart';
void main() {
  runApp(
    const ProviderScope(
      child: MainApp()
    )
  );
}


class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppTheme appTheme = ref.watch( themeNotifierProvider );
    return  MaterialApp.router(
      title: "Widgets",
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: appTheme.getTheme(),
    );
  }
}
