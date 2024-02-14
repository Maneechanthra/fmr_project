import 'package:flutter/material.dart';
import 'package:fmr_project/model/comment_review.dart';

class AllReivewsPage extends StatefulWidget {
  const AllReivewsPage({super.key});

  @override
  State<AllReivewsPage> createState() => _AllReivewsPageState();
}

class _AllReivewsPageState extends State<AllReivewsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
  return Padding(
    padding: EdgeInsets.all(15),
    child: ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: Comment.length,
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
                    child: Image.asset("assets/img/icons/person.png"),
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
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    comment.dateReview,
                    style: TextStyle(
                      fontSize: 14,
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
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Image.network(
                        comment.imageUrl,
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
    ),
  );
}
