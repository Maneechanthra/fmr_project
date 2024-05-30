import 'dart:convert';

class ImageRestaurantModel {
  final RestaurantImages restaurantImages;

  ImageRestaurantModel({
    required this.restaurantImages,
  });

  factory ImageRestaurantModel.fromJson(Map<String, dynamic> json) =>
      ImageRestaurantModel(
        restaurantImages: RestaurantImages.fromJson(json["restaurant_images"]),
      );
}

class RestaurantImages {
  final String restaurantId;
  final String path;
  final String updatedAt;
  final String createdAt;
  final int id;

  RestaurantImages({
    required this.restaurantId,
    required this.path,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory RestaurantImages.fromJson(Map<String, dynamic> json) =>
      RestaurantImages(
        restaurantId: json["restaurant_id"],
        path: json["path"],
        updatedAt: json["updated_at"],
        createdAt: json["created_at"],
        id: json["id"],
      );
}
