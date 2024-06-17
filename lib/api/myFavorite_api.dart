import 'dart:convert';
import 'package:http/http.dart' as http;
import '/globals.dart' as globals;

import 'dart:convert';

class MyFavoriteModel {
  final int id;
  final String restaurantName;
  final int verified;
  final int status;
  final String imagePath;
  final double? averageRating;
  final int reviewCount;
  final int favoritesCount;
  final int viewCount;
  final List<String> restaurantCategory;

  MyFavoriteModel({
    required this.id,
    required this.restaurantName,
    required this.verified,
    required this.status,
    required this.imagePath,
    required this.averageRating,
    required this.reviewCount,
    required this.favoritesCount,
    required this.viewCount,
    required this.restaurantCategory,
  });

  factory MyFavoriteModel.fromRawJson(String str) =>
      MyFavoriteModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MyFavoriteModel.fromJson(Map<String, dynamic> json) =>
      MyFavoriteModel(
        id: json["id"],
        restaurantName: json["restaurant_name"],
        verified: json["verified"],
        status: json["status"],
        imagePath: json["image_path"],
        averageRating: json["average_rating"]?.toDouble(),
        reviewCount: json["review_count"],
        favoritesCount: json["favorites_count"],
        viewCount: json["view_count"],
        restaurantCategory:
            List<String>.from(json["restaurant_category"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "restaurant_name": restaurantName,
        "verified": verified,
        "status": status,
        "image_path": imagePath,
        "average_rating": averageRating,
        "review_count": reviewCount,
        "favorites_count": favoritesCount,
        "view_count": viewCount,
        "restaurant_category":
            List<dynamic>.from(restaurantCategory.map((x) => x)),
      };
}

Future<List<MyFavoriteModel>> fetchMyFavorites(int? userId) async {
  final response = await http.get(
    Uri.parse('https://www.smt-online.com/api/favorites/my/$userId'),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': '*/*',
      'Connection': 'keep-alive',
      'Authorization': 'Bearer ' + globals.jwtToken,
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);

    List<dynamic> restaurantData;
    if (data is List) {
      if (data.isNotEmpty && data.first is List) {
        restaurantData = data.expand((e) => e).toList();
      } else {
        restaurantData = data;
      }

      return restaurantData
          .map((item) => MyFavoriteModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Expected a list but got something else');
    }
  } else {
    throw Exception('Failed to load data from API');
  }
}
