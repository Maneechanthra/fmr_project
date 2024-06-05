import 'dart:async';
import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fmr_project/add/addRestuarant.dart';
import 'package:fmr_project/add_new/add_restaurant_new.dart';
import 'package:fmr_project/api/profile_api.dart';
import 'package:fmr_project/bottom_navigator/bottom_navigator.dart';
import 'package:fmr_project/color/colors.dart';
import 'package:fmr_project/detail_page/all_favorites.dart';
import 'package:fmr_project/detail_page/all_restaurant_of_me.dart';
import 'package:fmr_project/detail_page/all_my_report.dart';
import 'package:fmr_project/update/changepassword.dart';
import 'package:fmr_project/update/editemail.dart';
import 'package:fmr_project/update/editname.dart';
import 'package:fmr_project/screen/home.dart';
import 'package:fmr_project/screen/login.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import '/globals.dart' as globals;

class ProfilePage extends StatefulWidget {
  final int? userId;
  const ProfilePage(this.userId, {Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<ProfileModel?> futureProfile;
  late Timer timer;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      if (widget.userId != null && widget.userId != 0) {
        futureProfile = fetchProfile(widget.userId);
        print("userId in profile : ${widget.userId}");
      } else {
        print("not userID");
      }
      timer =
          Timer.periodic(Duration(seconds: 60), (Timer t) => setState(() {}));
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  // Future<void> _delayedLoadUserLocation() async {
  //   await Future.delayed(Duration(seconds: 1));
  //   await _loadUserLocation();
  // }

  Future<void> deleteUserAndCheckLogout(int user_id) async {
    try {
      await deleteUser(user_id);
      // await checkLoginStatus();
    } catch (error) {
      print('Error: $error');
    }
  }

  // ฟังก์ชั่นเพื่อลบผู้ใช้
  Future<void> deleteUser(int user_id) async {
    final response = await http.delete(
      Uri.parse('http://10.0.2.2:8000/api/user/delete/$user_id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '*/*',
        'connection': 'keep-alive',
        'Authorization': 'Bearer ' + globals.jwtToken,
      },
      body: json.encode({
        'id': user_id,
      }),
    );
    if (response.statusCode == 200) {
      return null;
    } else {
      throw Exception('Failed to delete post from API');
    }
  }

  // ฟังก์ชั่นเพื่อตรวจสอบสถานะการล็อกเอาท์หรือการล็อกอิน
  // Future<void> checkLoginStatus() async {
  //   if (!isUserLoggedIn()) {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => LoginPage()),
  //     );
  //   } else {
  //     futureProfile = fetchProfile(widget.userId);
  //   }
  // }

  // ฟังก์ชั่นเพื่อออกจากระบบ
  Future<void> logout() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/logout'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '*/*',
        'connection': 'keep-alive',
        'Authorization': 'Bearer ' + globals.jwtToken,
      },
    );

    if (response.statusCode == 200) {
      print('ออกจากระบบสำเร็จ');
      globals.jwtToken = '';
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
      throw Exception('Failed to logout data to the API');
    }
  }

  // Function เพื่อตรวจสอบสถานะการล็อกเอาท์หรือการล็อกอิน
  // bool isUserLoggedIn() {
  //   return globals.jwtToken.isNotEmpty;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          "โปรไฟล์",
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: SizedBox(),
      ),
      body: widget.userId == 0
          ? _notlogin(context)
          : SafeArea(
              child: SingleChildScrollView(
                child: FutureBuilder(
                  future: futureProfile,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text("เกิดข้อผิดพลาด : ${snapshot.error}"),
                      );
                    } else if (!snapshot.hasData) {
                      return const Center(
                        child: Text("ไม่พบข้อมูล"),
                      );
                    } else {
                      final userData = snapshot.data!;
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.person),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "ข้อมูลส่วนตัว",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditNamePage(
                                          userData.id, userData.name)),
                                );
                              },
                              child: Container(
                                width: 380,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 240, 240, 240),
                                    width: 1,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Color.fromARGB(22, 41, 41, 41),
                                        blurRadius: 10,
                                        offset: Offset(0, 2))
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(13.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "ชื่อ-นามสกุล",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Color.fromARGB(
                                                    255, 255, 0, 0)),
                                          ),
                                          Icon(Icons.edit),
                                        ],
                                      ),
                                      Text(
                                        userData.name,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditEmailPage(
                                          userData.id, userData.email)),
                                );
                              },
                              child: Container(
                                width: 380,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 240, 240, 240),
                                    width: 1,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Color.fromARGB(22, 41, 41, 41),
                                        blurRadius: 10,
                                        offset: Offset(0, 2))
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(13.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "อีเมล",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Color.fromARGB(255, 255, 0, 0)),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            userData.email,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w800),
                                          ),
                                          Icon(Icons.edit),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Text(
                              "อื่น ๆ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color.fromARGB(221, 143, 143, 143),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddRestaurantScreen(
                                            selectedCategories: [],
                                            userId: widget.userId ?? 0,
                                            // selectedTimes: [],
                                          )),
                                );
                              },
                              child: const SizedBox(
                                height: 50,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 200,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.storefront_sharp,
                                            color: Color.fromARGB(
                                                221, 143, 143, 143),
                                            // color: Color.fromARGB(255, 8, 231, 0),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "เพิ่มข้อมูลร้านอาหาร",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 17,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            InkWell(
                              onTap: () {
                                // if (widget.userId == 0) {
                                //   AwesomeDialog(
                                //     context: context,
                                //     animType: AnimType.topSlide,
                                //     dialogType: DialogType.warning,
                                //     title: 'กรุณาเข้าสู่ระบบ!',
                                //     titleTextStyle: TextStyle(
                                //         fontWeight: FontWeight.bold,
                                //         fontSize: 20),
                                //     btnOkOnPress: () {
                                //       Navigator.push(
                                //         context,
                                //         MaterialPageRoute(
                                //           builder: (context) => LoginPage(),
                                //         ),
                                //       );
                                //     },
                                //   ).show();
                                // }
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) =>
                                //         AllRestaurantOfme(userData.id),
                                //   ),
                                // );
                              },
                              child: const SizedBox(
                                height: 50,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 200,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.restaurant,
                                            color: Color.fromARGB(
                                                221, 143, 143, 143),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "ร้านอาหารของฉัน",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 17,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            InkWell(
                              onTap: () {
                                if (widget.userId == 0) {
                                  print("object");
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AllFavoriesPage(widget.userId ?? 0)),
                                );
                              },
                              child: const SizedBox(
                                height: 50,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 200,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.favorite_border,
                                            color: Color.fromARGB(
                                                221, 143, 143, 143),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "ร้านอาหารที่ฉันชื่นชอบ",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 17,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NotificationPage(userData.id)),
                                );
                              },
                              child: const SizedBox(
                                height: 50,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 313,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.report_gmailerrorred,
                                            color: Color.fromARGB(
                                                221, 143, 143, 143),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          SizedBox(
                                            width: 260,
                                            child: Text(
                                              "รายงานความไม่เหมาะสมร้านอาหารของฉัน",
                                              style: TextStyle(fontSize: 16),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 17,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Text(
                              "ตั้งค่า",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(221, 143, 143, 143),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) =>
                                //           const ChangePasswordPage()),
                                // );
                              },
                              child: const SizedBox(
                                height: 50,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 200,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.key,
                                            color: Color.fromARGB(
                                                221, 143, 143, 143),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "เปลี่ยนรหัสผ่าน",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 17,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            InkWell(
                              onTap: () {
                                AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.question,
                                    animType: AnimType.topSlide,
                                    showCloseIcon: true,
                                    title: "ยืนยันออกจากระบบ?",
                                    desc: "คุณต้องการออกจากระบบใช่หรือไม่?",
                                    btnCancelOnPress: () {},
                                    btnOkOnPress: () async {
                                      await logout();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BottomNavigatorPage(
                                                    indexPage: 0,
                                                  )));
                                    }).show();
                                // Navigator.push(
                                //     context,
                                //     PageRouteBuilder(pageBuilder:
                                //         (context, animation1, animation2) {
                                //       return HomePage(widget.userId);
                                //     }, transitionsBuilder: (context, animation1,
                                //         animation2, child) {
                                //       return FadeTransition(
                                //         opacity: animation1,
                                //         child: child,
                                //       );
                                //     }));
                              },
                              child: const SizedBox(
                                height: 50,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.logout_rounded,
                                      color: Colors.red,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "ออกจากระบบ",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(),
                            SizedBox(height: 20),
                            Center(
                              child: InkWell(
                                onTap: () {},
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.red,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "ลบบัญชีผู้ใช้",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
    );
  }

  Widget _notlogin(context) {
    return SafeArea(
        child: SingleChildScrollView(
            child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/img/logo/pls_login.png",
                scale: 2,
              ),
              Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                          child: Text(
                        "กรุณาเข้าสู่ระบบ/สมัครสมาชิก",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          Text(
            "อื่น ๆ",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(221, 143, 143, 143),
            ),
          ),
          InkWell(
            onTap: () {
              widget.userId == 0
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    )
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddRestaurantScreen(
                                selectedCategories: [],
                                userId: widget.userId ?? 0,
                                // selectedTimes: [],
                              )),
                    );
            },
            child: const SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 200,
                    child: Row(
                      children: [
                        Icon(
                          Icons.storefront_sharp,
                          color: Color.fromARGB(221, 143, 143, 143),
                          // color: Color.fromARGB(255, 8, 231, 0),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "เพิ่มข้อมูลร้านอาหาร",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 17,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          InkWell(
            onTap: () {
              if (widget.userId == 0) {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.warning,
                  text: 'กรุณาเข้าสู่ระบบเพื่อใช้ฟังก์ชันนี้',
                  confirmBtnText: 'ตกลง',
                  confirmBtnColor: Color.fromARGB(255, 0, 113, 219),
                  onConfirmBtnTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                );
              }
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => AllRestaurantOfme(widget.userId)),
              // );
            },
            child: const SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 200,
                    child: Row(
                      children: [
                        Icon(
                          Icons.restaurant,
                          color: Color.fromARGB(221, 143, 143, 143),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "ร้านอาหารของฉัน",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 17,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          InkWell(
            onTap: () {
              if (widget.userId == 0) {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.warning,
                  text: 'กรุณาเข้าสู่ระบบเพื่อใช้ฟังก์ชันนี้',
                  confirmBtnText: 'ตกลง',
                  confirmBtnColor: Color.fromARGB(255, 0, 113, 219),
                  onConfirmBtnTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                );
              }
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => AllFavoriesPage(widget.userId)),
              // );
            },
            child: const SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 200,
                    child: Row(
                      children: [
                        Icon(
                          Icons.favorite_border,
                          color: Color.fromARGB(221, 143, 143, 143),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "ร้านอาหารที่ฉันชื่นชอบ",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 17,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          InkWell(
            onTap: () {
              if (widget.userId == 0) {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.warning,
                  text: 'กรุณาเข้าสู่ระบบเพื่อใช้ฟังก์ชันนี้',
                  confirmBtnText: 'ตกลง',
                  confirmBtnColor: Color.fromARGB(255, 0, 113, 219),
                  onConfirmBtnTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                );
              }
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => NotificationPage(widget.userId ?? 0)),
              // );
            },
            child: const SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 313,
                    child: Row(
                      children: [
                        Icon(
                          Icons.report_gmailerrorred,
                          color: Color.fromARGB(221, 143, 143, 143),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 260,
                          child: Text(
                            "รายงานความไม่เหมาะสมร้านอาหารของฉัน",
                            style: TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 17,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    )));
  }
}

// Widget _login(context, userId, Future<ProfileModel> futureProfile) {
//   return 
// }
