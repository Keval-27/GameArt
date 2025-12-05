import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'theme/app_theme.dart';
import 'controllers/theme_controller.dart';
import 'routes/app_routes.dart';
import 'screens/splash_screen.dart';

class GameArtApp extends StatelessWidget {
  const GameArtApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCtrl = Get.find<ThemeController>();

    return Obx(() {
      // Get current theme based on controller
      final currentTheme = themeCtrl.currentTheme.value;

      return GetMaterialApp(
        title: 'GameArt: HD Wallpaper Hub',
        theme: AppTheme.light,
        darkTheme: _getDarkTheme(currentTheme),
        // ✅ Use dark theme mode for both dark and amoled
        themeMode: currentTheme == AppThemeMode.light
            ? ThemeMode.light
            : ThemeMode.dark,
        initialRoute: AppRoutes.splash,
        getPages: AppRoutes.routes,
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.cupertino,
        locale: const Locale('en', 'US'),
      );
    });
  }

  ThemeData _getDarkTheme(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return AppTheme.light;
      case AppThemeMode.dark:
        return AppTheme.dark;
      case AppThemeMode.amoled:
        return AppTheme.amoled;
    }
  }
}
