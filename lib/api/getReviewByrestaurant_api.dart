import 'dart:convert';
import 'package:http/http.dart' as http;

class GetReviewByrestaurant {
  final String? title;
  final String content;
  final int id;
  final double rating;
  final String? name;
  final String createdAt;
  final int? userId;
  final int restaurant_id;
  final List<String> imagePaths;

  GetReviewByrestaurant({
    required this.title,
    required this.content,
    required this.id,
    required this.rating,
    required this.name,
    required this.createdAt,
    required this.userId,
    required this.restaurant_id,
    required this.imagePaths,
  });

  factory GetReviewByrestaurant.fromJson(Map<String, dynamic> json) =>
      GetReviewByrestaurant(
        title: json["title"] ?? "",
        content: json["content"],
        id: json["id"],
        rating: json["rating"]?.toDouble(),
        name: json["name"] ?? "",
        createdAt: json["created_at"],
        userId: json["userId"] ?? null,
        restaurant_id: json["restaurant_id"],
        imagePaths: List<String>.from(json["image_paths"].map((x) => x)),
      );
}

Future<List<GetReviewByrestaurant>> fetchReviewByRestaurant(
    int restaurantId) async {
  final response = await http.get(
    Uri.parse('http://10.0.2.2:8000/api/reviews/$restaurantId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': '*/*',
      'connection': 'keep-alive',
    },
  ).timeout(const Duration(minutes: 5));

  if (response.statusCode == 200) {
    try {
      final data = json.decode(response.body);

      // ควรตรวจสอบให้แน่ใจว่า `data` เป็น `List` ของรายการรีวิว
      if (data is List) {
        List<GetReviewByrestaurant> reviews = [];

        // แยกข้อมูลทั้งหมดในรายการแล้วแปลงเป็นออบเจ็กต์ `GetReviewByrestaurant`
        for (var item in data) {
          if (item is Map<String, dynamic>) {
            reviews.add(GetReviewByrestaurant.fromJson(item));
          } else {
            throw Exception("Invalid item structure in reviews data.");
          }
        }
        return reviews;
      } else {
        throw Exception(
            "Unexpected data structure. Expected a list of review objects.");
      }
    } catch (e) {
      print("Error decoding JSON: $e");
      throw Exception("Failed to parse JSON data: $e");
    }
  } else {
    throw Exception(
        "Failed to load data from API. HTTP status: ${response.statusCode}");
  }
}
