import 'dart:convert';
import 'package:http/http.dart' as http;
import '/globals.dart' as globals;

class LoginResponse {
  final String email;
  final int userId;
  final String jwtToken;
  final String name;
  final String? message;
  final int status;

  LoginResponse({
    required this.email,
    required this.userId,
    required this.jwtToken,
    required this.name,
    required this.message,
    required this.status,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        email: json["email"],
        userId: json["userId"],
        jwtToken: json["jwt_token"],
        name: json["name"],
        message: json["message"] ?? "",
        status: json["status"],
      );

  String getToken() {
    return jwtToken;
  }
}
