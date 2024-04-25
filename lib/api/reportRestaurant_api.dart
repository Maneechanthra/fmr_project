import 'dart:convert';
import 'package:http/http.dart' as http;
import '/globals.dart' as globals;
import 'dart:convert';

class ReportRestaurant {
  final String restaurant_id;
  final String title;
  final String descriptions;
  final String report_by;
  // final String updatedAt;
  // final String createdAt;
  // final int id;

  ReportRestaurant({
    required this.restaurant_id,
    required this.title,
    required this.descriptions,
    required this.report_by,
    // required this.updatedAt,
    // required this.createdAt,
    // required this.id,
  });

  factory ReportRestaurant.fromJson(Map<String, dynamic> json) =>
      ReportRestaurant(
        restaurant_id: json["restaurant_id"],
        title: json["title"],
        descriptions: json["descriptions"],
        report_by: json["report_by"],
        // updatedAt: json["updated_at"],
        // createdAt: json["created_at"],
        // id: json["id"],
      );
}

// Future<ReportRestaurant> fetchReportRestaurant() async {
//   final resposne = await 
// }