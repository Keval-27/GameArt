import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../models/wallpaper_model.dart';
import '../services/wallpaper_service.dart';
import '../widgets/wallpaper_card.dart';

class CategoryWallpapersScreen extends StatefulWidget {
  final CategoryModel category;
  const CategoryWallpapersScreen({super.key, required this.category});

  @override
  State<CategoryWallpapersScreen> createState() => _CategoryWallpapersScreenState();
}

class _CategoryWallpapersScreenState extends State<CategoryWallpapersScreen> {
  final _service = WallpaperService();
  List<WallpaperModel> _wallpapers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchWallpapers();
  }

  Future<void> _fetchWallpapers() async {
    try {
      print('Fetching wallpapers for category: ${widget.category.name}');
      final wallpapers = await _service.getWallpaperByCategory(widget.category.name, limit: 80);
      print('Fetched wallpapers count: ${wallpapers.length}');
      if (!mounted) return;

      setState(() {
        _wallpapers = wallpapers;
        _loading = false;
      });
    } catch (e) {
      print('Error fetching wallpapers: $e');
      if (!mounted) return;

      setState(() {
        _wallpapers = [];
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category.name)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _wallpapers.isEmpty
          ? const Center(
        child: Text(
          'No wallpapers for this category yet.',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.7,
        ),
        itemCount: _wallpapers.length,
        itemBuilder: (_, i) => WallpaperCard(
          wallpaper: _wallpapers[i],
          heroTagPrefix: 'cat_${widget.category.id}',
        ),
      ),
    );
  }
}
