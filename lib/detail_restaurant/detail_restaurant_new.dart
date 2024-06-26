import 'dart:convert';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:fmr_project/api/addRestaurant_api.dart';
import 'package:fmr_project/api/favorite_api.dart';
import 'package:fmr_project/api/favorites/checkFavorite_api.dart';
import 'package:fmr_project/api/restaurantById_api.dart';
import 'package:fmr_project/api/views/view_api.dart';
import 'package:fmr_project/color/colors.dart';
import 'package:fmr_project/detail_page/all_review.dart';
import 'package:fmr_project/dialog/addReportDialog.dart';
import 'package:fmr_project/dialog/addReviewDialog.dart';
import 'package:fmr_project/informations_restaurant/informatins.dart';
import 'package:fmr_project/reviews/resviews.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:lottie/lottie.dart' as lot;
import 'package:quickalert/quickalert.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/safe_area_values.dart';
import 'package:top_snackbar_flutter/tap_bounce_container.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';

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
  late int createdBy;
  bool isUpdating = false;
  bool isFavorite = false;
  int? favoriteId;

  late Future<RestaurantById> futureRestaurants;
  // late Future<ChechkFavorite> futureCheckFavorite;

  @override
  void initState() {
    super.initState();
    futureRestaurants = getRestaurantById(widget.restaurantId);
    // futureCheckFavorite =
    //     fetchCheckFavorite(widget.userId!, widget.restaurantId);
    checkFavoriteStatus(widget.userId!, widget.restaurantId);

    addViews(widget.userId, widget.restaurantId);
  }

  Future<ViewModel> addViews(int? userId, int restaurantId) async {
    final Map<String, String> body = {
      'restaurant_id': widget.restaurantId.toString(),
      'view_by': widget.userId?.toString() ?? '0',
    };

    final response = await http.post(
      Uri.parse("https://www.smt-online.com/api/view/insert"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': "*/*",
        'connection': 'keep-alive',
        'Authorization': 'Bearer ' + globals.jwtToken,
      },
      body: jsonEncode(body),
    );

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return ViewModel.fromJson(data);
    } else {
      print('Response: ${response.body}');
      throw Exception(
          'Failed to log visit. Status code: ${response.statusCode}');
    }
  }

  Future<void> checkFavoriteStatus(int userId, int restaurantId) async {
    final response = await http.get(
      Uri.parse(
          'https://www.smt-online.com/api/favorites/checkFavorites/$userId/$restaurantId'),
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
      Uri.parse("https://www.smt-online.com/api/favorites/insert"),
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
      Uri.parse('https://www.smt-online.com/api/favorites/delete/$favoriteId'),
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
      body: FutureBuilder<RestaurantById>(
        future: futureRestaurants,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: lot.Lottie.network(
                  'https://lottie.host/6dbef5a4-c62a-4005-9782-a9e3026d4c19/G8MECWroXw.json'),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final restaurantInfo = snapshot.data!;
            createdBy = restaurantInfo.createdBy;

            print("created by in futureBuilder : " + createdBy.toString());
            final List<String> imageUrls =
                restaurantInfo.imagePaths.map((path) {
              return 'https://www.smt-online.com/api/public/$path';
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
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Center(
                                    child: IconButton(
                                      icon: Icon(
                                        isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: isFavorite
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                      onPressed: () {
                                        if (widget.userId == null ||
                                            widget.userId == 0) {
                                          AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.warning,
                                            animType: AnimType.topSlide,
                                            titleTextStyle: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            title:
                                                "ไม่สามารถเพิ่มร้านที่ชื่นชอบได้",
                                            desc:
                                                "กรุณาเข้าสู่ระบบเพื่อเข้าใช้งาน",
                                            btnOkColor: Color.fromARGB(
                                                255, 255, 174, 0),
                                            btnOkOnPress: () {},
                                          ).show();
                                        } else {
                                          if (isFavorite) {
                                            deleteFavorite();
                                          } else {
                                            insertFavorite();
                                          }
                                        }
                                      },
                                      iconSize: 30.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                InkWell(
                                  onTap: () {
                                    if (widget.userId ==
                                        restaurantInfo.createdBy) {
                                      AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.warning,
                                              animType: AnimType.topSlide,
                                              titleTextStyle: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                              title:
                                                  "ไม่สามารถรายงานความไม่เหมาะสมได้",
                                              desc:
                                                  "ไม่สามารถรายงานความไม่เหมาะสมได้เนื่องจากคุณเป็นเจ้าของร้าน",
                                              btnOkOnPress: () {})
                                          .show();
                                    } else if (widget.userId == null ||
                                        widget.userId == 0) {
                                      AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.warning,
                                              animType: AnimType.topSlide,
                                              title:
                                                  "ไม่สามารถใช้งานฟังก์ชันนี้ได้",
                                              desc:
                                                  "กรุณาเข้าสู่ระบบเพื่อเข้าใช้ฟังก์ชันนี้!",
                                              btnOkColor: Color.fromARGB(
                                                  255, 255, 174, 0),
                                              btnOkOnPress: () {})
                                          .show();
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) => ReportDialogPage(
                                            widget.userId ?? 0,
                                            widget.restaurantId),
                                      );
                                    }
                                  },

                                  // },
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
                            Icon(
                              EneftyIcons.location_bold,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Text(
                                restaurantInfo.address,
                                style: GoogleFonts.prompt(
                                  fontSize: 14,
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
                                      restaurantInfo.averageRating
                                          .toStringAsFixed(1),
                                      style: GoogleFonts.prompt(
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      '(${restaurantInfo.reviewCount} รีวิว)',
                                      style: GoogleFonts.prompt(
                                        fontSize: 14,
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
                                  color: Color.fromARGB(255, 82, 82, 82),
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
                        _information(restaurantInfo, context),
                        SizedBox(height: 20),
                        _reviews(restaurantInfo, context, widget.userId ?? 0),
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
          print(widget.userId);
          print(createdBy.toString());

          if (widget.userId == createdBy) {
            print(createdBy.toString());
            print("คุณเป็นเจ้าของร้าน");
            AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    animType: AnimType.topSlide,
                    title: "ไม่สามารถเพิ่มรีวิวได้",
                    desc: "ไม่สามารถเพิ่มรีวิวได้เนื่องจากคุณเป็นเจ้าของร้าน",
                    btnOkOnPress: () {})
                .show();
          } else if (widget.userId == null || widget.userId == 0) {
            AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    animType: AnimType.topSlide,
                    title: "ไม่สามารถใช้งานฟังก์ชันนี้ได้",
                    desc: "กรุณาเข้าสู่ระบบเพื่อเข้าใช้ฟังก์ชันนี้!",
                    btnOkColor: Color.fromARGB(255, 255, 174, 0),
                    btnOkOnPress: () {})
                .show();
          } else {
            showDialog(
                context: context,
                builder: (context) =>
                    AddReviewDialog(widget.restaurantId, widget.userId ?? 0));
          }
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

  return Column(
    children: [
      Container(
        width: MediaQuery.sizeOf(context).width * 1.0,
        height: MediaQuery.sizeOf(context).height * 0.2,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border:
                Border.all(color: const Color.fromARGB(221, 216, 216, 216))),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
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
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InfomatinsScreen(
                                restaurantName: restaurantInfo.restaurantName,
                                opening: restaurantInfo.openings,
                                restaurants: [restaurantInfo],
                                category: restaurantInfo.restaurantCategory,
                              )));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.145,
                  height: MediaQuery.of(context).size.height * 0.067,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(55, 250, 198, 42),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                    child: Icon(
                      EneftyIcons.info_circle_bold,
                      color: Colors.amber[800],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "ข้อมูลเพิ่มเติม",
                style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                )),
              ),
            ],
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  _openGoogleMapsForDirections(
                      restaurantInfo.latitude, restaurantInfo.longitude);
                },
                child: Container(
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
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "นำทาง",
                style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                )),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

// =============================== infomations ==================================
Widget _information(RestaurantById restaurantInfo, BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Divider(),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  "โทร: ",
                  style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Text(
                  restaurantInfo.telephone1,
                  style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            Icon(EneftyIcons.call_outline),
          ],
        ),
      ),
      Divider(),
      restaurantInfo.telephone2 == ""
          ? SizedBox()
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "โทร: ",
                            style: GoogleFonts.prompt(
                              textStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Text(
                            restaurantInfo.telephone2!,
                            style: GoogleFonts.prompt(
                              textStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Icon(EneftyIcons.call_outline),
                    ],
                  ),
                ),
                Divider(),
              ],
            ),
    ],
  );
}

