import 'dart:convert';
import 'package:http/http.dart' as http;
import '/globals.dart' as globals;

class AddReviewModel {
  final Review review;
  final int reviewId;
  final List<String> images;

  AddReviewModel({
    required this.review,
    required this.reviewId,
    required this.images,
  });

  factory AddReviewModel.fromJson(Map<String, dynamic> json) => AddReviewModel(
        review: Review.fromJson(json["review"]),
        reviewId: json["review_id"],
        images: List<String>.from(json["images"].map((x) => x)),
      );
}

class Review {
  final String restaurantId;
  final String title;
  final String content;
  final String rating;
  final String reviewBy;
  final String updatedAt;
  final String createdAt;
  final int id;

  Review({
    required this.restaurantId,
    required this.title,
    required this.content,
    required this.rating,
    required this.reviewBy,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        restaurantId: json["restaurant_id"],
        title: json["title"],
        content: json["content"],
        rating: json["rating"],
        reviewBy: json["review_by"],
        updatedAt: json["updated_at"],
        createdAt: json["created_at"],
        id: json["id"],
      );
}
