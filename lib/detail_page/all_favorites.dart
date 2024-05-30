import 'package:flutter/material.dart';
import 'package:fmr_project/api/myFavorite_api.dart';
import 'package:fmr_project/detail_restaurant/detail_restaurant.dart';
import 'package:fmr_project/model/restaurant_info.dart';

class AllFavoriesPage extends StatefulWidget {
  final int userId;
  const AllFavoriesPage(this.userId, {super.key});

  @override
  State<AllFavoriesPage> createState() => _AllFavoriesPageState();
}

class _AllFavoriesPageState extends State<AllFavoriesPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "ร้านอาหารที่ฉันชื่นชอบ",
            style: TextStyle(fontSize: 18),
          ),
        ),
        body: FutureBuilder<List<MyFavoriteModel>>(
          future: getMyFavorites,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error loading data"),
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
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15,
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
                            height: MediaQuery.of(context).size.height * 0.1,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                                boxShadow: [
                                  // อาจเพิ่ม BoxShadow เพื่อให้ดูสวยขึ้น
                                ]),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    imageUrl,
                                    width: 100,
                                    height: 100,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          item.restaurantName,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
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
                                            : SizedBox(), // ไม่แสดงอะไรถ้าไม่ได้ยืนยัน
                                      ],
                                    ),
                                    SizedBox(
                                      child: Text(
                                        item.restaurantCategory.join("/"),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 18,
                                          color: Colors.amber[600], // สีของดาว
                                        ),
                                        Text(
                                          "${item.averageRating}",
                                        ),
                                        Text(
                                          " (${item.reviewCount} รีวิว)",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  90, 0, 0, 0)), // สีอ่อน
                                        ),
                                      ],
                                    ),
                                  ],
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
