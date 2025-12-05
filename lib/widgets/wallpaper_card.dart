import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/wallpaper_model.dart';
import '../controllers/favorites_controller.dart';
import '../routes/app_routes.dart';

class WallpaperCard extends StatelessWidget {
  final WallpaperModel wallpaper;
  final String heroTagPrefix;

  const WallpaperCard({
    super.key,
    required this.wallpaper,
    this.heroTagPrefix = 'wp',
  });

  @override
  Widget build(BuildContext context) {
    final favCtrl = Get.find<FavoritesController>();

    return GestureDetector(
      onTap: () => Get.toNamed(
        AppRoutes.wallpaperDetail,
        arguments: wallpaper,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Hero(
              tag: '${heroTagPrefix}_${wallpaper.id}',
              child: CachedNetworkImage(
                imageUrl: wallpaper.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                placeholder: (c, _) => Container(color: Colors.black12),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
                child: Text(
                  wallpaper.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Obx(() {
                  final isFav = favCtrl.isFavorite(wallpaper.id);
                  return IconButton(
                    onPressed: () => favCtrl.toggleFavorite(wallpaper.id),
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.white,
                      size: 22,
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
