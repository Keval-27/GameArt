import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { light, dark, amoled }

class ThemeProvider extends ChangeNotifier {
  AppThemeMode _mode = AppThemeMode.dark;

  AppThemeMode get mode => _mode;

  ThemeData get theme {
    switch (_mode) {
      case AppThemeMode.light:
        return ThemeData(
          brightness: Brightness.light,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF335CFF)),
          useMaterial3: true,
        );
      case AppThemeMode.amoled:
        return ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF000000),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF6EA8FF),
            secondary: Color(0xFF6EA8FF),
            surface: Color(0xFF000000),
          ),
          useMaterial3: true,
        );
      case AppThemeMode.dark:
      default:
        return ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6EA8FF), brightness: Brightness.dark),
          useMaterial3: true,
        );
    }
  }

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    final v = p.getString('app_theme') ?? 'dark';
    _mode = AppThemeMode.values.firstWhere(
          (e) => e.name == v,
      orElse: () => AppThemeMode.dark,
    );
    notifyListeners();
  }

  Future<void> setMode(AppThemeMode m) async {
    _mode = m;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setString('app_theme', m.name);
  }
}
