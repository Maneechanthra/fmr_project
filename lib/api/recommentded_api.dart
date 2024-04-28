import 'dart:convert';
import 'package:http/http.dart' as http;
import '/globals.dart' as globals;

class RecommendedModel {
  final int id;
  final String restaurantName;
  final String title;
  final int verified;
  final double latitude;
  final double longitude;
  final String categoryTitle;
  final String imagePath;
  final dynamic averageRating;
  final int? reviewCount;
  final int? favoritesCount;
  double? score;
  double? distance; // This field stores the calculated distance

  RecommendedModel({
    required this.id,
    required this.restaurantName,
    required this.title,
    required this.imagePath,
    required this.averageRating,
    required this.reviewCount,
    required this.verified,
    required this.categoryTitle,
    required this.latitude,
    required this.longitude,
    required this.favoritesCount,
    this.distance,
    this.score,
  });

  factory RecommendedModel.fromJson(Map<String, dynamic> json) =>
      RecommendedModel(
        id: json["id"],
        restaurantName: json["restaurant_name"],
        title: json["title"],
        imagePath: json["image_path"],
        averageRating: json["average_rating"],
        reviewCount: json["review_count"],
        verified: json["verified"],
        categoryTitle: json["category_title"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        favoritesCount: json["favorites_count"],
        distance: json["distance"],
        score: json["score"],
      );
}

Future<List<RecommendedModel>> fetchRestaurants() async {
  final response = await http.get(
    Uri.parse('http://10.0.2.2:8000/api/recommended'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': '*/*',
      'connection': 'keep-alive',
      // 'Authorization': 'Bearer ' + globals.jwtToken,
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
