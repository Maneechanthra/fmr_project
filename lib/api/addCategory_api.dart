import 'dart:convert';

class AddCategoryModel {
  final Category category;

  AddCategoryModel({
    required this.category,
  });

  factory AddCategoryModel.fromRawJson(String str) =>
      AddCategoryModel.fromJson(json.decode(str));

  factory AddCategoryModel.fromJson(Map<String, dynamic> json) =>
      AddCategoryModel(
        category: Category.fromJson(json["category"]),
      );
}

class Category {
  final String restaurantId;
  final String categoryId;
  final String updatedAt;
  final String createdAt;
  final int id;

  Category({
    required this.restaurantId,
    required this.categoryId,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        restaurantId: json["restaurant_id"],
        categoryId: json["category_id"],
        updatedAt: json["updated_at"],
        createdAt: json["created_at"],
        id: json["id"],
      );
}
