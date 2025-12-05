import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'controllers/theme_controller.dart';
import 'controllers/favorites_controller.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized successfully');
  } catch (e) {
    print('❌ Firebase initialization error: $e');
  }

  // Initialize Theme Controller (BEFORE GetMaterialApp)
  final themeController = ThemeController();
  await themeController.loadTheme();
  Get.put<ThemeController>(themeController, permanent: true);

  // Initialize Favorites Controller
  Get.put<FavoritesController>(FavoritesController(), permanent: true);

  runApp(const GameArtApp());
}
