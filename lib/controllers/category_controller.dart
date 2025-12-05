import 'package:get/get.dart';
import '../models/category_model.dart';
import '../services/wallpaper_service.dart';

class CategoryController extends GetxController {
  final WallpaperService _service = WallpaperService();

  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final cats = await _service.getCategories();
      categories.assignAll(cats);

    } catch (e) {
      errorMessage.value = 'Failed to load categories: $e';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() async {
    await loadCategories();
  }
}
