import 'dart:convert';

import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:fmr_project/api/favorite_api.dart';
import 'package:fmr_project/api/restaurantById_api.dart';
import 'package:fmr_project/detail_page/all_review.dart';
import 'package:fmr_project/dialog/addReportDialog.dart';
import 'package:fmr_project/dialog/addReviewDialog.dart';
import 'package:fmr_project/dialog/detailMoreDialog.dart';
import 'package:fmr_project/model/restaurant_info.dart';
import 'package:fmr_project/screen/login.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:fmr_project/model/review_info.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import '/globals.dart' as globals;
import 'package:http/http.dart' as http;

class DetailRestaurantPage_2 extends StatefulWidget {
  final int restaurantId;
  final int? userId;

  DetailRestaurantPage_2(this.restaurantId, this.userId, {Key? key})
      : super(key: key);

  @override
  State<DetailRestaurantPage_2> createState() => _DetailRestaurantPage_2State();
}

class _DetailRestaurantPage_2State extends State<DetailRestaurantPage_2> {
  bool isFavorite = false;
  // late Future<List<RestaurantById>> futureRestaurants;
  late Future<RestaurantById> futureRestaurants;
  int current = 0;

  @override
  void initState() {
    super.initState();
    futureRestaurants = getRestaurantById(widget.restaurantId);
    print("restaurantId : " + widget.restaurantId.toString());
    print("userId : " + widget.userId.toString());
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
      // body: NestedScrollView(
      //   headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
      //     return <Widget>[
      //       SliverAppBar(
      //         expandedHeight: 250,
      //         floating: false,
      //         pinned: true,
      //         flexibleSpace: FlexibleSpaceBar(
      //           title: Text("ร้านครัวแล้วแต่ ม.เกษตร จังหวัดสกลนคร"),
      //           background: SizedBox(
      //             width: double.infinity,
      //             height: 250,
      //             child: AnotherCarousel(
      //               images: [
      //                 NetworkImage(
      //                     "https://s359.kapook.com//pagebuilder/9dbc7505-3b39-4b7f-85b4-1c88c2a01e7f.jpg"),
      //                 NetworkImage(
      //                     "https://s359.kapook.com//pagebuilder/6ef91549-ce57-47d6-88db-3ca0c16d1b9e.jpg"),
      //                 NetworkImage(
      //                     "https://s359.kapook.com//pagebuilder/f08aab92-a04b-4acd-9718-f58f566b476a.jpg"),
      //                 NetworkImage(
      //                     "https://s359.kapook.com//pagebuilder/3d735587-e0fd-4409-ad65-bfeb72f15e98.jpg"),
      //               ],
      //             ),
      //           ),
      //         ),
      //       ),
      //     ];
      //   },
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: futureRestaurants,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                final data = snapshot.data!;
                print(data.address);
                final List<String> imageUrls = data.imagePaths.map((path) {
                  return 'http://10.0.2.2:8000/api/public/$path';
                }).toList();

                print(imageUrls);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 250,
                          child: AnotherCarousel(
                            images: imageUrls.map((url) {
                              return Image.network(
                                url,
                                fit: BoxFit.cover,
                              );
                            }).toList(),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 50),
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
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color.fromARGB(
                                              221, 189, 189, 189),
                                          offset: Offset(0, 2),
                                          blurRadius: 2,
                                        ),
                                      ]),
                                  child: Center(
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => ReportDialogPage(
                                          widget.userId ?? 0,
                                          widget.restaurantId));
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color.fromARGB(
                                              221, 189, 189, 189),
                                          offset: Offset(0, 2),
                                          blurRadius: 2,
                                        ),
                                      ]),
                                  child: Center(
                                    child: Icon(
                                      Icons.report,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Row แสดงชื่อร้านอาหารและไอคอนตรวจสอบ
                              Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.75,
                                    child: Text(
                                      data.restaurantName,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  // ไอคอนตรวจสอบสถานะ
                                  // หากต้องการใช้งานอีกครั้ง สามารถเปิดความคิดเห็น
                                  // Icon(
                                  //   Icons.verified_rounded,
                                  //   color: Colors.blue,
                                  // )
                                ],
                              ),
                              // ตรวจสอบว่า userId เป็น null หรือ 0 และเลือก Widget ตามเงื่อนไข
                              LikeButton(
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
                                      confirmBtnColor:
                                          Color.fromARGB(255, 0, 113, 219),
                                    );

                                    return Future.value(isLiked);
                                  } else {
                                    try {
                                      // ลองทำการเพิ่มรายการโปรด
                                      final favorite = await insertFavorite(
                                          widget.restaurantId, widget.userId!);

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
                                    color: isLiked ? Colors.pink : Colors.grey,
                                    size: 30,
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          data.verified == 2
                              ? Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            data.categoryTitle,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 145, 145, 145),
                                fontSize: 16),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 18,
                                    color: Colors.orange,
                                  ),
                                  Text(
                                    data.averageRating.toString(),
                                    style: TextStyle(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "(${data.reviewCount} รีวิว)",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 155, 155, 155),
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 16,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    isFavorite == true
                                        ? (data.favoritesCount + 1).toString()
                                        : data.favoritesCount.toString(),
                                  ),
                                ],
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: Container(
                                    height: 20,
                                    width: 2,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 219, 219, 219),
                                    ),
                                  )),
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.visibility,
                                        color: const Color.fromARGB(
                                            255, 153, 153, 153),
                                        size: 18,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "${data.viewCount.toString()} ครั้ง",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
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
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RestaurantInfoWidget(snapshot.data!),
                          ReviewsWidget(snapshot.data!),
                        ],
                      ),
                    ),
                  ],
                );
              }
            }),
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
              borderRadius: BorderRadius.circular(10), color: Colors.blue),
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
                    // fontFamily: 'EkkamaiNew',white),
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

