import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:fmr_project/api/favorite_api.dart';
import 'package:fmr_project/api/restaurantById_api.dart';
import 'package:fmr_project/color/colors.dart';
import 'package:fmr_project/dialog/addReportDialog.dart';
import 'package:fmr_project/dialog/addReviewDialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:quickalert/quickalert.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '/globals.dart' as globals;
import 'package:http/http.dart' as http;

class DetailRestaurantScreen extends StatefulWidget {
  final int restaurantId;
  final int? userId;

  DetailRestaurantScreen({
    required this.restaurantId,
    required this.userId,
    Key? key,
  }) : super(key: key);

  @override
  State<DetailRestaurantScreen> createState() => _DetailRestaurantScreenState();
}

class _DetailRestaurantScreenState extends State<DetailRestaurantScreen> {
  bool isFavorite = false;
  late Future<RestaurantById> futureRestaurants;

  @override
  void initState() {
    super.initState();
    futureRestaurants = getRestaurantById(widget.restaurantId);
  }

  Future<FavoritesModel> insertFavorite(int userId, int restaurantId) async {
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
      return FavoritesModel.fromJson(data);
    } else {
      throw Exception(
          'Failed to insert favorite. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<RestaurantById>(
        future: futureRestaurants,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final restaurantInfo = snapshot.data!;
            final List<String> imageUrls =
                restaurantInfo.imagePaths.map((path) {
              return 'http://10.0.2.2:8000/api/public/$path';
            }).toList();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                          ),
                          child: ClipRRect(
                            child: AnotherCarousel(
                              images: imageUrls.map((url) {
                                return CachedNetworkImage(
                                  imageUrl: url,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 60),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                child: Center(
                                  child: Icon(
                                    EneftyIcons.arrow_left_bold,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => ReportDialogPage(
                                          widget.userId ?? 0,
                                          widget.restaurantId),
                                    );
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                    child: Center(
                                      child: LikeButton(
                                        isLiked: isFavorite,
                                        onTap: (bool isLiked) async {
                                          if (widget.userId == null ||
                                              widget.userId == 0) {
                                            QuickAlert.show(
                                              context: context,
                                              type: QuickAlertType.warning,
                                              text:
                                                  'กรุณาเข้าสู่ระบบเพื่อใช้ฟังก์ชันนี้',
                                              confirmBtnText: 'ตกลง',
                                              confirmBtnColor: Color.fromARGB(
                                                  255, 0, 113, 219),
                                            );

                                            return Future.value(isLiked);
                                          } else {
                                            try {
                                              final favorite =
                                                  await insertFavorite(
                                                      widget.restaurantId,
                                                      widget.userId!);
                                              setState(() {
                                                isFavorite = !isLiked;
                                              });

                                              return Future.value(!isLiked);
                                            } catch (e) {
                                              QuickAlert.show(
                                                context: context,
                                                type: QuickAlertType.error,
                                                text: 'เกิดข้อผิดพลาด: $e',
                                                confirmBtnText: 'ตกลง',
                                                confirmBtnColor: Colors.red,
                                              );
                                              return Future.value(isLiked);
                                            }
                                          }
                                        },
                                        size: 30,
                                        circleColor: CircleColor(
                                          start: Colors.pink,
                                          end: Colors.red,
                                        ),
                                        bubblesColor: BubblesColor(
                                          dotPrimaryColor: Colors.pink,
                                          dotSecondaryColor: Colors.red,
                                        ),
                                        likeBuilder: (bool isLiked) {
                                          return Icon(
                                            isLiked
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: isLiked
                                                ? Colors.pink
                                                : Colors.grey,
                                            size: 30,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => ReportDialogPage(
                                          widget.userId ?? 0,
                                          widget.restaurantId),
                                    );
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        EneftyIcons.flag_bold,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          restaurantInfo.restaurantName,
                          style: GoogleFonts.prompt(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        restaurantInfo.verified == 2
                            ? Container(
                                width: MediaQuery.of(context).size.width * 0.25,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 0, 80, 145),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.task_alt_outlined,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "Official",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              )
                            : SizedBox(),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(EneftyIcons.location_bold),
                            SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Text(
                                restaurantInfo.address,
                                style: GoogleFonts.prompt(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(EneftyIcons.star_bold,
                                        color: Colors.orange),
                                    SizedBox(width: 5),
                                    Text(
                                      restaurantInfo.averageRating!
                                          .toStringAsFixed(1),
                                      style: GoogleFonts.prompt(
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      '(${restaurantInfo.reviewCount} รีวิว)',
                                      style: GoogleFonts.prompt(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  EneftyIcons.eye_bold,
                                  color: const Color.fromARGB(255, 7, 94, 255),
                                ),
                                Text(" ${restaurantInfo.viewCount} ครั้ง")
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.favorite,
                                  color: const Color.fromARGB(255, 255, 7, 7),
                                ),
                                Text(" ${restaurantInfo.favoritesCount} ครั้ง")
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Divider(),
                        SizedBox(height: 20),
                        _address(restaurantInfo, context),
                        SizedBox(height: 20),
                        _reviews(restaurantInfo, context),
                        SizedBox(height: 60),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Text('No data available'),
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) =>
                  AddReviewDialog(widget.restaurantId, widget.userId ?? 0));
        },
        child: Container(
          height: 45,
          width: MediaQuery.sizeOf(context).width * 0.9,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.primaryColor),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.reviews, size: 18, color: Colors.white),
              SizedBox(
                width: 5,
              ),
              Text(
                "เขียนรีวิว",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          )),
        ),
      ),
    );
  }
}

Widget _address(RestaurantById restaurantInfo, BuildContext context) {
  return Column(
    children: [
      Container(
        width: MediaQuery.sizeOf(context).width * 1.0,
        height: MediaQuery.sizeOf(context).height * 0.15,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border:
                Border.all(color: const Color.fromARGB(221, 216, 216, 216))),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(restaurantInfo.latitude, restaurantInfo.longitude),
              zoom: 15,
            ),
            markers: {
              Marker(
                markerId: MarkerId('1'),
                position:
                    LatLng(restaurantInfo.latitude, restaurantInfo.longitude),
              ),
            },
          ),
        ),
      ),
      SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.145,
                height: MediaQuery.of(context).size.height * 0.067,
                decoration: BoxDecoration(
                  color: Color.fromARGB(75, 250, 198, 42),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Icon(
                    EneftyIcons.call_bold,
                    color: Colors.amber[800],
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "โทร",
                style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                )),
              ),
            ],
          ),
          Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.145,
                height: MediaQuery.of(context).size.height * 0.067,
                decoration: BoxDecoration(
                  color: Color.fromARGB(75, 250, 198, 42),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Icon(
                    Icons.directions,
                    color: Colors.amber[800],
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "ตำแหน่ง",
                style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                )),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

