class Category {
  String id;
  String categoryName;
  DateTime createdAt;

  // Constructor
  Category({
    required this.id,
    required this.categoryName,
    required this.createdAt,
  });

  // Named constructor for creating an instance from a Firestore document snapshot
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      categoryName: json['categoryName'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // Convert a Category instance to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryName': categoryName,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Category(id: $id, categoryName: $categoryName, createdAt: $createdAt)';
  }
}
