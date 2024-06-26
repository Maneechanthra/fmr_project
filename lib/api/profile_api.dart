import 'dart:convert';
import 'package:http/http.dart' as http;
import '/globals.dart' as globals;

class ProfileModel {
  final int id;
  final String name;
  final String email;
  final dynamic emailVerifiedAt;
  final String createdAt;
  final String updatedAt;
  final int? restaurant_count;
  final int favorites_count;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.restaurant_count,
    required this.favorites_count,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        restaurant_count: json["restaurant_count"] ?? 0,
        favorites_count: json["favorites_count"],
      );
}

Future<ProfileModel?> fetchProfile(int? userId) async {
  if (userId == null || userId == 0) {
    print("User ID is null or zero, skipping API call.");
    return null;
  }

  final response = await http.get(
    Uri.parse('https://www.smt-online.com/api/user/$userId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': '*/*',
      'connection': 'keep-alive',
      'Authorization': 'Bearer ' + globals.jwtToken,
    },
  );

  print("jwt : " + globals.jwtToken);
  print(response.body);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return ProfileModel.fromJson(data);
  } else {
    throw Exception('Failed to load data from API');
  }
}
