import 'dart:convert';
import 'package:flutter/material.dart';
import '/globals.dart' as globals;
import 'package:http/http.dart' as http;

class LikeButtonScreen extends StatefulWidget {
  final int userId;
  final int restaurantId;
  const LikeButtonScreen(
      {required this.userId, required this.restaurantId, super.key});

  @override
  State<LikeButtonScreen> createState() => _LikeButtonScreenState();
}

class _LikeButtonScreenState extends State<LikeButtonScreen> {
  bool isFavorite = false;
  int? favoriteId;

  @override
  void initState() {
    super.initState();
    checkFavoriteStatus(widget.userId, widget.restaurantId);
  }

  Future<void> checkFavoriteStatus(int userId, int restaurantId) async {
    final response = await http.get(
      Uri.parse(
          'http://10.0.2.2:8000/api/favorites/checkFavorites/$userId/$restaurantId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '*/*',
        'connection': 'keep-alive',
        'Authorization': 'Bearer ' + globals.jwtToken,
      },
    );

    print(response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final bool status = data['status'] == 1;
      final List<dynamic> favorites = data['favorites'];

      setState(() {
        isFavorite = status && favorites.isNotEmpty;
        favoriteId = isFavorite ? favorites[0]['id'] : null;
      });
    } else {
      throw Exception(
          'Failed to load favorite status. Status code: ${response.statusCode}');
    }
  }

  Future<void> insertFavorite() async {
    final body = {
      'restaurant_id': widget.restaurantId.toString(),
      'favorite_by': widget.userId.toString(),
    };

    final response = await http.post(
      Uri.parse("http://10.0.2.2:8000/api/favorites/insert"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': "*/*",
        'connection': 'keep-alive',
        'Authorization': 'Bearer ' + globals.jwtToken,
      },
      body: jsonEncode(body),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        isFavorite = true;
        favoriteId = data['id'];
      });
    } else {
      throw Exception(
          'Failed to insert favorite. Status code: ${response.statusCode}');
    }
  }

  Future<void> deleteFavorite() async {
    if (favoriteId == null) return;

    final response = await http.delete(
      Uri.parse('http://10.0.2.2:8000/api/favorites/delete/$favoriteId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '*/*',
        'connection': 'keep-alive',
        'Authorization': 'Bearer ' + globals.jwtToken,
      },
      body: json.encode({
        'id': favoriteId,
      }),
    );
    if (response.statusCode == 200) {
      setState(() {
        isFavorite = false;
        favoriteId = null;
      });
    } else {
      throw Exception(
          'Failed to delete favorite. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Example'),
      ),
      body: Center(
        child: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.grey,
          ),
          onPressed: () {
            if (isFavorite) {
              deleteFavorite();
            } else {
              insertFavorite();
            }
          },
          iconSize: 50.0,
        ),
      ),
    );
  }
}
