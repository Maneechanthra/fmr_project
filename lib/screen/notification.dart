import 'package:flutter/material.dart';
import 'package:fmr_project/model/report_info.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "รายงานความไม่เหมาะสมร้านอาหารของฉัน",
        style: TextStyle(fontSize: 18),
      )),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView.custom(
          childrenDelegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              report item = getReport[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                child: Column(
                  children: [
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          child: SizedBox(
                              width: 50,
                              height: 50,
                              child: Image.asset("assets/img/logo/logo_3.png")),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.65,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              // SizedBox(height: 5),
                              Text(
                                "ชื่อร้าน: ${item.restaurantId == 1 ? "ครัวตามสั่ง" : item.restaurantId == 2 ? "บาร์บีคิว" : ""}",
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(
                                child: Text(
                                  "คำอธิบาย: ${item.description}",
                                  style: TextStyle(fontSize: 12),
                                  // maxLines: 1,
                                  // overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "จำนวนครั้งที่ถูกการรายงาน: ${item.countReport}/3",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Color.fromARGB(255, 184, 184, 184),
                    ),
                  ],
                ),
              );
            },
            childCount: getReport.length,
          ),
        ),
      ),
    );
  }
}
