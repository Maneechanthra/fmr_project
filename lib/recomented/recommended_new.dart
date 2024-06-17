import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fmr_project/api/recommentded_api.dart';
import 'package:fmr_project/detail_restaurant/detail_restaurant_new.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class RecommendedScreen extends StatefulWidget {
  final int? userId;

  const RecommendedScreen({required this.userId, super.key});

  @override
  State<RecommendedScreen> createState() => _RecommendedScreenState();
}

class _RecommendedScreenState extends State<RecommendedScreen> {
  late Future<List<RecommendedModel>> futureRestaurants;
  bool isImageLoaded = false;
  late Timer timer;
  double? userLatitude;
  double? userLongitude;
  bool isLoadingLocation = true;

  @override
  void initState() {
    super.initState();
    _loadUserLocation();
    // timer = Timer.periodic(Duration(seconds: 60), (Timer t) {
    //   if (mounted) {
    //     setState(() {});
    //   }
    // });
  }

  @override
  void dispose() {
    // timer.cancel();
    super.dispose();
  }

  Future<void> _loadUserLocation() async {
    try {
      Position userPosition = await getUserCurrentLocation();
      setState(() {
        userLatitude = userPosition.latitude;
        userLongitude = userPosition.longitude;
        isLoadingLocation = false;
        futureRestaurants = fetchSortedRestaurants();
      });
    } catch (e) {
      print("Error fetching user location: $e");
      setState(() {
        isLoadingLocation = false;
      });
    }
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print("error " + error.toString());
    });
    return await Geolocator.getCurrentPosition();
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

    if (userLatitude == null || userLongitude == null) {
      return [];
    }

    restaurantInfo = restaurantInfo.map((restaurant) {
      var distance = _calculateDistance(
        userLatitude!,
        userLongitude!,
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

  Widget _recommended(Future<List<RecommendedModel>> futureRestaurants) {
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
          var restaurantInfo = snapshot.data!;
          var topRestaurants = restaurantInfo.take(4).toList();

          return Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
            child: GridView.count(
              padding: EdgeInsets.all(0),
              crossAxisCount: 2,
              mainAxisSpacing: 3,
              shrinkWrap: true,
              childAspectRatio: 1,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(topRestaurants.length, (index) {
                var item = topRestaurants[index];
                final String imagePath = restaurantInfo[index].imagePath;
                final String imageUrl =
                    'https://www.smt-online.com/api/public/$imagePath';

                Future.delayed(Duration(seconds: 0), () {
                  setState(() {
                    isImageLoaded = true;
                  });
                });
                return Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailRestaurantScreen(
                            restaurantId: item.id,
                            userId: null,
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
                                          "${item.reviewCount} รีวิว",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: isLoadingLocation
            ? Center(
                child: SizedBox(
                  width: 300,
                  child: Lottie.network(
                      'https://lottie.host/e5abe087-7811-44fa-a384-e5df4243c00f/mK3LQGpd4P.json'),
                ),
              )
            : Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(54, 0, 0, 0),
                            offset: Offset(0, 5),
                            blurRadius: 7,
                          )
                        ]),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      child: Image.asset(
                        "assets/img/bg.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: InkWell(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             SearchHistoryPage(widget.userId ?? 0)));
                      },
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(255, 240, 239, 239),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "ค้นหาร้านอาหาร",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 107, 107, 107),
                                  fontSize: 17,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Icon(
                                Icons.search,
                                color: Color.fromARGB(255, 107, 107, 107),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.08,
                          child:
                              Image.asset("assets/img/icons/restaurant_re.png"),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "ร้านแนะนำสำหรับคุณ",
                          style: GoogleFonts.prompt(
                            textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _recommended(futureRestaurants),
                ],
              ),
      ),
    );
  }
}
