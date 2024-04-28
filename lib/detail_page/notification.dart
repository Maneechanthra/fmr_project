import 'package:flutter/material.dart';
import 'package:fmr_project/api/reportRestaurantByuserId_api.dart';

class NotificationPage extends StatefulWidget {
  final int? userId;
  const NotificationPage(this.userId, {super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late Future<ReportRestaurantByuserIdList?> _futureReportRestaurantByuserId;

  @override
  void initState() {
    super.initState();
    if (widget.userId != null || widget.userId != 0) {
      _futureReportRestaurantByuserId =
          fetchReportRestaurantByuserId(widget.userId);
    } else {
      print("dont load reportRestaurantByuserId");
    }
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
          "รายงานความไม่เหมาะสมร้านอาหารของฉัน",
          style: TextStyle(fontSize: 18),
        )),
        body: FutureBuilder(
          future: _futureReportRestaurantByuserId,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } else if (snapshot.hasData) {
              final reportList = snapshot.data as ReportRestaurantByuserIdList;
              if (reportList.reports.isEmpty) {
                // ตรวจสอบว่ามีข้อมูลหรือไม่
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/img/icons/good_not_report.png',
                          width: 600, // ความกว้างของรูปภาพ
                          height: 250,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "ดีใจด้วย! ร้านของคุณไม่มีรายงานความไม่เหมาะสม",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                );
              }

              return Padding(
                padding: EdgeInsets.all(10),
                child: ListView.builder(
                  itemCount: reportList.reports.length,
                  itemBuilder: (context, index) {
                    final report = reportList.reports[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 5,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child:
                                      Image.asset("assets/img/logo/logo_3.png"),
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.65,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      report.title,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "ชื่อร้าน: ${report.restaurantName}",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    SizedBox(
                                      child: Text(
                                        "คำอธิบาย: ${report.descriptions}",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "จำนวนครั้งที่ถูกการรายงาน: ${report.reportCount}/3",
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
                ),
              );
            } else {
              return Center(
                child: Text("Unexpected state"),
              );
            }
          },
        ));
  }
}
