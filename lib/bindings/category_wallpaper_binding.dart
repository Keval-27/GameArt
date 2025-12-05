import 'package:get/get.dart';
import '../controllers/category_wallpaper_controller.dart';

class CategoryWallpaperBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CategoryWallpaperController>(
      CategoryWallpaperController(),
      permanent: false,
    );
  }
}
