import 'package:flutter/material.dart';

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
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 130,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 255, 255, 255),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 228, 228, 228),
                          blurRadius: 7.0,
                          offset: Offset(0, 2),
                        ),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Icon(
                          Icons.notifications_active,
                          size: 40,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "รายงานความไม่เหมาะสมร้านของคุณ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                width: 200,
                                child: Text(
                                  "รายของคุณถูกรายงานความไม่เหมาะสมเนื่องจากใช้ภาพจากร้านอื่น",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: 2,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(66, 189, 189, 189),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "จำนวนครั้งที่ถูกรายงาน : 1/3 ครั้ง",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w300),
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
            childCount: 1,
          ),
        ),
      ),
    );
  }
}
