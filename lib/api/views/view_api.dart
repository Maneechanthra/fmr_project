import 'dart:convert';

class ViewModel {
  final String restaurantId;
  final String? viewBy;
  final String updatedAt;
  final String createdAt;
  final int id;

  ViewModel({
    required this.restaurantId,
    required this.viewBy,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory ViewModel.fromJson(Map<String, dynamic> json) => ViewModel(
        restaurantId: json["restaurant_id"],
        viewBy: json["view_by"] ?? null,
        updatedAt: json["updated_at"],
        createdAt: json["created_at"],
        id: json["id"],
      );
}
