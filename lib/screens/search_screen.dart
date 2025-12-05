import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/wallpaper_search_controller.dart';
import '../widgets/wallpaper_card.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WallpaperSearchController>();
    final searchQuery = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchQuery,
          decoration: const InputDecoration(
            hintText: 'Search wallpapers...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white54),
          ),
          style: const TextStyle(color: Colors.white, fontSize: 16),
          onChanged: controller.search,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              searchQuery.clear();
              controller.clearSearch();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.currentQuery.isEmpty) {
          return const Center(
            child: Text('Type a title, tag, or category to search'),
          );
        }
        if (controller.isSearching.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.searchResults.isEmpty) {
          return const Center(child: Text('No results found'));
        }
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.7,
          ),
          itemCount: controller.searchResults.length,
          itemBuilder: (_, i) => WallpaperCard(
            wallpaper: controller.searchResults[i],
          ),
        );
      }),
    );
  }
}
