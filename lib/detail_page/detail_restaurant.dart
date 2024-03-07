import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:fmr_project/detail_page/all_review.dart';
import 'package:fmr_project/dialog/addReportDialog.dart';
import 'package:fmr_project/dialog/addReviewDialog.dart';
import 'package:fmr_project/dialog/detailMoreDialog.dart';
import 'package:fmr_project/model/restaurant_info.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:fmr_project/model/review_info.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailRestaurantPage_2 extends StatefulWidget {
  final int res_id;

  DetailRestaurantPage_2(this.res_id, {Key? key}) : super(key: key);

  @override
  State<DetailRestaurantPage_2> createState() => _DetailRestaurantPage_2State();
}

class _DetailRestaurantPage_2State extends State<DetailRestaurantPage_2> {
  bool isFavorite = false;
  late Future<List<Restaurant_2>> futureShowDetailPost;
  int current = 0;

  @override
  void initState() {
    super.initState();
    // futureShowDetailPost = loadRestaurants();
  }

  // Future<List<Restaurant_2>> loadRestaurants() async {
  //   return await Future.delayed(Duration(seconds: 1), () {
  //     return allRestaurants_2;
  //   });
  // }

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 250,
                  child: AnotherCarousel(
                    images: [
                      AssetImage(
                          allRestaurants_2[widget.res_id - 1].imageUrls[0]),
                      AssetImage(
                          allRestaurants_2[widget.res_id - 1].imageUrls[1]),
                      AssetImage(
                          allRestaurants_2[widget.res_id - 1].imageUrls[2]),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
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
                                  color:
                                      const Color.fromARGB(221, 189, 189, 189),
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
                              builder: (context) => ReportDialogPage());
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color.fromARGB(221, 189, 189, 189),
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
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.75,
                            child: Text(
                              allRestaurants_2[widget.res_id - 1].name,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // Icon(
                          //   Icons.verified_rounded,
                          //   color: Colors.blue,
                          // )
                        ],
                      ),
                      LikeButton(
                        isLiked: isFavorite,
                        onTap: (bool isLiked) {
                          setState(() {
                            isFavorite = !isLiked;
                          });
                          return Future.value(!isLiked);
                        },
                        size: 30,
                        circleColor: const CircleColor(
                            start: Colors.pink, end: Colors.red),
                        bubblesColor: const BubblesColor(
                          dotPrimaryColor: Colors.pink,
                          dotSecondaryColor: Colors.red,
                        ),
                        likeBuilder: (bool isLiked) {
                          return Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
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
                  allRestaurants_2[widget.res_id - 1].verified == 2
                      ? Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    allRestaurants_2[widget.res_id - 1].type_restaurant,
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.star,
                            size: 18,
                            color: Colors.orange,
                          ),
                          Text(
                            allRestaurants_2[widget.res_id - 1]
                                .rating
                                .toString(),
                            style: TextStyle(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "(${allRestaurants_2[widget.res_id - 1].review} รีวิว)",
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
                                ? (allRestaurants_2[widget.res_id - 1]
                                            .favorites +
                                        1)
                                    .toString()
                                : allRestaurants_2[widget.res_id - 1]
                                    .favorites
                                    .toString(),
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
                                color: const Color.fromARGB(255, 153, 153, 153),
                                size: 18,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "${allRestaurants_2[widget.res_id - 1].views.toString()} ครั้ง",
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
                  RestaurantInfoWidget(widget.res_id),
                  ReviewsWidget(widget.res_id),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      floatingActionButton: InkWell(
        onTap: () {
          showDialog(context: context, builder: (context) => AddReviewDialog());
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
  final int res_id;

  RestaurantInfoWidget(this.res_id);

  LatLng _latLng = LatLng(17.27274239, 104.1265007);
  void _openPhoneApp(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Builder(builder: (context) {
        return Column(
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
                    target: LatLng(allRestaurants_2[res_id - 1].latitude,
                        allRestaurants_2[res_id - 1].longitude),
                    zoom: 15,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId('1'),
                      position: LatLng(allRestaurants_2[res_id - 1].latitude,
                          allRestaurants_2[res_id - 1].longitude),
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
                  allRestaurants_2[res_id - 1].address,
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: SizedBox(
                height: 40,
                child: InkWell(
                  onTap: () {
                    _openPhoneApp("0630038428");
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "โทร : ${allRestaurants_2[res_id - 1].telephone_1}",
                      ),
                      Icon(Icons.phone),
                    ],
                  ),
                ),
              ),
            ),
            Divider(),
            allRestaurants_2[res_id - 1].telephone_2 != ""
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: SizedBox(
                      height: 40,
                      child: InkWell(
                        onTap: () {
                          _openPhoneApp("0829606502");
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "โทร : ${allRestaurants_2[res_id - 1].telephone_2}",
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
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
          ],
        );
      }),
    );
  }
}

//----------------------------------------------------------------
//----------------------------------------------------------------
class ReviewsWidget extends StatelessWidget {
  final int res_id;

  ReviewsWidget(this.res_id);
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
                  "${allRestaurants_2[res_id - 1].review.toString()} รีวิว",
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
                            builder: (context) => AllReivewsPage()));
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
                          "${allRestaurants_2[res_id - 1].rating.toString()}",
                          style: TextStyle(
                            fontSize: 65,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "จาก ${allRestaurants_2[res_id - 1].review.toString()} รีวิว",
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
            _CommentWidget(),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AllReivewsPage()));
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
Widget _CommentWidget() {
  return ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: 2,
    itemBuilder: (BuildContext context, int index) {
      Comments comment = Comment[index];
      return Container(
        child: Column(
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
                  comment.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                (comment.id == 1)
                    ? Row(
                        children: List.generate(
                          5,
                          (index) {
                            Color starColor;
                            if (index < 5) {
                              starColor =
                                  const Color.fromARGB(255, 255, 165, 0);
                            } else {
                              starColor =
                                  const Color.fromARGB(255, 199, 199, 199);
                            }
                            return Icon(
                              Icons.star,
                              color: starColor,
                              size: 14,
                            );
                          },
                        ),
                      )
                    : Row(
                        children: List.generate(
                          5,
                          (index) {
                            Color starColor;
                            if (index < 3.5) {
                              starColor =
                                  const Color.fromARGB(255, 255, 165, 0);
                            } else {
                              starColor =
                                  const Color.fromARGB(255, 199, 199, 199);
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
                  "วันที่: ${comment.dateReview}",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              comment.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              comment.content,
              style: TextStyle(
                fontSize: 12,
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
                itemCount: comment.imageUrls.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Image.asset(
                      comment.imageUrls[index],
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
        ),
      );
    },
  );
}