// ============================= reviews ====================================
Widget _reviews(
    RestaurantById restaurantInfo, BuildContext context, int userId) {
  initializeDateFormatting("th");

  final DateFormat dateFormatter = DateFormat("EEEE, dd MMMM yyyy", "th");
  final DateFormat timeFormatter = DateFormat("HH:mm:ss", "th");
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
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ReviewsScreen(
                              restaurantInfo.id,
                              userId: userId ?? 0,
                            )));
              },
              child: Text(
                "(${restaurantInfo.reviewCount}) ดูรีวิวทั้งหมด",
                style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 0, 183, 255),
                  ),
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
              ? reviews.imagePathsReview.map((path) {
                  return 'https://www.smt-online.com/api/public/$path';
                }).toList()
              : [];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Container(
              width: MediaQuery.of(context).size.width * 1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
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
                              scale: 12,
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
                                  child: reviews.name == ""
                                      ? Text(
                                          "ผู้ใช้งานระบบ",
                                          style: GoogleFonts.prompt(
                                            textStyle: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: const Color.fromARGB(
                                                  255, 0, 84, 153),
                                            ),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      : Text(
                                          reviews.name!,
                                          style: GoogleFonts.prompt(
                                            textStyle: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: const Color.fromARGB(
                                                  255, 0, 84, 153),
                                            ),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      // "เผยแพร่: ${DateFormat("EEEE, dd MMMM yyyy", "th").format(DateTime.parse(reviews.createdAt))}",
                                      "เผยแพร่: ${reviews.createdAt}",
                                      style: GoogleFonts.prompt(
                                        textStyle: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    // Text(
                                    //   "เผยแพร่เมื่อ ${DateFormat("HH:mm:ss", "th").format(DateTime.parse(reviews.createdAt))}",
                                    //   style: GoogleFonts.prompt(
                                    //     textStyle: TextStyle(
                                    //       fontSize: 12,
                                    //       fontWeight: FontWeight.w400,
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
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
                                size: 18,
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
                    reviews.title.toString().isEmpty || reviews.title == null
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
                        style: GoogleFonts.sarabun(
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
