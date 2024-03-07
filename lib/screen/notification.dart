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
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.notifications_active_outlined),
                    Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: 100,
                          child: Column(
                            children: [
                              Text(item.title),
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.black,
                        )
                      ],
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
