class DeletedRestaurantModel {
  final int id;

  DeletedRestaurantModel({
    required this.id,
  });

  factory DeletedRestaurantModel.fromJson(Map<String, dynamic> json) {
    return DeletedRestaurantModel(
      id: json["id"] != null
          ? (json["id"] is String ? int.parse(json["id"]) : json["id"])
          : 0,
    );
  }
}
