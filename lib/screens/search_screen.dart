import 'package:flutter/material.dart';
import '../models/wallpaper_model.dart';
import '../services/wallpaper_service.dart';
import '../widgets/wallpaper_card.dart';

class WallpaperSearchDelegate extends SearchDelegate {
  final WallpaperService service;
  WallpaperSearchDelegate(this.service);

  List<WallpaperModel> _results = [];
  bool _loading = false;

  @override
  String? get searchFieldLabel => 'Search wallpapers…';

  @override
  List<Widget>? buildActions(BuildContext context) => [
    if (query.isNotEmpty)
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          _results = [];
          showSuggestions(context);
        },
      ),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, null),
  );

  @override
  Widget buildSuggestions(BuildContext ctx) {
    _fetch();
    return _results.isEmpty && !_loading
        ? const Center(child: Text('Type a title, tag, or category'))
        : _buildGrid();
  }

  @override
  Widget buildResults(BuildContext ctx) => _buildGrid();

  void _fetch() {
    if (query.trim().isEmpty || _loading) return;
    _loading = true;

    Future.microtask(() async {
      final list = await service.searchWallpapers(query);
      _results = list;
      _loading = false;

      // ✅ This forces SearchDelegate to rebuild
      query = query;
    });
  }

  Widget _buildGrid() => _loading
      ? const Center(child: CircularProgressIndicator())
      : GridView.builder(
    padding: const EdgeInsets.all(16),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.7,
    ),
    itemCount: _results.length,
    itemBuilder: (_, i) => WallpaperCard(wallpaper: _results[i]),
  );
}
