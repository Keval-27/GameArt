import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF335CFF)),
    useMaterial3: true,
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6EA8FF), brightness: Brightness.dark),
    useMaterial3: true,
  );

  static ThemeData amoled = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF000000),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF6EA8FF),
      secondary: Color(0xFF6EA8FF),
      surface: Color(0xFF000000),
    ),
    useMaterial3: true,
  );
}

