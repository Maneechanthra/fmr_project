import 'dart:convert';
import 'dart:convert';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '/globals.dart' as globals;

import 'dart:convert';

// class GetResturantByMap {
//   final int id;
//   final String restaurantName;
//   final String categoryTitle;
//   final double latitude;
//   final double longitude;
//   final String address;
//   final String telephone1;
//   final dynamic telephone2;
//   final int verified;
//   final double averageRating;
//   final int reviewCount;
//   final int favoritesCount;
//   final int viewCount;
//   final List<String> restaurantCategory;
//   final List<String> imagePaths;

//   GetResturantByMap({
//     required this.id,
//     required this.restaurantName,
//     required this.categoryTitle,
//     required this.latitude,
//     required this.longitude,
//     required this.address,
//     required this.telephone1,
//     required this.telephone2,
//     required this.verified,
//     required this.averageRating,
//     required this.reviewCount,
//     required this.favoritesCount,
//     required this.viewCount,
//     required this.restaurantCategory,
//     required this.imagePaths,
//   });

//   factory GetResturantByMap.fromJson(Map<String, dynamic> json) =>
//       GetResturantByMap(
//         id: json["id"],
//         restaurantName: json["restaurant_name"],
//         categoryTitle: json["category_title"],
//         latitude: json["latitude"]?.toDouble(),
//         longitude: json["longitude"]?.toDouble(),
//         address: json["address"],
//         telephone1: json["telephone_1"],
//         telephone2: json["telephone_2"],
//         verified: json["verified"],
//         averageRating: json["average_rating"]?.toDouble(),
//         reviewCount: json["review_count"],
//         favoritesCount: json["favorites_count"],
//         viewCount: json["view_count"],
//         restaurantCategory:
//             List<String>.from(json["restaurant_category"].map((x) => x)),
//         imagePaths: List<String>.from(json["image_paths"].map((x) => x)),
//       );
// }

// import 'dart:convert';

// class GetResturantByMap {
//   final List<Restaurant> restaurants;

//   GetResturantByMap({
//     required this.restaurants,
//   });

//   factory GetResturantByMap.fromJson(Map<String, dynamic> json) =>
//       GetResturantByMap(
//         restaurants: List<Restaurant>.from(
//             json["restaurants"].map((x) => Restaurant.fromJson(x))),
//       );
// }

// class Restaurant {
//   final int id;
//   final String restaurantName;
//   final double latitude;
//   final double longitude;
//   final String address;
//   final String telephone1;
//   final String? telephone2; // สามารถเป็น null
//   final int verified;
//   final double? averageRating; // สามารถเป็น null
//   final int? reviewCount; // สามารถเป็น null
//   final int? favoritesCount; // สามารถเป็น null
//   final int? viewCount; // สามารถเป็น null
//   final List<String> restaurantCategory; // รายการประเภทอาหาร
//   final List<String> imagePaths; // รายการเส้นทางรูปภาพ

//   Restaurant({
//     required this.id,
//     required this.restaurantName,
//     required this.latitude,
//     required this.longitude,
//     required this.address,
//     required this.telephone1,
//     this.telephone2, // ค่าเริ่มต้นเป็น null
//     required this.verified,
//     this.averageRating, // ค่าเริ่มต้นเป็น null
//     this.reviewCount, // ค่าเริ่มต้นเป็น null
//     this.favoritesCount, // ค่าเริ่มต้นเป็น null
//     this.viewCount, // ค่าเริ่มต้นเป็น null
//     required this.restaurantCategory,
//     required this.imagePaths,
//   });

//   factory Restaurant.fromJson(Map<String, dynamic> json) {
//     return Restaurant(
//       id: json["id"],
//       restaurantName: json["restaurant_name"] ?? "ไม่ทราบชื่อร้านอาหาร",
//       latitude: json["latitude"]?.toDouble() ?? 0.0, // ค่าเริ่มต้น
//       longitude: json["longitude"]?.toDouble() ?? 0.0, // ค่าเริ่มต้น
//       address: json["address"] ?? "ไม่ทราบที่อยู่",
//       telephone1: json["telephone_1"] ?? "ไม่ระบุเบอร์โทร",
//       telephone2: json["telephone_2"], // อาจเป็น null
//       verified: json["verified"] ?? 0, // ค่าเริ่มต้น
//       averageRating: json["average_rating"]?.toDouble() ?? 0.0, // ค่าเริ่มต้น
//       reviewCount: json["review_count"] ?? 0, // ค่าเริ่มต้น
//       favoritesCount: json["favorites_count"] ?? 0, // ค่าเริ่มต้น
//       viewCount: json["view_count"] ?? 0, // ค่าเริ่มต้น
//       restaurantCategory: List<String>.from(
//           json["restaurant_category"].map((x) => x)), // การแปลง
//       imagePaths:
//           List<String>.from(json["image_paths"].map((x) => x)), // การแปลง
//     );
//   }
// }

