import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fmr_project/api/getRestaurant_map_api.dart';
import 'package:fmr_project/detail_restaurant/detail_restaurant_new.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lot;

import 'package:slider_controller/slider_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class MapsPage extends StatefulWidget {
  final int? userId;
  const MapsPage(this.userId, {super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late Future<GetResturantByMap?> futureGetRestaurantByMap;

  Completer<GoogleMapController> _controller = Completer();
  late Set<Marker> _markers = {};
  Marker? selectedMarker;
  bool _isLoading = false;
  Circle? selectedCircle;
  double circleRadius = 4;
  late SliderController sliderController;
  bool _isMarkerSelected = false;

  Timer? myTimer;

  @override
  void initState() {
    super.initState();
    _loadUserLocation();
    futureGetRestaurantByMap = fetchRestaurantMap();
    print("userId in map pae : " + widget.userId.toString());
  }

  @override
  void dispose() {
    super.dispose();
    _controller.future.then((controller) => controller.dispose());
  }

  Future<void> _loadUserLocation() async {
    try {
      Position userPosition = await getUserCurrentLocation();
      _updateMap(userPosition.latitude, userPosition.longitude);
    } catch (e) {
      print("Error fetching user location: $e");
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

  void _updateMap(double latitude, double longitude) {
    _controller.future.then((GoogleMapController controller) {
      if (mounted) {
        setState(() {
          _isLoading = true;
          _markers.removeWhere(
              (Marker marker) => marker.markerId.value == "userLocation");

          selectedMarker = Marker(
            markerId: MarkerId("userLocation"),
            position: LatLng(latitude, longitude),
            infoWindow: InfoWindow(title: "ตำแหน่งปัจจุบัน"),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          );

          CameraPosition cameraPosition = CameraPosition(
            zoom: 13,
            target: LatLng(latitude, longitude),
          );
          controller
              .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

          double circleRadiusKm = circleRadius * 1000;
          selectedCircle = Circle(
            circleId: CircleId("selectedCircle"),
            center: LatLng(latitude, longitude),
            radius: circleRadiusKm,
            fillColor: Colors.blue.withOpacity(0.3),
            strokeColor: Colors.blue,
            strokeWidth: 2,
          );

          _fetchRestaurantsInCircle(
              controller, LatLng(latitude, longitude), circleRadius);
        });
      }
    });
  }

  // void _updateMap(double latitude, double longitude) {
  //   _controller.future.then((GoogleMapController controller) {
  //     if (mounted) {
  //       setState(() {
  //         _isLoading = true;
  //         selectedMarker = Marker(
  //           markerId: MarkerId("userLocation"),
  //           position: LatLng(latitude, longitude),
  //           infoWindow: InfoWindow(title: "ตำแหน่งปัจจุบัน"),
  //           icon:
  //               BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  //         );

  //         CameraPosition cameraPosition = CameraPosition(
  //           zoom: 13,
  //           target: LatLng(latitude, longitude),
  //         );
  //         controller
  //             .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

  //         double circleRadiusKm = circleRadius * 1000;
  //         selectedCircle = Circle(
  //           circleId: CircleId("selectedCircle"),
  //           center: LatLng(latitude, longitude),
  //           radius: circleRadiusKm,
  //           fillColor: Colors.blue.withOpacity(0.3),
  //           strokeColor: Colors.blue,
  //           strokeWidth: 2,
  //         );

  //         _fetchRestaurantsInCircle(
  //             controller, LatLng(latitude, longitude), circleRadius);
  //       });
  //     }
  //   });
  // }

  Future<void> _fetchRestaurantsInCircle(GoogleMapController controller,
      LatLng userLocation, double circleRadius) async {
    try {
      GetResturantByMap? restaurantMap = await fetchRestaurantMap();
      if (restaurantMap != null) {
        List<Restaurant> allRestaurants = restaurantMap.restaurants;
        List<Restaurant> restaurantsInCircle = getRestaurantsInCircle(
          allRestaurants,
          userLocation,
          circleRadius,
        );

        List<Marker> restaurantMarkers = restaurantsInCircle.map((restaurant) {
          final String imageUrl =
              'https://www.smt-online.com/api/public/${restaurant.imagePaths}';
          return Marker(
            markerId: MarkerId(restaurant.restaurantName),
            position: LatLng(restaurant.latitude, restaurant.longitude),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 120.0),
                      child: Dialog(
                        child: Container(
                          height: 350,
                          width: MediaQuery.of(context).size.width * 1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                // top: MediaQuery.of(context).size.width * 0.002,
                                left: MediaQuery.of(context).size.width * 0.72,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(
                                    Icons.close,
                                    size: 30,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ListView.builder(
                                        padding: EdgeInsets.all(0),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: restaurant.imagePaths.length,
                                        itemBuilder: (BuildContext context,
                                            int imageIndex) {
                                          final String imageUrl =
                                              'https://www.smt-online.com/api/public/${restaurant.imagePaths[imageIndex]}';
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10.0, top: 10),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: Image.network(
                                                imageUrl,
                                                fit: BoxFit.cover,
                                                width: 200,
                                                height: 20,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 160,
                                          child: Text(
                                            restaurant.restaurantName,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            if (restaurant.verified == 2)
                                              Icon(
                                                Icons.verified_rounded,
                                                color: Colors.blue,
                                              ),
                                            SizedBox(width: 5),
                                            // Text(
                                            //   "เปิดอยู่",
                                            //   style: TextStyle(
                                            //     fontSize: 16,
                                            //     fontWeight: FontWeight.w500,
                                            //     color: Colors.green,
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 7),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 3),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.red,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  restaurant.averageRating!
                                                      .toStringAsFixed(1),
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.star,
                                                  size: 14,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "${restaurant.reviewCount} รีวิว",
                                            style: TextStyle(
                                              color: const Color.fromARGB(
                                                  137, 77, 77, 77),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Text(
                                        "ประเภทร้าน: ${restaurant.restaurantCategory.join(", ")}",
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(137, 77, 77, 77),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                    Divider(),
                                    GestureDetector(
                                      onTap: () {
                                        _openGoogleMapsForDirections(
                                          restaurant.latitude,
                                          restaurant.longitude,
                                        );
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                1.0,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.directions,
                                                color: Colors.white,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "นำทาง",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
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
                },
              );
            },
          );
        }).toList();

        _markers = Set<Marker>.of(restaurantMarkers);
        if (selectedMarker != null) {
          _markers.add(selectedMarker!);
        }
      } else {
        print("Failed to fetch restaurant map.");
      }
    } catch (e) {
      print("Error fetching restaurant data: $e");
    }

    setState(() {
      _isLoading = false;
      _isMarkerSelected = false;
    });
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0;
    double dLat = toRadians(lat2 - lat1);
    double dLon = toRadians(lon2 - lon1);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(toRadians(lat1)) *
            cos(toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = R * c;

    return distance;
  }

  double toRadians(double degree) {
    return degree * (pi / 180);
  }

  List<Restaurant> getRestaurantsInCircle(List<Restaurant> allRestaurants,
      LatLng userLocation, double circleRadius) {
    List<Restaurant> restaurantsInCircle = [];

    for (Restaurant restaurant in allRestaurants) {
      double distance = calculateDistance(userLocation.latitude,
          userLocation.longitude, restaurant.latitude, restaurant.longitude);

      if (distance <= circleRadius) {
        restaurantsInCircle.add(restaurant);
      }
    }

    return restaurantsInCircle;
  }

  void _openGoogleMapsForDirections(
      double destinationLatitude, double destinationLongitude) async {
    final url =
        'https://www.google.com/maps/dir/?api=1&destination=$destinationLatitude,$destinationLongitude';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String? selectedRestaurantType = 'ทุกประเภท';
  Widget _buildRestaurantList() {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      maxChildSize: 0.7,
      builder: (BuildContext context, ScrollController scrollController) {
        return FutureBuilder<GetResturantByMap?>(
          future: futureGetRestaurantByMap,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: lot.Lottie.network(
                      'https://lottie.host/6dbef5a4-c62a-4005-9782-a9e3026d4c19/G8MECWroXw.json'));
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.data == null) {
              return Center(child: Text("No restaurants found"));
            } else {
              final restaurants =
                  snapshot.data!.restaurants.where((restaurant) {
                // กรองร้านอาหารเฉพาะที่อยู่ในวงกลม
                return _markers.any((marker) =>
                    marker.markerId.value == restaurant.restaurantName);
              }).toList();

              final category = snapshot.data!.categories;
              final uniqueCategories =
                  category.map((cat) => cat.title).toSet().toList();

              return Column(
                children: [
                  Container(
                    height: 95,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(15.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 10.0,
                          spreadRadius: 2.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Text(
                            "ค้นหาประเภทร้านอาหาร: ",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          DropdownButtonFormField<String>(
                            value: selectedRestaurantType,
                            items: uniqueCategories.map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                selectedRestaurantType =
                                    value ?? uniqueCategories.first;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white),
                      child: ListView.builder(
                        padding: EdgeInsets.all(0),
                        controller: scrollController,
                        itemCount: restaurants.length,
                        itemBuilder: (BuildContext context, int index) {
                          final restaurant = restaurants[index];
                          if (selectedRestaurantType == "ทุกประเภท" ||
                              restaurant.restaurantCategory
                                  .contains(selectedRestaurantType)) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailRestaurantScreen(
                                      restaurantId: restaurant.id,
                                      userId: widget.userId,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 200,
                                height: 250,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount:
                                              restaurant.imagePaths.length,
                                          itemBuilder: (BuildContext context,
                                              int imageIndex) {
                                            final path = restaurant
                                                .imagePaths[imageIndex];
                                            final imageUrls =
                                                'https://www.smt-online.com/api/public/$path';
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10.0, top: 10),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.network(
                                                  imageUrls,
                                                  fit: BoxFit.cover,
                                                  width: 150,
                                                  height: 150,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                restaurant.restaurantName,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(width: 5),
                                              restaurant.verified == 2
                                                  ? Icon(Icons.verified_rounded,
                                                      color: Colors.blue)
                                                  : SizedBox(),
                                            ],
                                          ),
                                          Text(
                                            "เปิด",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.green),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      SizedBox(height: 7),
                                      Row(
                                        children: [
                                          Container(
                                            width: 50,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Colors.red),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "${restaurant.averageRating!.toStringAsFixed(2)}",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white),
                                                ),
                                                Icon(Icons.star,
                                                    size: 14,
                                                    color: Colors.white),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            restaurant.reviewCount.toString() +
                                                " รีวิว",
                                            style: TextStyle(
                                                color: const Color.fromARGB(
                                                    137, 77, 77, 77)),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      SizedBox(
                                        width: 281,
                                        child: Text(
                                          "ประเภทร้านอาหาร : " +
                                              restaurant.restaurantCategory
                                                  .join("/"),
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Color.fromARGB(
                                                255, 168, 168, 168),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      Divider(),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // GoogleMap(
          //   onMapCreated: (GoogleMapController controller) {
          //     _controller.complete(controller);
          //     if (_isLoading) {
          //       Center(
          //         child: lot.Lottie.network(
          //             'https://lottie.host/8b0df7cd-4871-46be-8ccb-e5d7a3fa0e95/EXzvBIct6n.json'),
          //       );
          //     }
          //   },
          //   onTap: (LatLng latLng) {
          //     print("Selected Lat and Long: $latLng");
          //     setState(() {
          //       selectedMarker = Marker(
          //         markerId: const MarkerId("selectedMarker"),
          //         position: latLng,
          //         icon: BitmapDescriptor.defaultMarkerWithHue(
          //           BitmapDescriptor.hueRed,
          //         ),
          //       );

          //       double circleRadiusKm = circleRadius * 1000;
          //       selectedCircle = Circle(
          //         circleId: const CircleId("selectedCircle"),
          //         center: latLng,
          //         radius: circleRadiusKm,
          //         fillColor: Colors.blue.withOpacity(0.3),
          //         strokeColor: Colors.blue,
          //         strokeWidth: 2,
          //       );
          //     });
          //   },
          //   initialCameraPosition: const CameraPosition(
          //     target: LatLng(17.27274239, 104.1265007),
          //     zoom: 15,
          //   ),
          //   markers: selectedMarker != null
          //       ? Set<Marker>.of(_markers.union(Set.of([selectedMarker!])))
          //       : _markers,
          //   circles: selectedCircle != null
          //       ? Set<Circle>.of([selectedCircle!])
          //       : Set<Circle>(),
          // ),
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              if (_isLoading) {
                Center(
                  child: lot.Lottie.network(
                      'https://lottie.host/8b0df7cd-4871-46be-8ccb-e5d7a3fa0e95/EXzvBIct6n.json'),
                );
              }
            },
            onTap: (LatLng latLng) {
              print("Selected Lat and Long: $latLng");
              setState(() {
                // ลบ Marker ปัจจุบัน
                _markers.removeWhere(
                    (marker) => marker.markerId.value == "userLocation");

                // เพิ่ม Marker ใหม่ที่ตำแหน่งที่ระบุบนแผนที่
                selectedMarker = Marker(
                  markerId: const MarkerId("selectedMarker"),
                  position: latLng,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed,
                  ),
                );

                double circleRadiusKm = circleRadius * 1000;
                selectedCircle = Circle(
                  circleId: const CircleId("selectedCircle"),
                  center: latLng,
                  radius: circleRadiusKm,
                  fillColor: Colors.blue.withOpacity(0.3),
                  strokeColor: Colors.blue,
                  strokeWidth: 2,
                );

                _updateMap(latLng.latitude, latLng.longitude);
              });
            },
            initialCameraPosition: const CameraPosition(
              target: LatLng(17.27274239, 104.1265007),
              zoom: 15,
            ),
            markers: selectedMarker != null
                ? Set<Marker>.of(_markers.union(Set.of([selectedMarker!])))
                : _markers,
            circles: selectedCircle != null
                ? Set<Circle>.of([selectedCircle!])
                : Set<Circle>(),
          ),

          _buildRestaurantList(),
          Positioned(
            top: 30.0,
            left: 16.0,
            right: 16.0,
            child: Container(
              width: 380,
              height: 60,
              margin: const EdgeInsets.only(top: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color.fromARGB(255, 255, 255, 255),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 190, 190, 190),
                    blurRadius: 5.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'ระบุรัศมีที่ต้องการค้นหา',
                          suffix: Text('กิโลเมตร'),
                        ),
                        onChanged: (value) {
                          setState(() {
                            circleRadius =
                                value.isEmpty ? 4 : double.parse(value);
                          });
                        },
                        onSubmitted: (value) {
                          _updateMap(
                            selectedMarker!.position.latitude,
                            selectedMarker!.position.longitude,
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 30,
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
          Positioned(
            right: MediaQuery.of(context).size.width * 0.05,
            top: MediaQuery.of(context).size.height * 0.175,
            left: MediaQuery.of(context).size.width * 0.78,
            child: InkWell(
              onTap: () {
                getUserCurrentLocation().then((value) {
                  print("ตำแหน่งปัจจุบัน");
                  print(value.latitude.toString() +
                      " " +
                      value.longitude.toString());
                  _updateMap(value.latitude, value.longitude);
                });
              },
              child: Container(
                width: 20,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(2, 2), // กำหนด offset ให้มีเงา
                      color: const Color.fromARGB(255, 202, 202, 202),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.location_pin,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
