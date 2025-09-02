import 'dart:io';
import 'package:flutter/services.dart';
import 'package:wallpaper_manager_plus/wallpaper_manager_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class WallpaperHelper {
  // Use constants from the plugin
  static const int home = WallpaperManagerPlus.homeScreen;
  static const int lock = WallpaperManagerPlus.lockScreen;
  static const int both = WallpaperManagerPlus.bothScreens;

  static Future<String?> setWallpaper(String fileOrUrl, int location) async {
    File file;

    // If it’s a URL, download to temp dir first
    if (fileOrUrl.startsWith('http')) {
      final response = await http.get(Uri.parse(fileOrUrl));
      if (response.statusCode != 200) {
        throw PlatformException(
          code: 'WALLPAPER',
          message: 'Failed to download image (status: ${response.statusCode})',
        );
      }
      final dir = await getTemporaryDirectory();
      file = File('${dir.path}/wallpaper.jpg');
      await file.writeAsBytes(response.bodyBytes);
    } else {
      file = File(fileOrUrl);
      if (!await file.exists()) {
        throw PlatformException(
          code: 'WALLPAPER',
          message: 'File not found at path: $fileOrUrl',
        );
      }
    }

    try {
      final wm = WallpaperManagerPlus();
      String? result = await wm.setWallpaper(file, location);
      return result; // returns a success message or null
    } catch (e) {
      throw PlatformException(
        code: 'WALLPAPER',
        message: 'Failed to set wallpaper: $e',
      );
    }
  }
}
