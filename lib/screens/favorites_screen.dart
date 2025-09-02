import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/wallpaper_model.dart';
import '../services/favorites_provider.dart';
import '../services/wallpaper_service.dart';
import '../widgets/wallpaper_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final _service = WallpaperService();
  List<WallpaperModel> _wallpapers = [];
  bool _loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _load();
  }

  Future<void> _load() async {
    final favIds = context.read<FavoritesProvider>().ids.toList();
    if (favIds.isEmpty) {
      setState(() {
        _wallpapers = [];
        _loading = false;
      });
      return;
    }

    // ✅ use new public method from service
    final list = await _service.getWallpapersByIds(favIds);

    setState(() {
      _wallpapers = list;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final favs = context.watch<FavoritesProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Favourites')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : favs.ids.isEmpty
          ? const Center(child: Text('No favourites yet. Tap the heart on a wallpaper.'))
          : GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.7,
        ),
        itemCount: _wallpapers.length,
        itemBuilder: (_, i) => WallpaperCard(wallpaper: _wallpapers[i]),
      ),
    );
  }
}