//----------------------------------------------------------------
//----------------------------------------------------------------
class RestaurantInfoWidget extends StatelessWidget {
  final RestaurantById restaurantId;

  RestaurantInfoWidget(this.restaurantId);

  // LatLng _latLng = LatLng(17.27274239, 104.1265007);
  // void _openPhoneApp(String phoneNumber) async {
  //   final url = 'tel:$phoneNumber';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width * 1.0,
            height: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: const Color.fromARGB(221, 216, 216, 216))),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(restaurantId.latitude, restaurantId.longitude),
                  zoom: 15,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId('1'),
                    position:
                        LatLng(restaurantId.latitude, restaurantId.longitude),
                  ),
                },
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: SizedBox(
              height: 40,
              child: Text(
                restaurantId.address,
              ),
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: SizedBox(
              height: 20,
              child: InkWell(
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "โทร : ${restaurantId.telephone1}",
                    ),
                    Icon(Icons.phone),
                  ],
                ),
              ),
            ),
          ),
          Divider(),
          restaurantId.telephone2 == ""
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: SizedBox(
                    height: 20,
                    child: InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "โทร : ${restaurantId.telephone2}",
                          ),
                          Icon(Icons.phone),
                        ],
                      ),
                    ),
                  ),
                )
              : SizedBox(),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: InkWell(
              onTap: () {
                showDialog(
                    context: context, builder: (context) => MoreDialogPage());
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "ข้อมูลเพิ่มเติม",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Icon(Icons.more),
                    ],
                  ),
                  Text(
                    "เวลาเปิดปิด...",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}

//----------------------------------------------------------------
//----------------------------------------------------------------
class ReviewsWidget extends StatelessWidget {
  final RestaurantById restaurantId;

