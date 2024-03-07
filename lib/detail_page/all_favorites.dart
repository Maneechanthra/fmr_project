import 'package:flutter/material.dart';
import 'package:fmr_project/detail_page/detail_restaurant.dart';
import 'package:fmr_project/model/restaurant_info.dart';

class AllFavoriesPage extends StatefulWidget {
  const AllFavoriesPage({super.key});

  @override
  State<AllFavoriesPage> createState() => _AllFavoriesPageState();
}

class _AllFavoriesPageState extends State<AllFavoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ร้านอาหารที่ฉันชื่นชอบ",
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        child: ListView.builder(
          itemCount: 2,
          itemBuilder: (BuildContext context, index) {
            Restaurant_2 item = allRestaurants_2[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DetailRestaurantPage_2(item.id)));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 0.1,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        // BoxShadow(
                        //   color: Colors.black38,
                        //   offset: Offset(0, 5),
                        //   blurRadius: 10,
                        // )
                      ]),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          item.imageUrls[0],
                          width: 100,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  item.name,
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
                                    : SizedBox(),
                              ],
                            ),
                            Text(
                              item.type_restaurant,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 18,
                                  color: Colors.amber[600],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "${item.rating.toString()}",
                                    ),
                                    Text(
                                      " (${item.review.toString()} รีวิว)",
                                      style: TextStyle(
                                          color: Color.fromARGB(90, 0, 0, 0)),
                                    ),
                                  ],
                                ),
                              ],
                            )
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
      ),
    );
  }
}
