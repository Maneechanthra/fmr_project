import 'dart:convert';
import 'package:http/http.dart' as http;
import '/globals.dart' as globals;

class ChechkFavorite {
  final int status;
  final List<Favorite> favorites;

  ChechkFavorite({
    required this.status,
    required this.favorites,
  });

  factory ChechkFavorite.fromJson(Map<String, dynamic> json) => ChechkFavorite(
        status: json["status"],
        favorites: List<Favorite>.from(
            json["favorites"].map((x) => Favorite.fromJson(x))),
      );
}

class Favorite {
  final int id;
  final int favoriteBy;
  final int restaurantId;

  Favorite({
    required this.id,
    required this.favoriteBy,
    required this.restaurantId,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
        id: json["id"],
        favoriteBy: json["favorite_by"],
        restaurantId: json["restaurant_id"],
      );
}

Future<ChechkFavorite> fetchCheckFavorite(int userId, int restaurantId) async {
  final response = await http.get(
    Uri.parse(
        'https://www.smt-online.com/api/favorites/checkFavorites/$userId/$restaurantId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': '*/*',
      'connection': 'keep-alive',
    },
  );

  print(response.body);

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = json.decode(response.body);
    return ChechkFavorite.fromJson(jsonData);
  } else {
    throw Exception('Failed to load data from API');
  }
}
