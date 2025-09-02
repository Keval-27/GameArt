import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../services/wallpaper_service.dart';
import '../widgets/category_card.dart';
import 'category_wallpapers_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final _service = WallpaperService();
  List<CategoryModel> _categories = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    loadCategoriesWithCounts();
  }

  Future<void> loadCategoriesWithCounts() async {
    final categories = await _service.getCategories();
    final List<CategoryModel> updated = [];
    for (var cat in categories) {
      final wallpapers = await _service.getWallpaperByCategory(cat.name, limit: 1000);
      updated.add(CategoryModel(
          id: cat.id,
          name: cat.name,
          count: wallpapers.length,
          thumbnail: cat.thumbnail,
          description: cat.description));
    }
    if (!mounted) return;
    setState(() {
      _categories = updated;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.0,
        ),
        itemCount: _categories.length,
        itemBuilder: (_, i) {
          final category = _categories[i];
          return CategoryCard(
            category: category,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CategoryWallpapersScreen(category: category),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
