import 'dart:convert';
import 'package:http/http.dart' as http;

// To parse this JSON data, do
//
//     final getRestaurantModelForUpdated = getRestaurantModelForUpdatedFromJson(jsonString);

// To parse this JSON data, do
//
//     final getRestaurantModelForUpdated = getRestaurantModelForUpdatedFromJson(jsonString);

import 'dart:convert';

class getRestaurantModelForUpdated {
  final int id;
  final String restaurantName;
  final double latitude;
  final double longitude;
  final String address;
  final String telephone1;
  final String? telephone2;
  final int verified;
  final double averageRating;
  final int reviewCount;
  final int favoritesCount;
  final int viewCount;
  final int createdBy;
  final List<String> restaurantCategory;
  final List<String> imagePaths;
  // final List<OpeningUpdated> OpeningUpdateds;
  final List<Review> reviews;

  getRestaurantModelForUpdated({
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
    required this.restaurantCategory,
    required this.imagePaths,
    // required this.OpeningUpdateds,
    required this.reviews,
    required this.createdBy,
  });

  factory getRestaurantModelForUpdated.fromJson(Map<String, dynamic> json) =>
      getRestaurantModelForUpdated(
        id: json["id"],
        restaurantName: json["restaurant_name"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        address: json["address"],
        telephone1: json["telephone_1"],
        telephone2: json["telephone_2"] ?? "",
        verified: json["verified"],
        averageRating: json["average_rating"]?.toDouble(),
        reviewCount: json["review_count"],
        favoritesCount: json["favorites_count"],
        viewCount: json["view_count"],
        createdBy: json["created_by"],
        restaurantCategory:
            List<String>.from(json["restaurant_category"].map((x) => x)),
        imagePaths: List<String>.from(json["image_paths"].map((x) => x)),
        // OpeningUpdateds: List<OpeningUpdated>.from(
        //     json["OpeningUpdateds"].map((x) => OpeningUpdated.fromJson(x))),
        reviews:
            List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
      );
}

// class OpeningUpdated {
//   final int id;
//   final int restaurantId;
//   final int dayOpen;
//   final String timeOpen;
//   final String timeClose;
//   final String createdAt;
//   final String updatedAt;
//   final String deletedAt;

//   OpeningUpdated({
//     required this.id,
//     required this.restaurantId,
//     required this.dayOpen,
//     required this.timeOpen,
//     required this.timeClose,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.deletedAt,
//   });

//   factory OpeningUpdated.fromJson(Map<String, dynamic> json) => OpeningUpdated(
//         id: json["id"],
//         restaurantId: json["restaurant_id"],
//         dayOpen: json["day_open"],
//         timeOpen: json["time_open"],
//         timeClose: json["time_close"],
//         createdAt: json["created_at"],
//         updatedAt: json["updated_at"],
//         deletedAt: json["deleted_at"],
//       );
// }

class Review {
  final dynamic title;
  final String content;
  final int id;
  final double rating;
  final String name;
  final String createdAt;
  final List<String> imagePathsReview;

  Review({
    required this.title,
    required this.content,
    required this.id,
    required this.rating,
    required this.name,
    required this.createdAt,
    required this.imagePathsReview,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        title: json["title"],
        content: json["content"],
        id: json["id"],
        rating: json["rating"]?.toDouble(),
        name: json["name"],
        createdAt: json["created_at"],
        imagePathsReview:
            List<String>.from(json["image_paths_review"].map((x) => x)),
      );
}

// ----------------------------------------------------------------
// ----------------------------------------------------------------

Future<getRestaurantModelForUpdated> fetchUpdatedRestaurant(
    int restaurantId) async {
  final response = await http.get(
    Uri.parse('https://www.smt-online.com/api/restaurant/$restaurantId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': '*/*',
      'connection': 'keep-alive',
    },
  );

  // print(response.body);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return getRestaurantModelForUpdated.fromJson(data);
  } else {
    throw Exception('Failed to load data from API');
  }
}
