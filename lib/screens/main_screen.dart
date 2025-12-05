import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_screen.dart';
import 'categories_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';
import 'premium_screen.dart';
import '../controllers/wallpaper_controller.dart';
import '../controllers/category_controller.dart';
import '../controllers/favorites_controller.dart';


class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {


    if (!Get.isRegistered<WallpaperController>()) {
      Get.put<WallpaperController>(WallpaperController(), permanent: false);
    }
    if (!Get.isRegistered<CategoryController>()) {
      Get.put<CategoryController>(CategoryController(), permanent: false);
    }
    if (!Get.isRegistered<FavoritesController>()) {
      Get.put<FavoritesController>(FavoritesController(), permanent: true);
    }

    final currentIndex = 0.obs;

    final pages = [
      const HomeScreen(),
      const CategoriesScreen(),
      const FavoritesScreen(),
      const ProfileScreen(),
      const PremiumScreen(),
    ];

    return Scaffold(
      body: Obx(() => IndexedStack(
        index: currentIndex.value,
        children: pages,
      )),
      bottomNavigationBar: Obx(() {
        return NavigationBar(
          selectedIndex: currentIndex.value,
          onDestinationSelected: (i) => currentIndex.value = i,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.grid_view_outlined),
              selectedIcon: Icon(Icons.grid_view),
              label: 'Categories',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_outline),
              selectedIcon: Icon(Icons.favorite),
              label: 'Favourites',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
            NavigationDestination(
              icon: Icon(Icons.workspace_premium),
              selectedIcon: Icon(Icons.workspace_premium),
              label: 'Premium',
            ),
          ],
        );
      }),
    );
  }
}
