import 'package:flutter/material.dart';
import 'package:fmr_project/detail_page/detail_restaurant.dart';

import 'package:fmr_project/model/recomented_data.dart';

import 'package:google_fonts/google_fonts.dart';

class RecomentedPage extends StatefulWidget {
  const RecomentedPage({Key? key}) : super(key: key);

  @override
  State<RecomentedPage> createState() => _RecomentedPageState();
}

class _RecomentedPageState extends State<RecomentedPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 3,
        shrinkWrap: true,
        childAspectRatio: 0.9,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(allRestaurants_2.length, (index) {
          Restaurant_2 res = allRestaurants_2[index];
          return Padding(
            padding: const EdgeInsets.all(3.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailRestaurantPage_2()),
                );
              },
              child: SizedBox(
                height: 300,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(221, 218, 218, 218),
                          offset: Offset(0, 2),
                          blurRadius: 2,
                        )
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            child: Image.asset(
                              res.imageUrls[0],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 100,
                            ),
                          ),
                          Positioned(
                            top: 5,
                            left: MediaQuery.of(context).size.width * 0.3,
                            child: Container(
                              width: 50,
                              height: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 4.0, right: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: 14,
                                      color: Colors.orangeAccent,
                                    ),
                                    Text(
                                      res.rating.toString(),
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              res.name,
                              style: GoogleFonts.mitr(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              res.type_restaurant,
                              style: GoogleFonts.mitr(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color.fromARGB(255, 168, 168, 168),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 20,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Color.fromARGB(255, 212, 14, 0)),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(0.8),
                                  child: Text(
                                    res.kilomate.toString() + " กม.",
                                    style: GoogleFonts.mitr(
                                        fontSize: 10,
                                        fontWeight: FontWeight.normal,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255)),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Container(
                              width: 50,
                              height: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color.fromARGB(162, 14, 12, 9),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(0.8),
                                  child: Text(
                                    res.review.toString() + " รีวิว",
                                    style: GoogleFonts.mitr(
                                        fontSize: 10,
                                        fontWeight: FontWeight.normal,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255)),
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
        }),
      ),
    );
  }
}
