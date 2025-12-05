import 'package:get/get.dart';
import '../models/wallpaper_model.dart';
import '../models/category_model.dart';
import '../services/wallpaper_service.dart';

class CategoryWallpaperController extends GetxController {
  final WallpaperService _service = WallpaperService();

  late final CategoryModel category;

  final RxList<WallpaperModel> wallpapers = <WallpaperModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Get category from arguments
    category = Get.arguments as CategoryModel;
    loadWallpapers();
  }

  Future<void> loadWallpapers() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final wps = await _service.getWallpaperByCategory(
        category.name,
        limit: 80,
      );
      wallpapers.assignAll(wps);

    } catch (e) {
      errorMessage.value = 'Failed to load wallpapers: $e';
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() async {
    await loadWallpapers();
  }
}
