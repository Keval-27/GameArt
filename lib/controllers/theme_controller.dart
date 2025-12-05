import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

enum AppThemeMode { light, dark, amoled }

class ThemeController extends GetxController {
  final Rx<AppThemeMode> currentTheme = AppThemeMode.dark.obs;

  @override
  void onInit() {
    super.onInit();
    loadTheme();
  }

  Future<void> loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeName = prefs.getString('app_theme') ?? 'dark';

      currentTheme.value = AppThemeMode.values.firstWhere(
            (t) => t.name == themeName,
        orElse: () => AppThemeMode.dark,
      );
    } catch (e) {
      currentTheme.value = AppThemeMode.dark;
    }
  }

  Future<void> setTheme(AppThemeMode theme) async {
    try {
      currentTheme.value = theme;

      // Save to preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('app_theme', theme.name);

      Get.snackbar(
        'Success',
        'Theme changed to ${theme.name}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to change theme');
    }
  }
}
