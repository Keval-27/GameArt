class CategoryModel {
  final String id;
  final String name;
  int count;
  final String thumbnail;
  final String description;

  CategoryModel({
    required this.id,
    required this.name,
    required this.count,
    required this.thumbnail,
    this.description = '',
  });

  factory CategoryModel.fromMap(String id, Map<String, dynamic> data) {
    return CategoryModel(
      id: id,
      name: (data['name'] ?? '').toString(),
      count: (data['count'] ?? 0) as int,
      thumbnail: (data['thumbnail'] ?? '').toString(),
      description: (data['description'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'count': count,
    'thumbnail': thumbnail,
    'description': description,
  };
}
