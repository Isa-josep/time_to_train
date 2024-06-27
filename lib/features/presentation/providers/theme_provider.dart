import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_to_train/config/theme/app_theme.dart';

final colorListProvider = Provider((ref) => colorList);

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, AppTheme>(
  (ref) => ThemeNotifier(),
);

class ThemeNotifier extends StateNotifier<AppTheme> {
  ThemeNotifier() : super(AppTheme()) {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final selectedColor = prefs.getInt('selectedColor') ?? 0;
      final isDarkmode = prefs.getBool('isDarkmode') ?? false;

      state = state.copyWith(
        selectedColor: selectedColor,
        isDarkmode: isDarkmode,
      );
    } catch (e) {
      // Manejar error aquí si es necesario
      print('Error loading preferences: $e');
    }
  }

  Future<void> toggleDarkmode() async {
    try {
      state = state.copyWith(isDarkmode: !state.isDarkmode);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkmode', state.isDarkmode);
    } catch (e) {
      // Manejar error aquí si es necesario
      print('Error toggling dark mode: $e');
    }
  }

  Future<void> changeColorIndex(int colorIndex) async {
    try {
      state = state.copyWith(selectedColor: colorIndex);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('selectedColor', state.selectedColor);
    } catch (e) {
      // Manejar error aquí si es necesario
      print('Error changing color index: $e');
    }
  }
}
