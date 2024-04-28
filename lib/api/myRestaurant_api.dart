import 'dart:convert';
import 'package:http/http.dart' as http;
import '/globals.dart' as globals;

class MyRestaurantModel {
  final int id;
  final String restaurantName;
  final String title;
  final int verified;
  final int status;
  final String categoryTitle;
  final String imagePath;
  final double? averageRating;
  final int reviewCount;
  final int favoritesCount;
  final int view_count;

  MyRestaurantModel({
    required this.id,
    required this.restaurantName,
    required this.title,
    required this.verified,
    required this.status,
    required this.categoryTitle,
    required this.imagePath,
    required this.averageRating,
    required this.reviewCount,
    required this.favoritesCount,
    required this.view_count,
  });

  factory MyRestaurantModel.fromJson(Map<String, dynamic> json) {
    return MyRestaurantModel(
      id: json["id"],
      restaurantName: json["restaurant_name"],
      title: json["title"],
      verified: json["verified"],
      status: json["status"],
      categoryTitle: json["category_title"],
      imagePath: json["image_path"],
      averageRating: json["average_rating"]?.toDouble(),
      reviewCount: json["review_count"],
      favoritesCount: json["favorites_count"],
      view_count: json["view_count"],
    );
  }
}

Future<List<MyRestaurantModel>> fetchMyRestaurants(int? userId) async {
  final response = await http.get(
    Uri.parse('http://10.0.2.2:8000/api/restaurant/myrestaurant/$userId'),
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
      // ตรวจสอบว่าเป็น list ของ map หรือลิสต์ของลิสต์
      if (data.isNotEmpty && data.first is List) {
        // แบนลิสต์เพื่อให้ได้ list ของ map
        restaurantData = data.expand((e) => e).toList();
      } else {
        restaurantData = data;
      }

      return restaurantData
          .map((item) => MyRestaurantModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Expected a list but got something else');
    }
  } else {
    throw Exception('Failed to load data from API');
  }
}
