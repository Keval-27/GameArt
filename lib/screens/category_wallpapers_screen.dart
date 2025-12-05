import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/category_wallpaper_controller.dart';
import '../widgets/wallpaper_card.dart';
import '../routes/app_routes.dart';

class CategoryWallpapersScreen extends StatelessWidget {
  const CategoryWallpapersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CategoryWallpaperController>();

    return Scaffold(
      appBar: AppBar(title: Text(controller.category.name)),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.wallpapers.isEmpty) {
          return const Center(
            child: Text('No wallpapers for this category yet.'),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.refresh(),
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.7,
            ),
            itemCount: controller.wallpapers.length,
            itemBuilder: (_, i) => WallpaperCard(
              wallpaper: controller.wallpapers[i],
            ),
          ),
        );
      }),
    );
  }
}