  ReviewsWidget(this.restaurantId);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${restaurantId.reviewCount.toString()} รีวิว",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AllReivewsPage(restaurantId.id)));
                  },
                  child: Text(
                    "ดูทั้งหมด",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 130,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      children: [
                        Text(
                          "${restaurantId.averageRating.toInt()}",
                          style: TextStyle(
                            fontSize: 65,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "จาก ${restaurantId.reviewCount.toString()} รีวิว",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: List.generate(
                                      5,
                                      (index) {
                                        Color starColor;
                                        if (index < 5) {
                                          starColor = const Color.fromARGB(
                                              255, 255, 165, 0);
                                        } else {
                                          starColor = const Color.fromARGB(
                                              255, 199, 199, 199);
                                        }
                                        return Icon(
                                          Icons.star,
                                          color: starColor,
                                          size: 14,
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text(
                                    "0",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: List.generate(
                                      5,
                                      (index) {
                                        Color starColor;
                                        if (index < 4) {
                                          starColor = const Color.fromARGB(
                                              255, 255, 165, 0);
                                        } else {
                                          starColor = const Color.fromARGB(
                                              255, 199, 199, 199);
                                        }
                                        return Icon(
                                          Icons.star,
                                          color: starColor,
                                          size: 14,
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text(
                                    "3",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: List.generate(
                                      5,
                                      (index) {
                                        Color starColor;
                                        if (index < 3) {
                                          starColor = const Color.fromARGB(
                                              255, 255, 165, 0);
                                        } else {
                                          starColor = const Color.fromARGB(
                                              255, 199, 199, 199);
                                        }
                                        return Icon(
                                          Icons.star,
                                          color: starColor,
                                          size: 14,
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text(
                                    "0",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: List.generate(
                                      5,
                                      (index) {
                                        Color starColor;
                                        if (index < 2) {
                                          starColor = const Color.fromARGB(
                                              255, 255, 165, 0);
                                        } else {
                                          starColor = const Color.fromARGB(
                                              255, 199, 199, 199);
                                        }
                                        return Icon(
                                          Icons.star,
                                          color: starColor,
                                          size: 14,
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text(
                                    "0",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: List.generate(
                                      5,
                                      (index) {
                                        Color starColor;
                                        if (index < 1) {
                                          starColor = const Color.fromARGB(
                                              255, 255, 165, 0);
                                        } else {
                                          starColor = const Color.fromARGB(
                                              255, 199, 199, 199);
                                        }
                                        return Icon(
                                          Icons.star,
                                          color: starColor,
                                          size: 14,
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text(
                                    "0",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            restaurantId.reviewCount == 0
                ? SizedBox()
                : _CommentWidget(restaurantId),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AllReivewsPage(restaurantId.id)));
              },
              child: Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 233, 233, 233),
                ),
                child: Center(
                  child: Text(
                    "ดูทั้งหมด",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w200,
                        color: const Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 80,
            ),
          ],
        ),
      ),
    );
  }
}

//----------------------------------------------------------------
Widget _CommentWidget(RestaurantById restaurantId) {
  return ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    // กำหนด itemCount เป็น 2 เพื่อแสดงเพียง 2 รีวิว
    itemCount: 2,
    itemBuilder: (BuildContext context, int index) {
      // ป้องกันไม่ให้ดัชนีเกินขอบเขตของ restaurantId.reviews
      if (index >= restaurantId.reviews.length) {
        return Container(); // คืนค่า Container เปล่าเพื่อหลีกเลี่ยงข้อผิดพลาด
      }

      final review = restaurantId.reviews[index];
      final List<String> imageUrlsReview = review.imagePathsReview.map((path) {
        return 'http://10.0.2.2:8000/api/public/$path';
      }).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 30,
                child: Image.asset("assets/img/icons/user.png"),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                review.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: List.generate(
                    5,
                    (index) {
                      Color starColor;
                      if (index < 5) {
                        starColor = const Color.fromARGB(255, 255, 165, 0);
                      } else {
                        starColor = const Color.fromARGB(255, 199, 199, 199);
                      }
                      return Icon(
                        Icons.star,
                        color: starColor,
                        size: 14,
                      );
                    },
                  ),
                ),
                Text(
                  review.created_at,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            review.title ?? "",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            review.content,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: imageUrlsReview.length,
              itemBuilder: (context, index) {
                if (index >= imageUrlsReview.length) {
                  return Container();
                }

                return Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Image.network(
                    imageUrlsReview[index],
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Divider(),
          SizedBox(
            height: 10,
          ),
        ],
      );
    },
  );
}
