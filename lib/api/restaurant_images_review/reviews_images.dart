import 'dart:convert';

class ReviewsImages {
  final RestaurantReviewsImages restaurantReviewsImages;

  ReviewsImages({
    required this.restaurantReviewsImages,
  });

  factory ReviewsImages.fromJson(Map<String, dynamic> json) => ReviewsImages(
        restaurantReviewsImages:
            RestaurantReviewsImages.fromJson(json["restaurant_reviews_images"]),
      );
}

class RestaurantReviewsImages {
  final String reviewId;
  final String path;
  final String updatedAt;
  final String createdAt;
  final int id;

  RestaurantReviewsImages({
    required this.reviewId,
    required this.path,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory RestaurantReviewsImages.fromJson(Map<String, dynamic> json) =>
      RestaurantReviewsImages(
        reviewId: json["review_id"],
        path: json["path"],
        updatedAt: json["updated_at"],
        createdAt: json["created_at"],
        id: json["id"],
      );
}
