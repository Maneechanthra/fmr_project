import 'dart:convert';

class AddRestaurantModel {
  final Restaurant restaurant;
  final int restaurantId;

  AddRestaurantModel({
    required this.restaurant,
    required this.restaurantId,
  });

  factory AddRestaurantModel.fromJson(Map<String, dynamic> json) =>
      AddRestaurantModel(
        restaurant: Restaurant.fromJson(json["restaurant"]),
        restaurantId: json["restaurant_id"],
      );
}

class Restaurant {
  final String restaurantName;
  // final String address;
  final String telephone1;
  final dynamic telephone2;
  // final String latitude;
  // final String longitude;
  final String createdBy;
  final String updatedAt;
  final String createdAt;
  final int id;

  Restaurant({
    required this.restaurantName,
    // required this.address,
    required this.telephone1,
    required this.telephone2,
    // required this.latitude,
    // required this.longitude,
    required this.createdBy,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        restaurantName: json["restaurant_name"],
        // address: json["address"],
        telephone1: json["telephone_1"],
        telephone2: json["telephone_2"],
        // latitude: json["latitude"],
        // longitude: json["longitude"],
        createdBy: json["created_by"],
        updatedAt: json["updated_at"],
        createdAt: json["created_at"],
        id: json["id"],
      );
}