Widget _reviews(RestaurantById restaurantInfo, BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "รีวิว",
              style: GoogleFonts.prompt(
                textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              "(${restaurantInfo.reviewCount}) ดูรีวิวทั้งหมด",
              style: GoogleFonts.prompt(
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 0, 183, 255),
                ),
              ),
            ),
          ],
        ),
      ),
      ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.all(0),
        physics: NeverScrollableScrollPhysics(),
        itemCount: min(2, restaurantInfo.reviews.length),
        itemBuilder: (BuildContext context, index) {
          if (index >= restaurantInfo.reviews.length) {
            return SizedBox.shrink();
          }
          final reviews = restaurantInfo.reviews[index];
          final List<String> imageUrlsReview = reviews.imagePathsReview != null
              ? reviews.imagePathsReview!.map((path) {
                  return 'http://10.0.2.2:8000/api/public/$path';
                }).toList()
              : [];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Container(
              width: MediaQuery.of(context).size.width * 1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color.fromARGB(255, 255, 255, 255),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(68, 172, 172, 172),
                    offset: Offset(0, 0),
                    blurRadius: 20,
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/img/icons/user.png",
                              scale: 10,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Text(
                                    reviews.name,
                                    style: GoogleFonts.prompt(
                                      textStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  reviews.created_at,
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          child: Row(
                            children: [
                              Icon(
                                EneftyIcons.star_bold,
                                color: Colors.amber,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "(${reviews.rating.toStringAsFixed(1)})",
                                style: GoogleFonts.prompt(
                                  textStyle: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Divider(
                      color: Colors.grey,
                    ),
                    reviews.title.toString().isEmpty
                        ? SizedBox()
                        : Text(
                            reviews.title.toString(),
                            style: GoogleFonts.prompt(
                              textStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      child: Text(
                        reviews.content.toString(),
                        style: GoogleFonts.prompt(
                          textStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    imageUrlsReview.isEmpty
                        ? SizedBox()
                        : SizedBox(
                            height: MediaQuery.of(context).size.height * 0.15,
                            child: ListView.builder(
                              padding: EdgeInsets.all(0),
                              scrollDirection: Axis.horizontal,
                              itemCount: imageUrlsReview.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: CachedNetworkImage(
                                      imageUrl: imageUrlsReview[index],
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ],
  );
}
