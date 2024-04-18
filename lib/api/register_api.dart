// To parse this JSON data, do
//
//     final register = registerFromJson(jsonString);

import 'dart:convert';
import 'package:http/http.dart' as http;
import '/globals.dart' as globals;

class Register {
  final String name;
  final String email;

  Register({
    required this.name,
    required this.email,
  });

  factory Register.fromJson(Map<String, dynamic> json) => Register(
        name: json["name"],
        email: json["email"],
      );
}
