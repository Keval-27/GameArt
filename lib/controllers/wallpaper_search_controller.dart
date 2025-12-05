import 'package:get/get.dart';
import '../models/wallpaper_model.dart';
import '../services/wallpaper_service.dart';

class WallpaperSearchController extends GetxController {
  final WallpaperService _service = WallpaperService();

  final RxList<WallpaperModel> searchResults = <WallpaperModel>[].obs;
  final RxBool isSearching = false.obs;
  final RxString currentQuery = ''.obs;

  Future<void> search(String query) async {
    try {
      if (query.trim().isEmpty) {
        searchResults.clear();
        currentQuery.value = '';
        return;
      }

      isSearching.value = true;
      currentQuery.value = query;

      final results = await _service.searchWallpapers(query);
      searchResults.assignAll(results);
    } catch (e) {
      Get.snackbar('Search Error', 'Failed to search: $e');
    } finally {
      isSearching.value = false;
    }
  }

  void clearSearch() {
    searchResults.clear();
    currentQuery.value = '';
  }
}
