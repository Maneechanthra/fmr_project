import 'dart:convert';

// class ReviewRestaurant {
//   final int? restaurantId;
//   final String content;
//   final double? rating; // Make rating nullable to prevent type errors
//   final int? reviewBy;
//   final List<String>? path;

//   ReviewRestaurant({
//     this.restaurantId,
//     required this.content,
//     this.rating, // Nullable
//     this.reviewBy,
//     this.path,
//   });

//   factory ReviewRestaurant.fromJson(Map<String, dynamic> json) {
//     return ReviewRestaurant(
//       restaurantId: int.tryParse(
//           json["restaurant_id"]?.toString() ?? ""), // Safely parse to int
//       content: json["content"] ?? "", // Default to empty string if null
//       rating: double.tryParse(
//           json["rating"]?.toString() ?? ""), // Safely parse to double
//       reviewBy: int.tryParse(
//           json["review_by"]?.toString() ?? ""), // Safely parse to int
//       path: json["image_paths"] != null
//           ? List<String>.from(
//               json["image_paths"].map((x) => x.toString())) // Safe parsing
//           : null,
//     );
//   }
// }

import 'dart:io';

// class ReviewRestaurant {
//   final Review review;
//   final int reviewId;
//   final List<File> images;

//   ReviewRestaurant({
//     required this.review,
//     required this.reviewId,
//     required this.images,
//   });

//   factory ReviewRestaurant.fromJson(Map<String, dynamic> json) {
//     return ReviewRestaurant(
//       review: Review.fromJson(json["review"]),
//       reviewId: json["review_id"],
//       // Handle cases where images might not be present
//       images: json["images"] != null
//           ? List<File>.from(json["images"].map((x) => x.toString()))
//           : [], // Default to empty list if images are null
//     );
//   }
// }

// class Review {
//   final String? restaurantId; // Nullable if it might be missing in JSON
//   final String? title; // Nullable if title is optional
//   final String content;
//   final double? rating;
//   final String reviewBy;
//   final String updatedAt;
//   final String createdAt;
//   final int id;

//   Review({
//     this.restaurantId, // Nullable field
//     this.title, // Nullable field
//     required this.content,
//     required this.rating,
//     required this.reviewBy,
//     required this.updatedAt,
//     required this.createdAt,
//     required this.id,
//   });

//   factory Review.fromJson(Map<String, dynamic> json) => Review(
//         restaurantId: json["restaurant_id"] ?? "",
//         title: json["title"] ?? "",
//         content: json["content"],
//         // Check if 'rating' is a double or a string, then convert appropriately
//         rating: json["rating"] is double
//             ? json["rating"]
//             : (json["rating"] is String
//                 ? double.tryParse(
//                     json["rating"]) // Try parsing to double safely
//                 : null), // If it's neither, set it to null
//         reviewBy: json["review_by"],
//         updatedAt: json["updated_at"],
//         createdAt: json["created_at"],
//         id: json["id"],
//       );
// }

////////////////////////////////

import 'dart:convert';

class ReviewRestaurant {
  final Review review;
  final int reviewId;
  final List<File> images;

  ReviewRestaurant({
    required this.review,
    required this.reviewId,
    required this.images,
  });

  factory ReviewRestaurant.fromJson(Map<String, dynamic> json) =>
      ReviewRestaurant(
        review: Review.fromJson(json["review"]),
        reviewId: json["review_id"],
        images: List<File>.from(json["images"].map((x) => x)),
      );
}

class Review {
  final String? restaurantId;
  final String? title;
  final String content;
  final double? rating;
  final String reviewBy;
  final String updatedAt;
  final String createdAt;
  final int id;

  Review({
    this.restaurantId,
    this.title,
    required this.content,
    required this.rating,
    required this.reviewBy,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        restaurantId: json["restaurant_id"] ?? "",
        title: json["title"] ?? "",
        content: json["content"],
        // Check if 'rating' is a double or a string, then convert appropriately
        rating: json["rating"] is double
            ? json["rating"]
            : (json["rating"] is String
                ? double.tryParse(
                    json["rating"]) // Try parsing to double safely
                : null), // If it's neither, set it to null
        reviewBy: json["review_by"],
        updatedAt: json["updated_at"],
        createdAt: json["created_at"],
        id: json["id"],
      );
}
