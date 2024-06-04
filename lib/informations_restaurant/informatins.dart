import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fmr_project/api/restaurantById_api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class InfomatinsScreen extends StatefulWidget {
  final List<RestaurantById> restaurants;
  final String restaurantName;
  final List<Opening> opening;
  final List<String> category;

  const InfomatinsScreen({
    required this.restaurants,
    required this.restaurantName,
    required this.opening,
    required this.category,
    Key? key,
  }) : super(key: key);

  @override
  State<InfomatinsScreen> createState() => _InfomatinsScreenState();
}

class _InfomatinsScreenState extends State<InfomatinsScreen> {
  String statusText = "";
  Color statusColor = Colors.red;

  String _convertDay(int day) {
    switch (day) {
      case 1:
        return 'วันจันทร์';
      case 2:
        return 'วันอังคาร';
      case 3:
        return 'วันพุธ';
      case 4:
        return 'วันพฤหัสบดี';
      case 5:
        return 'วันศุกร์';
      case 6:
        return 'วันเสาร์';
      case 7:
        return 'วันอาทิตย์';
      default:
        return 'ไม่ระบุ';
    }
  }

  List<Opening> _getOpeningsForDay(int day) {
    return widget.opening.where((opening) => opening.dayOpen == day).toList();
  }

  bool _isOpenNow() {
    final now = DateTime.now();
    final nowDay = now.weekday;
    final nowTime = DateFormat.Hm().format(now);

    for (final opening in _getOpeningsForDay(nowDay)) {
      final openTime = opening.timeOpen;
      final closeTime = opening.timeClose;

      if (nowTime.compareTo(openTime) >= 0 &&
          nowTime.compareTo(closeTime) <= 0) {
        return true;
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    final isOpen = _isOpenNow();
    statusText = isOpen ? "เปิด" : "ปิด";
    statusColor = isOpen ? Colors.green : Colors.red;

    print(statusText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 236, 236, 236),
      appBar: AppBar(
        title: Text(
          "ข้อมูล ${widget.restaurantName}",
          style: GoogleFonts.prompt(
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: Container(
            color: Color.fromARGB(255, 255, 153, 0),
            height: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.white),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ประเภทร้านอาหาร",
                      style: GoogleFonts.prompt(
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.category.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            widget.category[index],
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.white),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "เวลาเปิด-ปิดร้าน",
                            style: GoogleFonts.prompt(
                              textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            statusText,
                            style: GoogleFonts.prompt(
                              textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 7, // จำนวนวันในสัปดาห์
                        itemBuilder: (context, index) {
                          final day = _convertDay(index + 1);
                          final openings = _getOpeningsForDay(index + 1);

                          if (openings.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      day,
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.prompt(
                                        textStyle: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      "ปิด",
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.prompt(
                                        textStyle: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            // final now = DateTime.now();
                            // final nowDay = now.weekday;
                            // final nowTime = DateFormat.Hm().format(now);
                            // final isOpenToday = (index + 1 == nowDay) &&
                            //     openings.any((opening) =>
                            //         nowTime.compareTo(opening.timeOpen) >= 0 &&
                            //         nowTime.compareTo(opening.timeClose) <= 0);
                            // final todayStatusText = isOpenToday ? "เปิด" : "ปิด";
                            // final todayStatusColor =
                            //     isOpenToday ? Colors.green : Colors.red;

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      day,
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.prompt(
                                        textStyle: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      children: [
                                        Text(
                                          "${openings[0].timeOpen}",
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.prompt(
                                            textStyle: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 3),
                                          child: Text("-"),
                                        ),
                                        Text(
                                          "${openings[0].timeClose}",
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.prompt(
                                            textStyle: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        // Text(
                                        //   todayStatusText,
                                        //   style: GoogleFonts.prompt(
                                        //     textStyle: TextStyle(
                                        //       fontSize: 14,
                                        //       fontWeight: FontWeight.w400,
                                        //       color: todayStatusColor,
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
