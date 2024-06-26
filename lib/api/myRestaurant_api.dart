import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/globals.dart' as globals;

// import 'dart:convert';

// class MyRestaurantModel {
//   final int id;
//   final String restaurantName;
//   final String categories;
//   final int verified;
//   final int status;
//   final String address;
//   final String imagePath;
//   final dynamic averageRating;
//   final int reviewCount;
//   final int favoritesCount;
//   final int viewCount;
//   final int reportCount;
//   final String name;

//   MyRestaurantModel({
//     required this.id,
//     required this.restaurantName,
//     required this.categories,
//     required this.verified,
//     required this.status,
//     required this.address,
//     required this.imagePath,
//     required this.averageRating,
//     required this.reviewCount,
//     required this.favoritesCount,
//     required this.viewCount,
//     required this.reportCount,
//     required this.name,
//   });

//   factory MyRestaurantModel.fromRawJson(String str) =>
//       MyRestaurantModel.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory MyRestaurantModel.fromJson(Map<String, dynamic> json) =>
//       MyRestaurantModel(
//         id: json["id"],
//         restaurantName: json["restaurant_name"],
//         categories: json["categories"],
//         verified: json["verified"],
//         status: json["status"],
//         address: json["address"],
//         imagePath: json["image_path"],
//         averageRating: json["average_rating"],
//         reviewCount: json["review_count"],
//         favoritesCount: json["favorites_count"],
//         viewCount: json["view_count"],
//         reportCount: json["reports_count"],
//         name: json["name"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "restaurant_name": restaurantName,
//         "categories": categories,
//         "verified": verified,
//         "status": status,
//         "image_path": imagePath,
//         "average_rating": averageRating,
//         "review_count": reviewCount,
//         "favorites_count": favoritesCount,
//         "view_count": viewCount,
//       };
// }

import 'dart:convert';

class MyRestaurantModel {
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
  // final List<String> restaurantCategory;
  final List<RestaurantCategory> restaurantCategories;
  final List<String> imagePaths;
  final List<Opening> openings;
  final List<Review> reviews;
  final int reportCount;
  final String userName;
  final String? rejectDetail;
  final int status;

  MyRestaurantModel({
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
    // required this.restaurantCategory,
    required this.restaurantCategories,
    required this.imagePaths,
    required this.openings,
    required this.reviews,
    required this.createdBy,
    required this.reportCount,
    required this.userName,
    required this.rejectDetail,
    required this.status,
  });

  factory MyRestaurantModel.fromJson(Map<String, dynamic> json) =>
      MyRestaurantModel(
        id: json["id"],
        restaurantName: json["restaurant_name"],
        // latitude: json["latitude"]?.toDouble(),
        // longitude: json["longitude"]?.toDouble(),
        latitude: json["latitude"],
        longitude: json["longitude"],
        address: json["address"],
        telephone1: json["telephone_1"],
        telephone2: json["telephone_2"] ?? "",
        verified: json["verified"],
        averageRating: json["average_rating"]?.toDouble(),
        reviewCount: json["review_count"],
        favoritesCount: json["favorites_count"],
        viewCount: json["view_count"],
        createdBy: json["created_by"],
        // restaurantCategory:
        //     List<String>.from(json["restaurant_category"].map((x) => x)),
        restaurantCategories: List<RestaurantCategory>.from(
            json["restaurant_categories"]
                .map((x) => RestaurantCategory.fromJson(x))),
        imagePaths: List<String>.from(json["image_paths"].map((x) => x)),
        openings: List<Opening>.from(
            json["openings"].map((x) => Opening.fromJson(x))),
        reviews:
            List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
        reportCount: json["reports_count"],
        userName: json["name"],
        rejectDetail: json["reject_detail"] ?? null,
        status: json["status"],
      );
}

class RestaurantCategory {
  final int id;
  final String categoryTitle;

  RestaurantCategory({
    required this.id,
    required this.categoryTitle,
  });

  factory RestaurantCategory.fromJson(Map<String, dynamic> json) =>
      RestaurantCategory(
        id: json["id"],
        categoryTitle: json["category_title"],
      );
}

class Opening {
  final int? id;
  final int? restaurantId;
  final int dayOpen;
  final String timeOpen;
  final String timeClose;
  final String createdAt;
  final String updatedAt;
  final dynamic deletedAt;

  Opening({
    this.id,
    this.restaurantId,
    required this.dayOpen,
    required this.timeOpen,
    required this.timeClose,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory Opening.fromJson(Map<String, dynamic> json) => Opening(
        id: json["id"],
        restaurantId: json["restaurant_id"],
        dayOpen: json["day_open"],
        timeOpen: json["time_open"],
        timeClose: json["time_close"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        deletedAt: json["deleted_at"],
      );
}

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

Future<List<MyRestaurantModel>> fetchMyRestaurants(int? userId) async {
  final response = await http.get(
    Uri.parse('https://www.smt-online.com/api/restaurant/myrestaurant/$userId'),
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
