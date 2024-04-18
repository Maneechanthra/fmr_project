import 'dart:convert';
import 'package:http/http.dart' as http;
import '/globals.dart' as globals;

class RecommendedModel {
  final int id;
  final String restaurantName;
  final String title;
  final String path;
  final dynamic averageRating;
  final int reviewCount;

  RecommendedModel({
    required this.id,
    required this.restaurantName,
    required this.title,
    required this.path,
    required this.averageRating,
    required this.reviewCount,
  });

  factory RecommendedModel.fromJson(Map<String, dynamic> json) =>
      RecommendedModel(
        id: json["id"],
        restaurantName: json["restaurant_name"],
        title: json["title"],
        path: json["path"],
        averageRating: json["average_rating"],
        reviewCount: json["review_count"],
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
