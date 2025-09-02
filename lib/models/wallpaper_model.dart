class WallpaperModel {
  final String id;
  final String title;
  final String imageUrl;
  final List<String> tags;
  final String categoryName;  // updated to categoryName

  WallpaperModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.tags,
    required this.categoryName,
  });

  factory WallpaperModel.fromMap(String id, Map<String, dynamic> data) {
    return WallpaperModel(
      id: id,
      title: data['title'] as String? ?? '',
      imageUrl: data['imageUrl'] as String? ?? '',
      tags: (data['tags'] as List<dynamic>?)?.map((t) => t.toString()).toList() ?? [],
      categoryName: data['categoryName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'tags': tags,
      'categoryName': categoryName,
    };
  }
}
