import 'package:flutter/material.dart';
import 'package:fmr_project/api/myFavorite_api.dart';
import 'package:fmr_project/color/colors.dart';
import 'package:fmr_project/detail_restaurant/detail_restaurant.dart';
import 'package:fmr_project/login/login_new.dart';
import 'package:fmr_project/screen/login.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoriteScreen extends StatefulWidget {
  final int userId;
  const FavoriteScreen(this.userId, {super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late Future<List<MyFavoriteModel>> getMyFavorites;

  @override
  void initState() {
    super.initState();
    getMyFavorites = fetchMyFavorites(widget.userId);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _notLodin() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Image.asset(
            "assets/img/no_info.png",
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.055,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  "เข้าสู่ระบบ / สร้างบัญชีผู้ใช้",
                  style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  )),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: widget.userId == 0
            ? _notLodin()
            : FutureBuilder<List<MyFavoriteModel>>(
                future: getMyFavorites,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.06,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              "เข้าสู่ระบบ / สร้างบัญชีผู้ใช้",
                              style: GoogleFonts.mitr(
                                  textStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white)),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final myFavorites = snapshot.data as List<MyFavoriteModel>;
                    // final List<MyFavoriteModel> myFavorites = snapshot.data ?? [];
                    if (myFavorites.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 300,
                            child: Image.asset("assets/img/not_data.png"),
                          ),
                          Text(
                            "ไม่พบข้อมูล",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      );
                    } else {
                      return
                          // Padding(
                          //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          //   child: ListView.builder(
                          //       itemBuilder: (BuildContext context, index) {
                          //     return Container(
                          //       decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(12),
                          //         color: Colors.white,
                          //       ),
                          //     );
                          //   }),
                          // );

                          Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 15,
                        ),
                        child: ListView.builder(
                          itemCount: myFavorites.length,
                          itemBuilder: (BuildContext context, index) {
                            final item = myFavorites[index];
                            final String imageUrl =
                                'http://10.0.2.2:8000/api/public/${item.imagePath}';
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DetailRestaurantPage_2(
                                                  item.id, widget.userId)));
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 1,
                                  height:
                                      MediaQuery.of(context).size.height * 0.15,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Color.fromARGB(101, 236, 236, 236),
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: const Color.fromARGB(29, 0, 0, 0),
                                    //     blurRadius: 10,
                                    //     offset: Offset(0, 5),
                                    //   )
                                    // ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Image.network(
                                            imageUrl,
                                            fit: BoxFit.cover,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.15,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.46,
                                                  child: Text(
                                                    item.restaurantName,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                item.verified == 2
                                                    ? Icon(
                                                        Icons.verified_rounded,
                                                        color: Colors.blue,
                                                      )
                                                    : SizedBox(),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 3),
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                child: Text(
                                                  item.restaurantCategory
                                                      .join("/"),
                                                  style: GoogleFonts.mitr(
                                                    textStyle: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: Colors.black45,
                                                    ),
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  size: 18,
                                                  color: Colors
                                                      .amber[600], // สีของดาว
                                                ),
                                                item.averageRating == 0 ||
                                                        item.averageRating ==
                                                            null
                                                    ? Text(
                                                        "0",
                                                      )
                                                    : Text(
                                                        "${item.averageRating?.toStringAsFixed(1)}",
                                                      ),
                                                Text(
                                                  " (${item.reviewCount} รีวิว)",
                                                  style: TextStyle(
                                                      color: Color.fromARGB(90,
                                                          0, 0, 0)), // สีอ่อน
                                                ),
                                              ],
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
                        ),
                      );
                    }
                  }
                  return Center(
                    child: Text("No data"), // กรณีที่ไม่มีข้อมูล
                  );
                },
              ));
  }
}
