import 'package:flutter/material.dart';
import 'package:fmr_project/add_screen/addVerify.dart';
import 'package:fmr_project/detail_page/detail_restaurant.dart';
import 'package:fmr_project/edit_screen/editRestaurant.dart';
import 'package:fmr_project/model/recomented_data.dart';

class RestaurantOfMePage extends StatefulWidget {
  const RestaurantOfMePage({super.key});

  @override
  State<RestaurantOfMePage> createState() => _RestaurantOfMePageState();
}

class _RestaurantOfMePageState extends State<RestaurantOfMePage> {
  bool isNormal = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset(
            //   "assets/img/icons/restaurant.png",
            //   width: 20,
            // ),
            // SizedBox(
            //   width: 5,
            // ),
            Text(
              "ร้านอาหารของฉัน",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                Restaurant_2 res = allRestaurants_2[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailRestaurantPage_2()));
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    width: 300,
                    height: 480,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 10,
                          color: Color.fromARGB(255, 187, 187, 187),
                          offset: Offset(2, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 230,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                            color: const Color.fromARGB(255, 197, 197, 197),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 209, 209, 209)
                                    .withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Stack(children: [
                            ClipRRect(
                              child: Image.network(
                                res.imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                            Positioned(
                                top: 10,
                                left: 270,
                                child: Container(
                                  width: 60,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        size: 16,
                                        color: Colors.orangeAccent,
                                      ),
                                      Text(
                                        res.rating.toString(),
                                        style: TextStyle(fontSize: 14),
                                      )
                                    ],
                                  ),
                                ))
                          ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    res.name,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Center(
                                    child: Text(
                                      index == 1 ? "ปกติ" : "ไม่ปกติ",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: index == 1
                                            ? Color.fromARGB(255, 0, 180, 0)
                                            : const Color.fromARGB(
                                                255, 255, 0, 0),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Text(
                                index == 1
                                    ? ""
                                    : "ร้านอาหารของคุณถูกรายงานความไม่เหมาะสมครบ 3 ครั้ง",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: const Color.fromARGB(255, 255, 0, 0),
                                ),
                              ),
                              Divider(),
                              const SizedBox(
                                height: 7,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.visibility,
                                        size: 16,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        res.review.toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color:
                                              Color.fromARGB(255, 97, 97, 97),
                                          fontFamily: 'EkkamaiNew',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.reviews_outlined,
                                        size: 16,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        res.review.toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color:
                                              Color.fromARGB(255, 97, 97, 97),
                                          fontFamily: 'EkkamaiNew',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        VerifyRestaurantPage()));
                          },
                          child: Center(
                            child: Container(
                              width: 330,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromARGB(255, 0, 163, 22),
                              ),
                              child: Center(
                                  child: Text(
                                "ยืนยันตัวตน",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                              )),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => editRestaurant()));
                          },
                          child: Center(
                            child: Container(
                              width: 330,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromARGB(255, 0, 130, 252),
                              ),
                              child: Center(
                                  child: Text(
                                "แก้ไขข้อมูล",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                              )),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        InkWell(
                          onTap: () {},
                          child: Center(
                            child: Container(
                              width: 330,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromARGB(255, 192, 0, 0),
                              ),
                              child: Center(
                                  child: Text(
                                "ลบร้านอาหาร",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                              )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: allRestaurants_2.length,
            ),
          ),
        ],
      ),
    );
  }
}
