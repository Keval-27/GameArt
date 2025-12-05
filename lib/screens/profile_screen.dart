import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/theme_controller.dart';
import '../controllers/favorites_controller.dart';
import '../routes/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCtrl = Get.find<ThemeController>();
    final favCtrl = Get.find<FavoritesController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        children: [
          const SizedBox(height: 12),

          // Premium Tile
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            color: Colors.amber.shade50,
            child: ListTile(
              leading: const Icon(Icons.star, color: Colors.orangeAccent),
              title: const Text(
                'Go Premium',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              subtitle: const Text(
                'Remove ads and unlock all 4K wallpapers',
                style: TextStyle(color: Colors.black),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Get.toNamed(AppRoutes.premium),
            ),
          ),

          const Divider(),

          // Theme Selector
          ListTile(
            title: const Text('Theme'),
            trailing: Obx(() => Text(
              themeCtrl.currentTheme.value.name.toUpperCase(),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            )),
            onTap: () => _showThemeSheet(themeCtrl),
          ),

          const Divider(),

          // Favorites Count
          Obx(() {
            return ListTile(
              title: const Text('Favourites count'),
              subtitle: Text('${favCtrl.favoriteIds.length} items'),
              leading: const Icon(Icons.favorite),
            );
          }),
        ],
      ),
    );
  }

  void _showThemeSheet(ThemeController controller) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Get.theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Select Theme',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Obx(() {
              return Column(
                children: [
                  RadioListTile<AppThemeMode>(
                    title: const Text('Light'),
                    value: AppThemeMode.light,
                    groupValue: controller.currentTheme.value,
                    onChanged: (v) {
                      if (v != null) {
                        controller.setTheme(v);
                        Get.back();
                      }
                    },
                  ),
                  RadioListTile<AppThemeMode>(
                    title: const Text('Dark'),
                    value: AppThemeMode.dark,
                    groupValue: controller.currentTheme.value,
                    onChanged: (v) {
                      if (v != null) {
                        controller.setTheme(v);
                        Get.back();
                      }
                    },
                  ),
                  RadioListTile<AppThemeMode>(
                    title: const Text('AMOLED'),
                    value: AppThemeMode.amoled,
                    groupValue: controller.currentTheme.value,
                    onChanged: (v) {
                      if (v != null) {
                        controller.setTheme(v);
                        Get.back();
                      }
                    },
                  ),
                ],
              );
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
