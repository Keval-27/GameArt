import 'package:get/get.dart';
import '../models/wallpaper_model.dart';
import '../models/category_model.dart';
import '../services/wallpaper_service.dart';

class WallpaperController extends GetxController {
  final WallpaperService _service = WallpaperService();

  // Reactive state
  final RxList<WallpaperModel> allWallpapers = <WallpaperModel>[].obs;
  final RxList<WallpaperModel> featuredWallpapers = <WallpaperModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Pagination
  final RxInt currentPage = 1.obs;
  final RxBool hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadAllWallpapers();
  }

  // Load all wallpapers with pagination
  Future<void> loadAllWallpapers({int limit = 60}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final wallpapers = await _service.getWallpapers(limit: limit);
      allWallpapers.assignAll(wallpapers);
      hasMore.value = wallpapers.length >= limit;

    } catch (e) {
      errorMessage.value = 'Failed to load wallpapers: $e';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        // backgroundColor: const Color(0xFFFF4444),
        // colorText: const Color(0xFFFFFFFF),
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Load featured wallpapers
  Future<void> loadFeaturedWallpapers({int limit = 24}) async {
    try {
      isLoading.value = true;

      final wallpapers = await _service.getWallpapers(limit: limit);
      featuredWallpapers.assignAll(wallpapers);

    } catch (e) {
      errorMessage.value = 'Failed to load featured: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Search wallpapers
  Future<List<WallpaperModel>> searchWallpapers(String query) async {
    try {
      if (query.trim().isEmpty) return [];
      return await _service.searchWallpapers(query);
    } catch (e) {
      Get.snackbar('Search Error', 'Failed to search: $e');
      return [];
    }
  }

  // Refresh all data
  Future<void> refresh() async {
    await loadAllWallpapers();
    await loadFeaturedWallpapers();
  }
}
