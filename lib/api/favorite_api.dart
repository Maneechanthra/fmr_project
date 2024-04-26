import 'dart:convert';

class FavoritesModel {
  final String restaurantId;
  final String favoriteBy;
  final String updatedAt;
  final String createdAt;
  final int id;

  FavoritesModel({
    required this.restaurantId,
    required this.favoriteBy,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory FavoritesModel.fromRawJson(String str) =>
      FavoritesModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FavoritesModel.fromJson(Map<String, dynamic> json) => FavoritesModel(
        restaurantId: json["restaurant_id"],
        favoriteBy: json["favorite_by"],
        updatedAt: json["updated_at"],
        createdAt: json["created_at"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "restaurant_id": restaurantId,
        "favorite_by": favoriteBy,
        "updated_at": updatedAt,
        "created_at": createdAt,
        "id": id,
      };
}
