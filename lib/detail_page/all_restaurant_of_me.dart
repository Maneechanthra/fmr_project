import 'package:flutter/material.dart';
import 'package:fmr_project/add/addVerify.dart';
import 'package:fmr_project/detail_page/detail_restaurant.dart';
import 'package:fmr_project/update/editRestaurant.dart';
import 'package:fmr_project/model/restaurant_info.dart';

class AllRestaurantOfme extends StatefulWidget {
  const AllRestaurantOfme({super.key});

  @override
  State<AllRestaurantOfme> createState() => _AllRestaurantOfmeState();
}

class _AllRestaurantOfmeState extends State<AllRestaurantOfme> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "ร้านอาหารของฉัน",
        style: TextStyle(
          fontSize: 18,
        ),
      )),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: allRestaurants_2.length,
            itemBuilder: (BuildContext context, int index) {
              Restaurant_2 item = allRestaurants_2[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DetailRestaurantPage_2(item.id)));
                    print(item.id);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: item.verified == 2
                        ? 430
                        : item.status == -1
                            ? 460
                            : item.verified == 1
                                ? 430
                                : 480,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 223, 223, 223),
                          offset: Offset(0, 5),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          child: Image.asset(
                            item.imageUrls[0],
                            width: double.maxFinite,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    item.name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
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
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        size: 18,
                                        color: Colors.orange,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        item.rating.toString(),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      " (${item.review.toString()} รีวิว)",
                                      style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 168, 168, 168),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 200,
                                child: Text(
                                  "จำนวนการเข้าชม: ${item.views.toString()} ครั้ง",
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Divider(
                                color: const Color.fromARGB(255, 161, 161, 161),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'สถานะ: ',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  item.status == 1
                                      ? Text(
                                          "ปกติ",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 0, 211, 14),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        )
                                      : Text(
                                          "ยกเลิกการเข้าถึงข้อมูลร้านอาหาร",
                                          style: TextStyle(
                                              color: const Color.fromARGB(
                                                  255, 255, 0, 0),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                ],
                              ),
                              item.status == -1
                                  ? Row(
                                      children: [
                                        Text(
                                          "ร้านของคุณถูกรายงานความไม่เหมาะสมครบ 3 ครั้ง",
                                          style: TextStyle(color: Colors.red),
                                        )
                                      ],
                                    )
                                  : SizedBox(),
                              Row(
                                children: [
                                  Text(
                                    'สถานะรับรอง: ',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  (item.verified == 0)
                                      ? Text(
                                          "ยังไม่ได้รับการรับรอง",
                                          style: TextStyle(
                                              color: const Color.fromARGB(
                                                  255, 0, 0, 0),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        )
                                      : (item.verified == 1)
                                          ? Text(
                                              "รอตรวจสอบข้อมูล",
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 255, 153, 0),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          : Text(
                                              "รับรองแล้ว",
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 102, 255),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            )
                                ],
                              ),
                              Divider(
                                color: const Color.fromARGB(255, 161, 161, 161),
                              ),
                              // SizedBox(
                              //   height: 10,
                              // ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  editRestaurant(
                                                    selectedCategories: [],
                                                    res_id: item.id,
                                                  )));
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.43,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.blue,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "แก้ไขข้อมูล",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    onTap: () {},
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.43,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color.fromARGB(255, 255, 0, 0),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "ลบ",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              item.verified == 2
                                  ? SizedBox()
                                  : item.status == -1
                                      ? SizedBox(
                                          height: 10,
                                        )
                                      : item.verified == 1
                                          ? SizedBox()
                                          : GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            VerifyRestaurantPage(
                                                                item.id)));
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    1,
                                                height: 45,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Color.fromARGB(
                                                      255, 16, 180, 1),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "ยืนยันตัวตนร้านอาหาร",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
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
      ),
    );
  }
}
