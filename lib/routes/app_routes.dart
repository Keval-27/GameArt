import 'package:get/get.dart';
import '../bindings/home_binding.dart';
import '../bindings/category_binding.dart';
import '../bindings/category_wallpaper_binding.dart';
import '../bindings/wallpaper_detail_binding.dart';
import '../bindings/favorites_binding.dart';
import '../bindings/search_binding.dart';
import '../screens/splash_screen.dart';
import '../screens/main_screen.dart';
import '../screens/home_screen.dart';
import '../screens/categories_screen.dart';
import '../screens/category_wallpapers_screen.dart';
import '../screens/wallpaper_detail_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/search_screen.dart';
import '../screens/premium_screen.dart';
import '../screens/profile_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String main = '/main';
  static const String home = '/home';
  static const String categories = '/categories';
  static const String categoryWallpapers = '/category-wallpapers';
  static const String wallpaperDetail = '/wallpaper-detail';
  static const String favorites = '/favorites';
  static const String search = '/search';
  static const String premium = '/premium';
  static const String profile = '/profile';

  static final routes = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: main,
      page: () => const MainScreen(),
      bindings: [
        HomeBinding(),
        CategoryBinding(),
        FavoritesBinding(),
      ],
    ),
    GetPage(
      name: categoryWallpapers,
      page: () => const CategoryWallpapersScreen(),
      binding: CategoryWallpaperBinding(),
    ),
    GetPage(
      name: wallpaperDetail,
      page: () => const WallpaperDetailScreen(),
      binding: WallpaperDetailBinding(),
    ),
    GetPage(
      name: search,
      page: () => const SearchScreen(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: premium,
      page: () => const PremiumScreen(),
    ),
  ];
}
