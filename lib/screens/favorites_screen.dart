import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/favorites_controller.dart';
import '../widgets/wallpaper_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoritesController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Favourites')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.favoriteIds.isEmpty) {
          return const Center(
            child: Text('No favourites yet. Tap the heart on a wallpaper.'),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.7,
          ),
          itemCount: controller.favoriteWallpapers.length,
          itemBuilder: (_, i) => WallpaperCard(
            wallpaper: controller.favoriteWallpapers[i],
          ),
        );
      }),
    );
  }
}
