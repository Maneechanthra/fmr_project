import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fmr_project/api/recommentded_api.dart';
import 'package:fmr_project/detail_restaurant/detail_restaurant.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
  bool isImageLoaded = false;
  late Timer timer;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      futureRestaurants = fetchSortedRestaurants();
      timer = Timer.periodic(Duration(seconds: 60), (Timer t) {
        if (mounted) {
          setState(() {});
        }
      });
    }

    // futureRestaurants =
    //     Future.delayed(Duration(seconds: 3), () => fetchSortedRestaurants())
    //         .then((value) {
    //   return value;
    // });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
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

  double _calculateScore(
    double? distance,
    int? reviewCount,
    dynamic averageRating,
    int? favoritesCount,
  ) {
    double score = 0;

    if (distance == null) {
      return score;
    }

    if (distance != null) {
      score += (100 / distance) * 0.25;
    }

    if (reviewCount != null) {
      score += reviewCount * 0.25;
    }

    if (averageRating is double) {
      score += averageRating * 0.25;
    } else if (averageRating is int) {
      score += averageRating.toDouble() * 0.25;
    }

    if (favoritesCount != null) {
      score += favoritesCount * 0.25;
    }

    return score;
  }

  Future<List<RecommendedModel>> fetchSortedRestaurants() async {
    var restaurantInfo = await fetchRestaurants();

    restaurantInfo = restaurantInfo.map((restaurant) {
      var distance = _calculateDistance(
        widget.latitude,
        widget.longitude,
        restaurant.latitude,
        restaurant.longitude,
      );
      restaurant.distance = distance;

      var score = _calculateScore(
        distance,
        restaurant.reviewCount ?? 0,
        restaurant.averageRating ?? 0,
        restaurant.favoritesCount ?? 0,
      );
      restaurant.score = score;

      return restaurant;
    }).toList();

    restaurantInfo.sort((a, b) => b.score!.compareTo(a.score!));

    return restaurantInfo;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RecommendedModel>>(
      future: futureRestaurants,
      builder: (BuildContext context,
          AsyncSnapshot<List<RecommendedModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              width: 200,
              child: Lottie.network(
                  'https://lottie.host/e0a50d0a-95f6-42a7-b894-a6597f54a034/ryQS5H9cQO.json'),
            ),
          );
        } else if (snapshot.hasData) {
          var restaurant_info = snapshot.data!;
          var topRestaurants = restaurant_info.take(4).toList();
          // restaurant_info.forEach((restaurant) {
          //   print("Restaurant Name: ${restaurant.restaurantName}");
          //   print("Distance: ${restaurant.distance?.toStringAsFixed(2)} km");
          //   print("Review Count: ${restaurant.reviewCount}");
          //   print("Average Rating: ${restaurant.averageRating}");
          //   print("Favorites Count: ${restaurant.favoritesCount}");
          //   print("Total Score: ${restaurant.score}");
          //   print("----------------------------");
          // });

          return Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 3,
              shrinkWrap: true,
              childAspectRatio: 1,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(topRestaurants.length = 4, (index) {
                // RecommendedModel item = restaurant_info[index];
                var item = topRestaurants[index];
                // final category =
                final String imagePath = restaurant_info[index].imagePath;
                final String imageUrl =
                    'http://10.0.2.2:8000/api/public/$imagePath';

                Future.delayed(Duration(seconds: 0), () {
                  setState(() {
                    isImageLoaded = true;
                  });
                });
                return Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
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
                                  child: isImageLoaded
                                      ? CachedNetworkImage(
                                          imageUrl: imageUrl,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Center(
                                              child:
                                                  CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        )
                                      : SizedBox(),
                                ),
                                Positioned(
                                  top: 8,
                                  left:
                                      MediaQuery.of(context).size.width * 0.325,
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
                                                  "${item.averageRating!.toStringAsFixed(2)}",
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 145,
                                        child: Text(item.restaurantName,
                                            style: GoogleFonts.prompt(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1),
                                      ),
                                      if (item.verified == 2)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Icon(
                                            Icons.verified_rounded,
                                            color: Colors.blue,
                                          ),
                                        ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 0),
                                    child: SizedBox(
                                      width: 281,
                                      child: Text(
                                        item.restaurantCategory.join("/"),
                                        style: GoogleFonts.prompt(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Color.fromARGB(
                                              255, 168, 168, 168),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
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
                                          style: GoogleFonts.prompt(
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
                                          style: GoogleFonts.prompt(
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
