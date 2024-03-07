import 'package:flutter/material.dart';
import 'package:fmr_project/model/review_info.dart';

class AllReivewsPage extends StatefulWidget {
  const AllReivewsPage({super.key});

  @override
  State<AllReivewsPage> createState() => _AllReivewsPageState();
}

class _AllReivewsPageState extends State<AllReivewsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 231, 231, 231),
      appBar: AppBar(
        title: Text(
          "รีวิวทั้งหมด",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
      body: _AllReivewsPage(context),
    );
  }
}

Widget _AllReivewsPage(BuildContext context) {
  String create_by = "BossKA";
  return Container(
    child: ListView.builder(
      itemCount: Comment.length,
      itemBuilder: (BuildContext context, int index) {
        Comments comment = Comment[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Container(
            color: const Color.fromARGB(255, 255, 255, 255),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
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
                      comment.name == create_by
                          ? IconButton(
                              onPressed: () {
                                print("ลบแล้วนะจ๊ะ");
                              },
                              icon: Icon(
                                Icons.delete_forever_rounded,
                                color: Colors.red,
                                size: 30,
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                  Divider(
                    color: const Color.fromARGB(255, 158, 158, 158),
                  ),
                  SizedBox(
                    height: 10,
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
                      Text(
                        "วันที่: ${comment.dateReview}",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
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
                      itemCount: 3,
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
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}
