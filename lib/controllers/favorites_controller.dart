import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/wallpaper_model.dart';
import '../services/wallpaper_service.dart';

class FavoritesController extends GetxController {
  final WallpaperService _service = WallpaperService();

  final RxSet<String> favoriteIds = <String>{}.obs;
  final RxList<WallpaperModel> favoriteWallpapers = <WallpaperModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      isLoading.value = true;

      final prefs = await SharedPreferences.getInstance();
      final ids = prefs.getStringList('fav_ids') ?? [];
      favoriteIds.assignAll(ids);

      if (ids.isNotEmpty) {
        final wallpapers = await _service.getWallpapersByIds(ids);
        favoriteWallpapers.assignAll(wallpapers);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleFavorite(String wallpaperId) async {
    if (isFavorite(wallpaperId)) {
      await removeFavorite(wallpaperId);
    } else {
      await addFavorite(wallpaperId);
    }
  }

  Future<void> addFavorite(String id) async {
    try {
      // Add to favorites set
      favoriteIds.add(id);

      // Fetch the wallpaper details if not already in list
      final existingIndex = favoriteWallpapers.indexWhere((w) => w.id == id);
      if (existingIndex == -1) {
        // Wallpaper not in favorites list, fetch it
        final allWallpapers = await _service.getWallpapers(limit: 1000);
        final wallpaper = allWallpapers.firstWhere(
              (w) => w.id == id,
          orElse: () => WallpaperModel(
            id: id,
            title: 'Unknown',
            imageUrl: '',
            tags: [],
            categoryName: '',
          ),
        );
        favoriteWallpapers.add(wallpaper);
      }

      // Save to preferences
      await _saveFavorites();

      Get.snackbar(
        'Added',
        'Added to favorites',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to add favorite: $e');
    }
  }

  Future<void> removeFavorite(String id) async {
    try {
      favoriteIds.remove(id);
      favoriteWallpapers.removeWhere((w) => w.id == id);
      await _saveFavorites();

      Get.snackbar(
        'Removed',
        'Removed from favorites',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove favorite: $e');
    }
  }

  bool isFavorite(String id) => favoriteIds.contains(id);

  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('fav_ids', favoriteIds.toList());
    } catch (e) {
      print('Error saving favorites: $e');
    }
  }

  Future<void> clearAll() async {
    favoriteIds.clear();
    favoriteWallpapers.clear();
    await _saveFavorites();
  }
}
