import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/wallpaper_model.dart';
import '../services/wallpaper_service.dart';
import '../services/wallpaper_helper.dart';

class WallpaperDetailController extends GetxController {
  final WallpaperService _service = WallpaperService();

  late final WallpaperModel wallpaper;

  final RxBool isLoading = false.obs;
  final RxBool isFavorite = false.obs;

  @override
  void onInit() {
    super.onInit();
    wallpaper = Get.arguments as WallpaperModel;
  } 

  Future<void> downloadToGallery() async {
    try {
      isLoading.value = true;

      await _service.downloadToGallery(
        wallpaper.imageUrl,
        filename: '${wallpaper.title}.jpg',
      );

      Get.snackbar(
        'Success',
        '✅ Downloaded successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        '❌ Download failed: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setWallpaper(int location) async {
    try {
      isLoading.value = true;

      await WallpaperHelper.setWallpaper(wallpaper.imageUrl, location);

      String locationText = location == WallpaperHelper.home
          ? 'Home Screen'
          : location == WallpaperHelper.lock
          ? 'Lock Screen'
          : 'Both Screens';

      Get.snackbar(
        'Success',
        '✅ Set as $locationText wallpaper!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        '❌ Failed: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
