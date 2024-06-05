import 'dart:convert';

class ChangPassword {
  final String message;
  final User user;

  ChangPassword({
    required this.message,
    required this.user,
  });

  factory ChangPassword.fromJson(Map<String, dynamic> json) => ChangPassword(
        message: json["message"],
        user: User.fromJson(json["user"]),
      );
}

class User {
  final int id;
  final String name;
  final String email;
  final dynamic emailVerifiedAt;
  final String createdAt;
  final String updatedAt;
  final dynamic deletedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        deletedAt: json["deleted_at"],
      );
}
