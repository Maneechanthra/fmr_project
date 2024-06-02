import 'dart:convert';

class Register {
  final String name;
  final String email;
  final String updatedAt;
  final String createdAt;
  final int id;

  Register({
    required this.name,
    required this.email,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory Register.fromJson(Map<String, dynamic> json) => Register(
        name: json["name"],
        email: json["email"],
        updatedAt: json["updated_at"],
        createdAt: json["created_at"],
        id: json["id"],
      );
}
