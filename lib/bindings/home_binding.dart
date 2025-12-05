import 'package:get/get.dart';
import '../controllers/wallpaper_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<WallpaperController>(
      WallpaperController(),
      permanent: false,
    );
  }
}
