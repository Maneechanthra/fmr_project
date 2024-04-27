import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fmr_project/api/recommentded_api.dart';
import 'package:fmr_project/detail_page/detail_restaurant.dart';

import 'package:fmr_project/model/restaurant_info.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_fonts/google_fonts.dart';

class RecomentedPage extends StatefulWidget {
  final int? userId;
  final double latitude;
  final double longitude;

  const RecomentedPage(this.userId, this.latitude, this.longitude, {Key? key})
      : super(key: key);

  @override
  State<RecomentedPage> createState() => _RecomentedPageState();
}

class _RecomentedPageState extends State<RecomentedPage> {
  late Future<List<RecommendedModel>> futureRestaurants;

  @override
  void initState() {
    super.initState();
    futureRestaurants = fetchRestaurants();
    print(widget.latitude.toString());
    print(widget.longitude.toString());
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const R = 6371;
    var dLat = _degToRad(lat2 - lat1);
    var dLon = _degToRad(lon2 - lon1);
    var a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) *
            cos(_degToRad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _degToRad(double degrees) {
    return degrees * (pi / 180);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RecommendedModel>>(
      future: futureRestaurants,
      builder: (BuildContext context,
          AsyncSnapshot<List<RecommendedModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          var restaurant_info = snapshot.data!;
          var userLatitude = widget.latitude;
          var userLongitude = widget.longitude;

          restaurant_info = restaurant_info.map((restaurant) {
            var distance = _calculateDistance(
              userLatitude,
              userLongitude,
              restaurant.latitude,
              restaurant.longitude,
            );

            restaurant.distance = distance;

            return restaurant;
          }).toList();

          restaurant_info.sort((a, b) => a.distance!.compareTo(b.distance!));
          return Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 3,
              shrinkWrap: true,
              childAspectRatio: 0.87,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(snapshot.data!.length = 4, (index) {
                RecommendedModel item = restaurant_info[index];

                final String imageUrl =
                    'http://10.0.2.2:8000/api/public/${restaurant_info[index].image_path}';
                return Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailRestaurantPage_2(
                            item.id,
                            widget.userId,
                          ),
                        ),
                      );
                    },
                    child: SizedBox(
                      height: 300,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(221, 218, 218, 218),
                                offset: Offset(0, 2),
                                blurRadius: 2,
                              )
                            ]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 100,
                                  ),
                                ),
                                Positioned(
                                  top: 5,
                                  left: MediaQuery.of(context).size.width * 0.3,
                                  child: Container(
                                    width: 50,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 4.0, right: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(
                                            Icons.star,
                                            size: 14,
                                            color: Colors.orangeAccent,
                                          ),
                                          item.averageRating != null
                                              ? Text(
                                                  item.averageRating.toString(),
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                )
                                              : Text(
                                                  "0",
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, top: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 130,
                                        child: Text(
                                          item.restaurantName,
                                          style: GoogleFonts.mitr(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      item.verified == 2
                                          ? Icon(
                                              Icons.verified_rounded,
                                              color: Colors.blue,
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                  Text(
                                    item.category_title,
                                    style: GoogleFonts.mitr(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromARGB(255, 168, 168, 168),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, top: 5),
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Color.fromARGB(255, 212, 14, 0)),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(0.8),
                                        child: Text(
                                          "${item.distance?.toStringAsFixed(2)} km",
                                          style: GoogleFonts.mitr(
                                              fontSize: 10,
                                              fontWeight: FontWeight.normal,
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  Container(
                                    width: 50,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Color.fromARGB(162, 14, 12, 9),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(0.8),
                                        child: Text(
                                          item.reviewCount.toString() +
                                              " รีวิว",
                                          style: GoogleFonts.mitr(
                                              fontSize: 10,
                                              fontWeight: FontWeight.normal,
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        } else {
          return Text('No data available');
        }
      },
    );
  }
}
