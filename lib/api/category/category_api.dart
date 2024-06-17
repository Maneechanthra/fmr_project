import 'dart:convert';
import 'package:http/http.dart' as http;

class CategoryModel {
  final int id;
  final String title;
  final String? createdAt;
  final dynamic updatedAt;
  final dynamic deletedAt;

  CategoryModel({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory CategoryModel.fromRawJson(String str) =>
      CategoryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"],
        title: json["title"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
      };
}

Future<List<CategoryModel>> fetchCategory() async {
  final response = await http.get(
    Uri.parse('https://www.smt-online.com/api/categories'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': '*/*',
      'connection': 'keep-alive',
    },
  );

  print(response.statusCode);
  print(response.body);

  if (response.statusCode == 200) {
    try {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => CategoryModel.fromJson(json)).toList();
    } catch (e) {
      print('Error decoding JSON: $e');
      throw Exception('Failed to decode JSON data');
    }
  } else {
    print('HTTP error: ${response.statusCode}');
    throw Exception('Failed to load data from API');
  }
}
