// ignore_for_file: file_names

class ArrivelModel {
  final String arrivalId;
  final String arrivalName;
  final List categoryImages;
  final dynamic createdAt;
  final dynamic updatedAt;

  ArrivelModel({
    required this.arrivalName,
    required this.arrivalId,
    required this.categoryImages,
    required this.createdAt,
    required this.updatedAt,
  });

  // Serialize the CategoriesModel instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'arrivalName':arrivalName,
      'arrivalId':arrivalId,
      'categoryImages': categoryImages,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // Create a CategoriesModel instance from a JSON map
  factory ArrivelModel.fromJson(Map<String, dynamic> json) {
    return ArrivelModel(
      categoryImages: json['categoryImages'],
      createdAt: json['createdAt'].toString(),
      updatedAt: json['updatedAt'].toString(),
      arrivalName:json['arrivalName'],
      arrivalId: json['arrivalId'],
    );
  }
}
