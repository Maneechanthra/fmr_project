class VerifiedModel {
  final int id;
  final int updatedBy;

  VerifiedModel({
    required this.id,
    required this.updatedBy,
  });

  factory VerifiedModel.fromJson(Map<String, dynamic> json) {
    return VerifiedModel(
      id: json["id"] != null
          ? (json["id"] is String ? int.parse(json["id"]) : json["id"])
          : 0,
      updatedBy: json["updated_by"] != null
          ? (json["updated_by"] is String
              ? int.parse(json["updated_by"])
              : json["updated_by"])
          : 0,
    );
  }
}
