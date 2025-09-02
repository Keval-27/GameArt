import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/favorites_provider.dart';
import 'theme/theme_provider.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final themeProvider = ThemeProvider();
  await themeProvider.load();

  final favs = FavoritesProvider();
  await favs.load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider.value(value: favs),
      ],
      child: const GameArtApp(),
    ),
  );
}

class GameArtApp extends StatelessWidget {
  const GameArtApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().theme;
    return MaterialApp(
      title: 'GameArt: HD Wallpaper Hub',
      theme: theme,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
