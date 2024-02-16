import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_to_train/config/theme/app_theme.dart';
import 'package:time_to_train/presentation/screens/homes_creen.dart';

void main() {
  const ProviderScope(
    child: MainApp(),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme(selectedColor: 1).getTheme(),
      home: const HomeView(),
    );
  }
}
