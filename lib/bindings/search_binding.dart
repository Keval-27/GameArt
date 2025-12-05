import 'package:get/get.dart';
import '../controllers/wallpaper_search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<WallpaperSearchController>(
      WallpaperSearchController(),
    );
  }
}
