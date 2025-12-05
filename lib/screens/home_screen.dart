import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/wallpaper_controller.dart';
import '../controllers/category_controller.dart';
import '../widgets/wallpaper_card.dart';
import '../widgets/category_card.dart';
import '../routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wallpaperCtrl = Get.find<WallpaperController>();
    final categoryCtrl = Get.find<CategoryController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('GameArt'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Get.toNamed(AppRoutes.search),
          ),
        ],
      ),
      body: Obx(() {
        if (wallpaperCtrl.isLoading.value && wallpaperCtrl.allWallpapers.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (wallpaperCtrl.errorMessage.isNotEmpty) {
          return Center(child: Text(wallpaperCtrl.errorMessage.value));
        }

        return RefreshIndicator(
          onRefresh: () async {
            await wallpaperCtrl.refresh();
            await categoryCtrl.refresh();
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 24),

              // Categories Section
              const Text(
                'Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Obx(() {
                if (categoryCtrl.isLoading.value) {
                  return const SizedBox(
                    height: 140,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                return SizedBox(
                  height: 140,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categoryCtrl.categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (_, i) {
                      final category = categoryCtrl.categories[i];
                      return SizedBox(
                        width: 120,
                        child: CategoryCard(
                          category: category,
                          onTap: () {
                            Get.toNamed(
                              AppRoutes.categoryWallpapers,
                              arguments: category,
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              }),

              const SizedBox(height: 24),

              // All Wallpapers Section
              const Text(
                'All Wallpapers',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Obx(() {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: wallpaperCtrl.allWallpapers.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (_, i) => WallpaperCard(
                    wallpaper: wallpaperCtrl.allWallpapers[i],
                  ),
                );
              }),
            ],
          ),
        );
      }),
    );
  }
}
