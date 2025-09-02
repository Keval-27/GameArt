  import 'dart:io';
  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:http/http.dart' as http;
  import 'package:path_provider/path_provider.dart';
  import 'package:gallery_saver_plus/gallery_saver.dart';
  import 'package:permission_handler/permission_handler.dart';
  import '../models/category_model.dart';
  import '../models/wallpaper_model.dart';

  class WallpaperService {
    final _db = FirebaseFirestore.instance;

    Future<List<WallpaperModel>> getWallpapersByIds(List<String> ids) async {
      if (ids.isEmpty) return [];
      final snaps = await Future.wait(
        ids.map((id) => _db.collection('wallpapers').doc(id).get()),
      );
      return snaps
          .where((d) => d.exists)
          .map((d) => WallpaperModel.fromMap(d.id, d.data()!))
          .toList();
    }

    Future<List<CategoryModel>> getCategories() async {
      final catSnap = await _db.collection('categories').orderBy('name').get();
      final rawCategories = catSnap.docs.map((d) => CategoryModel.fromMap(d.id, d.data())).toList();

      final List<CategoryModel> updatedCategories = [];
      for (final cat in rawCategories) {
        // Query wallpapers by category name to count wallpapers
        final wallpapersSnap = await _db.collection('wallpapers')
            .where('categoryName', isEqualTo: cat.name)
            .get();

        updatedCategories.add(CategoryModel(
          id: cat.id,
          name: cat.name,
          count: wallpapersSnap.docs.length,
          thumbnail: cat.thumbnail,
          description: cat.description,
        ));
      }

      return updatedCategories;
    }



    Future<List<WallpaperModel>> getWallpapers({int limit = 30}) async {
      final snap = await _db
          .collection('wallpapers')
          .limit(limit)
          .get();
      return snap.docs.map((d) => WallpaperModel.fromMap(d.id, d.data())).toList();
    }

    // services/wallpaper_service.dart

    Future<List<WallpaperModel>> getWallpaperByCategory(String categoryName, {int limit = 80}) async {
      final qSnap = await _db.collection('wallpapers')
          .where('categoryName', isEqualTo: categoryName)
          .limit(limit)
          .get();

      return qSnap.docs.map((d) => WallpaperModel.fromMap(d.id, d.data())).toList();
    }




    Future<List<WallpaperModel>> searchWallpapers(String query, {int limit = 50}) async {
      if (query.trim().isEmpty) return [];
      final qLower = query.toLowerCase().trim();

      try {
        // Fetch wallpapers (adjust limit if needed)
        final snap = await _db.collection('wallpapers').limit(200).get();

        final results = snap.docs.map((d) {
          final wp = WallpaperModel.fromMap(d.id, d.data());
          final categoryName = d.data()['categoryName']?.toString().toLowerCase() ?? '';

          if (wp.title.toLowerCase().contains(qLower) ||
              wp.tags.any((t) => t.toLowerCase().contains(qLower)) ||
              categoryName.contains(qLower)) {
            return wp;
          }
          return null;
        }).whereType<WallpaperModel>().take(limit).toList();

        return results;
      } catch (e) {
        print('Error in searchWallpapers: $e');
        return [];
      }
    }




    Future<void> incrementDownloads(String id) async {
      await _db.collection('wallpapers').doc(id).update({'downloads': FieldValue.increment(1)});
    }

    Future<String> downloadToGallery(String imageUrl, {String? filename}) async {
      final photosStatus = await Permission.photos.request();
      final storageStatus = await Permission.storage.request();
      if (!photosStatus.isGranted && !storageStatus.isGranted) {
        throw Exception('Storage/Gallery permission denied');
      }

      final resp = await http.get(Uri.parse(imageUrl));
      if (resp.statusCode != 200) throw Exception('Failed to download image');

      final bytes = resp.bodyBytes;
      final name = filename ?? 'wallpaper_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$name');
      await file.writeAsBytes(bytes);

      final success = await GallerySaver.saveImage(file.path);
      if (success != true) {
        final appDocDir = await getApplicationDocumentsDirectory();
        final fallbackFile = File('${appDocDir.path}/$name');
        await fallbackFile.writeAsBytes(bytes);
        return fallbackFile.path;
      }

      return file.path;
    }
  }
