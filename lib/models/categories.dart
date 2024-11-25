class CategoryModel {
  final String categoryId;
  final String categoryImages;
  final String categoryName;
  final dynamic createdAt;
  final dynamic updatedAt;

  CategoryModel({
    required this.categoryId,
    required this.categoryImages,
    required this.categoryName,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create CategoryModel from JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryId: json['categoryId'] as String,
        categoryImages: json['categoryImages'] as String,
      categoryName: json['categoryName'] as String,
      createdAt:json['createdAt'] ,
      updatedAt:json['updatedAt']
    );
  }

  // Method to convert CategoryModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'categoryImages': categoryImages,
      'categoryName': categoryName,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
