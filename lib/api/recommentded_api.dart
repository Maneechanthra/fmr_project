import 'dart:convert';
import 'package:http/http.dart' as http;
import '/globals.dart' as globals;

class RecommendedModel {
  final int id;
  final String restaurantName;
  final int? verified;
  final double latitude;
  final double longitude;
  final String imagePath;
  final double? averageRating;
  final int? reviewCount;
  final int? favoritesCount;
  final List<String> restaurantCategory;
  double? score;
  double? distance;

  RecommendedModel({
    required this.id,
    required this.restaurantName,
    required this.verified,
    required this.latitude,
    required this.longitude,
    required this.imagePath,
    required this.averageRating,
    required this.reviewCount,
    required this.favoritesCount,
    required this.restaurantCategory,
    this.distance,
    this.score,
  });

  factory RecommendedModel.fromJson(Map<String, dynamic> json) =>
      RecommendedModel(
        id: json["id"],
        restaurantName: json["restaurant_name"],
        verified: json["verified"] ?? 0,
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        imagePath: json["image_path"],
        averageRating: json["average_rating"]?.toDouble() ?? 0.0,
        reviewCount: json["review_count"] ?? 0,
        favoritesCount: json["favorites_count"] ?? 0,
        restaurantCategory:
            List<String>.from(json["restaurant_category"].map((x) => x)),
        distance: json["distance"] ?? 0,
        score: json["score"] ?? 0,
      );
}

Future<List<RecommendedModel>> fetchRestaurants() async {
  final response = await http.get(
    Uri.parse('http://10.0.2.2:8000/api/recommended'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': '*/*',
      'connection': 'keep-alive',
    },
  );

  print(response.statusCode);
  print(response.body);

  if (response.statusCode == 200) {
    try {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final List<dynamic> restaurantsData = data['restaurants'];
      return restaurantsData
          .map((json) => RecommendedModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error decoding JSON: $e');
      throw Exception('Failed to decode JSON data');
    }
  } else {
    print('HTTP error: ${response.statusCode}');
    throw Exception('Failed to load data from API');
  }
}
