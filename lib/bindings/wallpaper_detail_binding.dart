import 'package:get/get.dart';
import '../controllers/wallpaper_detail_controller.dart';

class WallpaperDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<WallpaperDetailController>(
      WallpaperDetailController(),
    );
  }
}
