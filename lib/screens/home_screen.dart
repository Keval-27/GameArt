import 'package:flutter/material.dart';
import '../models/wallpaper_model.dart';
import '../models/category_model.dart';
import '../services/wallpaper_service.dart';
import '../widgets/wallpaper_card.dart';
import '../widgets/category_card.dart';
import 'category_wallpapers_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _service = WallpaperService();
  List<CategoryModel> _categories = [];
  List<WallpaperModel> _allWallpapers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);

    final featuredFuture = _service.getWallpapers(limit: 24);
    final allFuture = _service.getWallpapers(limit: 60);

    // Fetch categories from Firestore
    final rawCategories = await _service.getCategories();

    // Fetch wallpapers count for each category by category name
    final List<CategoryModel> updatedCategories = [];
    for (final cat in rawCategories) {
      final wallpapersInCat = await _service.getWallpaperByCategory(cat.name, limit: 1000);

      updatedCategories.add(CategoryModel(
        id: cat.id,
        name: cat.name,
        count: wallpapersInCat.length,
        thumbnail: cat.thumbnail,
        description: cat.description,
      ));
    }

    final featured = await featuredFuture;
    final all = await allFuture;

    if (!mounted) return;
    setState(() {
      _categories = updatedCategories;
      _allWallpapers = all;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GameArt'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => showSearch(
                context: context, delegate: WallpaperSearchDelegate(_service)),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [

            const SizedBox(height: 24),

            // Categories horizontal list
            const Text(
              'Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 140,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                padding: const EdgeInsets.only(left: 0, right: 16),
                itemBuilder: (_, i) {
                  final cat = _categories[i];
                  // Debug print to verify counts
                  print('Category: ${cat.name} - Count: ${cat.count}');

                  return SizedBox(
                    width: 120,
                    child: CategoryCard(
                      category: cat,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CategoryWallpapersScreen(
                            category: cat,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // All wallpapers grid
            const Text(
              'All Wallpapers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _allWallpapers.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (_, i) => WallpaperCard(
                wallpaper: _allWallpapers[i],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
