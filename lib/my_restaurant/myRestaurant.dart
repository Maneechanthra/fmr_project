import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fmr_project/add_new/add_verify_new.dart';
import 'package:fmr_project/api/myRestaurant_api.dart';
import 'package:fmr_project/detail_restaurant/detail_restaurant_new.dart';
import 'package:fmr_project/update/update_restaurant_new.dart';
import 'package:google_fonts/google_fonts.dart';

class MyRestaurantScreen extends StatefulWidget {
  final int uesrId;
  const MyRestaurantScreen({required this.uesrId, Key? key}) : super(key: key);

  @override
  State<MyRestaurantScreen> createState() => _MyRestaurantScreenState();
}

class _MyRestaurantScreenState extends State<MyRestaurantScreen> {
  late Future<List<MyRestaurantModel>> futureMyRestaurant;

  @override
  void initState() {
    futureMyRestaurant = fetchMyRestaurants(widget.uesrId);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ร้านอาหารของฉัน",
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<MyRestaurantModel>>(
        future: futureMyRestaurant,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final List<MyRestaurantModel>? restaurants = snapshot.data;
            if (restaurants == null || restaurants.isEmpty) {
              return Center(
                child: Text('No restaurants found.'),
              );
            } else {
              return ListView.builder(
                itemCount: restaurants.length,
                itemBuilder: (context, index) {
                  final MyRestaurantModel restaurant = restaurants[index];
                  final imageUrls =
                      'http://10.0.2.2:8000/api/public/${restaurant.imagePath}';
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailRestaurantScreen(
                                  restaurantId: restaurant.id,
                                  userId: widget.uesrId)));
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0, 2),
                                blurRadius: 10,
                              )
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12)),
                              child: Image.network(
                                imageUrls,
                                width: double.maxFinite,
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 1,
                                    child: Text(
                                      restaurant.restaurantName,
                                      style: GoogleFonts.prompt(
                                          textStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      )),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        EneftyIcons.location_bold,
                                        size: 16,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: Text(
                                          restaurant.address,
                                          style: GoogleFonts.prompt(
                                              textStyle: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          )),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            EneftyIcons.status_bold,
                                            size: 16,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                child: restaurant.status == 1
                                                    ? Text(
                                                        "ปกติ",
                                                        style:
                                                            GoogleFonts.prompt(
                                                                textStyle:
                                                                    TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Color.fromARGB(
                                                              255, 34, 204, 0),
                                                        )),
                                                      )
                                                    : Text(
                                                        "ถูกระงับการเข้าถึงข้อมูล",
                                                        style:
                                                            GoogleFonts.prompt(
                                                                textStyle:
                                                                    TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.red,
                                                        )),
                                                      ),
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Row(
                                                children: [
                                                  Icon(EneftyIcons.verify_bold,
                                                      color: restaurant
                                                                  .verified ==
                                                              0
                                                          ? const Color.fromARGB(
                                                              255, 0, 0, 0)
                                                          : restaurant.verified ==
                                                                  1
                                                              ? Colors
                                                                  .amber[600]
                                                              : Colors.blue),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  SizedBox(
                                                      child: restaurant
                                                                  .verified ==
                                                              0
                                                          ? Text(
                                                              "ยังไม่ได้รับการรับรอง",
                                                              style: GoogleFonts
                                                                  .prompt(
                                                                      textStyle:
                                                                          TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        0,
                                                                        0,
                                                                        0),
                                                              )),
                                                            )
                                                          : restaurant.verified ==
                                                                  1
                                                              ? Text(
                                                                  "รอตรวจสอบ",
                                                                  style: GoogleFonts
                                                                      .prompt(
                                                                          textStyle:
                                                                              TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                            .amber[
                                                                        600],
                                                                  )),
                                                                )
                                                              : Text(
                                                                  "รับรองแล้ว",
                                                                  style: GoogleFonts
                                                                      .prompt(
                                                                          textStyle:
                                                                              TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .blue,
                                                                  )),
                                                                )),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            EneftyIcons.star_bold,
                                            size: 16,
                                            color: Colors.amber,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "${restaurant.favoritesCount.toString()} ครั้ง",
                                            style: GoogleFonts.prompt(
                                                textStyle: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            )),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            EneftyIcons.eye_bold,
                                            size: 16,
                                            color: const Color.fromARGB(
                                                255, 7, 143, 255),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "${restaurant.viewCount.toString()} ครั้ง",
                                            style: GoogleFonts.prompt(
                                                textStyle: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            )),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.favorite,
                                            size: 16,
                                            color: Colors.pink,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "${restaurant.favoritesCount.toString()} ครั้ง",
                                            style: GoogleFonts.prompt(
                                                textStyle: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            )),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.flag,
                                            size: 16,
                                            color:
                                                Color.fromARGB(255, 255, 0, 0),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "${restaurant.reportCount.toString()} ครั้ง",
                                            style: GoogleFonts.prompt(
                                                textStyle: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            )),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Divider(),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddVerifyScreen(
                                                    userId: widget.uesrId,
                                                    userName: restaurant.name,
                                                    restaurantName: restaurant
                                                        .restaurantName,
                                                  )));
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "ยืนยันร้านอาหาร",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  UpdatedRestaurantScreen(
                                                    userId: widget.uesrId,
                                                    selectedCategories: [],
                                                  )));
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.26,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04,
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 255, 153, 0),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "แก้ไข",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.26,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04,
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 255, 0, 0),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "ลบ",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
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
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
