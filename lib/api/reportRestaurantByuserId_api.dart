import 'dart:convert';
import 'package:http/http.dart' as http;
import '/globals.dart' as globals;

import 'dart:convert';

class ReportRestaurantByuserId {
  final String title;
  final String descriptions;
  final int reportCount;
  final int id;
  final String restaurantName;

  ReportRestaurantByuserId({
    required this.title,
    required this.descriptions,
    required this.reportCount,
    required this.id,
    required this.restaurantName,
  });

  factory ReportRestaurantByuserId.fromJson(Map<String, dynamic> json) {
    return ReportRestaurantByuserId(
      title: json["title"],
      descriptions: json["descriptions"],
      reportCount: json["report_count"],
      id: json["id"],
      restaurantName: json["restaurant_name"],
    );
  }
}

class ReportRestaurantByuserIdList {
  final List<ReportRestaurantByuserId> reports;

  ReportRestaurantByuserIdList({
    required this.reports,
  });

  factory ReportRestaurantByuserIdList.fromJson(List<dynamic> jsonList) {
    List<ReportRestaurantByuserId> reports = jsonList
        .map((item) => ReportRestaurantByuserId.fromJson(item))
        .toList();
    return ReportRestaurantByuserIdList(reports: reports);
  }
}

Future<ReportRestaurantByuserIdList> fetchReportRestaurantByuserId(
    int? userId) async {
  final response = await http.get(
    Uri.parse('http://10.0.2.2:8000/api/reports/$userId'),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': '*/*',
      'connection': 'keep-alive',
      'Authorization': 'Bearer ' + globals.jwtToken,
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body); // ตีความ response
    if (data is List) {
      return ReportRestaurantByuserIdList.fromJson(data);
    } else {
      throw Exception('Expected a list but got something else');
    }
  } else {
    throw Exception('Failed to load data from API');
  }
}