// Future<List<GetResturantByMap>> fetchRestaurantMap() async {
//   final response = await http.get(
//     Uri.parse('http://10.0.2.2:8000/api/restaurants/map'),
//     headers: {
//       'Content-Type': 'application/json; charset=UTF-8',
//       'Accept': '*/*',
//       'Connection': 'keep-alive',
//     },
//   );

//   if (response.statusCode == 200) {
//     final data = json.decode(response.body);

//     List<dynamic> restaurantData;
//     if (data is List) {
//       if (data.isNotEmpty && data.first is List) {
//         restaurantData = data.expand((e) => e).toList();
//       } else {
//         restaurantData = data;
//       }

//       return restaurantData
//           .map((item) => GetResturantByMap.fromJson(item))
//           .toList();
//     } else {
//       throw Exception('Expected a list but got something else');
//     }
//   } else {
//     throw Exception('Failed to load data from API');
//   }
// }

// Future<GetResturantByMap?> fetchRestaurantMap() async {
//   final response = await http.get(
//     Uri.parse('http://10.0.2.2:8000/api/restaurants/map'),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//       'Accept': '*/*',
//       'connection': 'keep-alive',
//     },
//   );

//   if (response.statusCode == 200) {
//     try {
//       final data = json.decode(response.body);

//       if (data is Map && data.containsKey('restaurant')) {
//         final restaurantData = data['restaurant'];

//         if (restaurantData == null) {
//           throw Exception('Restaurant data is null');
//         }
//         return GetResturantByMap.fromJson(restaurantData);
//       } else {
//         throw Exception(
//             'Invalid data structure. Expected a single restaurant object');
//       }
//     } catch (e) {
//       print('Error decoding JSON: $e');
//       throw Exception('Failed to decode JSON data');
//     }
//   } else {
//     throw Exception(
//         'Failed to load data from API. HTTP status: ${response.statusCode}');
//   }
// }

import 'dart:convert';

class GetResturantByMap {
  final List<Restaurant> restaurants;
  final List<Category> categories;

  GetResturantByMap({
    required this.restaurants,
    required this.categories,
  });

  factory GetResturantByMap.fromJson(Map<String, dynamic> json) =>
      GetResturantByMap(
        restaurants: List<Restaurant>.from(
            json["restaurants"].map((x) => Restaurant.fromJson(x))),
        categories: List<Category>.from(
            json["categories"].map((x) => Category.fromJson(x))),
      );
}

class Category {
  final String title;

  Category({
    required this.title,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        title: json["title"],
      );
}

class Restaurant {
  final int id;
  final String restaurantName;
  final double latitude;
  final double longitude;
  final String address;
  final String telephone1;
  final String? telephone2;
  final int verified;
  final double? averageRating;
  final int? reviewCount;
  final int? favoritesCount;
  final int? viewCount;
  final List<String> imagePaths;
  final List<String> restaurantCategory;

  Restaurant({
    required this.id,
    required this.restaurantName,
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
    required this.restaurantCategory,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        id: json["id"],
        restaurantName: json["restaurant_name"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        address: json["address"],
        telephone1: json["telephone_1"],
        telephone2: json["telephone_2"] ?? null,
        verified: json["verified"],
        averageRating: json["average_rating"]?.toDouble(),
        reviewCount: json["review_count"] ?? null,
        favoritesCount: json["favorites_count"] ?? null,
        viewCount: json["view_count"] ?? null,
        imagePaths: json["image_paths"] != null
            ? List<String>.from(json["image_paths"].map((x) => x))
            : [],
        restaurantCategory: json["restaurant_category"] != null
            ? List<String>.from(json["restaurant_category"].map((x) => x))
            : [],
      );
}

Future<GetResturantByMap?> fetchRestaurantMap() async {
  try {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/restaurants/map'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '*/*',
        'Connection': 'keep-alive',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data is Map<String, dynamic> && data.containsKey('restaurants')) {
        return GetResturantByMap.fromJson(
            data); // ตรวจสอบว่าคีย์และประเภทตรงกัน
      } else {
        throw Exception(
            "Unexpected data structure or missing 'restaurants' key");
      }
    } else {
      throw Exception(
          "Failed to load data. HTTP status: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Error fetching data: $e"); // จัดการข้อผิดพลาดทั่วไป
  }
}
