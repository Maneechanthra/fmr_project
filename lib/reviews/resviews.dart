import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fmr_project/api/getReviewByrestaurant_api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import '/globals.dart' as globals;

class ReviewsScreen extends StatefulWidget {
  final int restaurantId;
  final int? userId;
  const ReviewsScreen(this.restaurantId, {required this.userId, super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  late Future<List<GetReviewByrestaurant>> futureReviewByRestaurant;

  @override
  void initState() {
    super.initState();
    futureReviewByRestaurant = fetchReviewByRestaurant(widget.restaurantId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 231, 231),
      appBar: AppBar(
        title: const Text(
          "รีวิวทั้งหมด",
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: _allReviewsPage(
        context,
        futureReviewByRestaurant,
        widget.userId ?? 0,
      ),
    );
  }
}

Widget _allReviewsPage(BuildContext context,
    Future<List<GetReviewByrestaurant>> futureReviewByRestaurant, int userId) {
  String formatThaiDate(DateTime date) {
    return DateFormat("วันที่ d MMM yyy", "th").format(date);
  }

  Future<void> deleteReview(int review_id) async {
    final response = await http.delete(
      Uri.parse('https://www.smt-online.com/api/review/delete/$review_id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '*/*',
        'connection': 'keep-alive',
        'Authorization': 'Bearer ' + globals.jwtToken,
      },
      body: json.encode({
        'id': review_id,
      }),
    );
    if (response.statusCode == 200) {
      return null;
    } else {
      throw Exception('Failed to delete post from API');
    }
  }

  return FutureBuilder<List<GetReviewByrestaurant>>(
    future: futureReviewByRestaurant,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text("Error: ${snapshot.error}"));
      } else if (snapshot.hasData) {
        final reviews = snapshot.data!;

        return ListView.builder(
          itemCount: reviews.length,
          itemBuilder: (BuildContext context, int index) {
            final review = reviews[index];
            final createdBy = review.name;
            print(createdBy);

            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Container(
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 30,
                                child: Image.asset("assets/img/icons/user.png"),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              review.name == ""
                                  ? Text(
                                      "ผู้ใช้งานระบบ",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  : Text(
                                      review.name!,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ],
                          ),
                          review.userId == userId
                              ? IconButton(
                                  onPressed: () async {
                                    AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.question,
                                        animType: AnimType.topSlide,
                                        showCloseIcon: true,
                                        title: "ยืนยันลบบัญชีผู้ใช้?",
                                        desc:
                                            "คุณต้องการลบบัญชีผู้ใช้ใช่หรือไม่?",
                                        btnCancelOnPress: () {},
                                        btnOkOnPress: () async {
                                          await deleteReview(review.id);
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ReviewsScreen(
                                                        review.restaurant_id,
                                                        userId: userId,
                                                      )));
                                        }).show();

                                    print("ลบแล้วนะจ๊ะ");
                                  },
                                  icon: const Icon(
                                    Icons.delete_forever_rounded,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                      const Divider(color: Color.fromARGB(255, 158, 158, 158)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: List.generate(
                              5,
                              (index) {
                                final starColor = (index < review.rating)
                                    ? const Color.fromARGB(255, 255, 165, 0)
                                    : const Color.fromARGB(255, 199, 199, 199);
                                return Icon(
                                  Icons.star,
                                  color: starColor,
                                  size: 14,
                                );
                              },
                            ),
                          ),
                          Text(
                            "เมื่อ: ${review.createdAt}",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      review.title.toString().isEmpty || review.title == null
                          ? SizedBox()
                          : Text(
                              review.title.toString(),
                              style: GoogleFonts.prompt(
                                textStyle: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                      const SizedBox(height: 5),
                      Text(
                        review.content,
                        style: GoogleFonts.sarabun(
                            textStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        )),
                      ),
                      const SizedBox(height: 10),
                      review.imagePaths != null && review.imagePaths.isNotEmpty
                          ? SizedBox(
                              height: 100,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: review.imagePaths.length,
                                itemBuilder: (context, index) {
                                  final String imageUrl =
                                      'https://www.smt-online.com/api/public/${review.imagePaths[index]}';
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(imageUrl)),
                                  );
                                },
                              ),
                            )
                          : const SizedBox(height: 10),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      } else {
        return Center(child: Text("No reviews found."));
      }
    },
  );
}
