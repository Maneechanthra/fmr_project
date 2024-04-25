import 'dart:convert';
import 'package:http/http.dart' as http;
import '/globals.dart' as globals;

import 'dart:convert';

import 'dart:convert';

import 'dart:convert';

import 'dart:convert';

class RestaurantById {
  final int id;
  final String restaurantName;
  final String categoryTitle;
  final double latitude;
  final double longitude;
  final String address;
  final String telephone1;
  final dynamic telephone2;
  final int verified;
  final double averageRating;
  final int reviewCount;
  final int favoritesCount;
  final int viewCount;
  final List<String> imagePaths;
  final List<Review> reviews;

  RestaurantById({
    required this.id,
    required this.restaurantName,
    required this.categoryTitle,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.telephone1,
    required this.telephone2,
    required this.verified,
    required this.averageRating,
    required this.reviewCount,
    required this.favoritesCount,
    required this.viewCount,
    required this.imagePaths,
    required this.reviews,
  });

  factory RestaurantById.fromJson(Map<String, dynamic> json) => RestaurantById(
        id: json["id"],
        restaurantName: json["restaurant_name"],
        categoryTitle: json["category_title"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        address: json["address"],
        telephone1: json["telephone_1"],
        telephone2: json["telephone_2"],
        verified: json["verified"],
        averageRating: json["average_rating"]?.toDouble(),
        reviewCount: json["review_count"],
        favoritesCount: json["favorites_count"],
        viewCount: json["view_count"],
        imagePaths: List<String>.from(json["image_paths"].map((x) => x)),
        reviews:
            List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
      );
}

class Review {
  final String? title;
  final String content;
  final int id;
  final double rating;
  final String name;
  final String created_at;
  final List<dynamic> imagePathsReview;

  Review({
    required this.title,
    required this.content,
    required this.id,
    required this.rating,
    required this.name,
    required this.created_at,
    required this.imagePathsReview,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        title: json["title"],
        content: json["content"],
        id: json["id"],
        rating: json["rating"]?.toDouble(),
        name: json["name"],
        created_at: json["created_at"],
        imagePathsReview:
            List<dynamic>.from(json["image_paths_review"].map((x) => x)),
      );
}

// ----------------------------------------------------------------
// ----------------------------------------------------------------
Future<RestaurantById> getRestaurantById(int restaurantId) async {
  final response = await http.get(
    Uri.parse('http://10.0.2.2:8000/api/restaurant/$restaurantId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': '*/*',
      'connection': 'keep-alive',
    },
  );

  if (response.statusCode == 200) {
    try {
      final data = json.decode(response.body);

      if (data is Map && data.containsKey('restaurant')) {
        final restaurantData = data['restaurant'];

        if (restaurantData == null) {
          throw Exception('Restaurant data is null');
        }
        return RestaurantById.fromJson(restaurantData);
      } else {
        throw Exception(
            'Invalid data structure. Expected a single restaurant object');
      }
    } catch (e) {
      print('Error decoding JSON: $e');
      throw Exception('Failed to decode JSON data');
    }
  } else {
    throw Exception(
        'Failed to load data from API. HTTP status: ${response.statusCode}');
  }
}
