import 'package:flutter/material.dart';
import 'package:fmr_project/add/addRestuarant.dart';
import 'package:fmr_project/api/profile_api.dart';
import 'package:fmr_project/detail_page/all_favorites.dart';
import 'package:fmr_project/detail_page/all_restaurant_of_me.dart';
import 'package:fmr_project/screen/notification.dart';
import 'package:fmr_project/update/changepassword.dart';
import 'package:fmr_project/update/editemail.dart';
import 'package:fmr_project/update/editname.dart';
import 'package:fmr_project/screen/home.dart';
import 'package:fmr_project/screen/login.dart';
// import 'package:http/http.dart' as http;
// import '/globals.dart' as globals;

class ProfilePage extends StatefulWidget {
  final int userId;
  const ProfilePage(this.userId, {Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<ProfileModel> futureProfile;

  @override
  void initState() {
    super.initState();
    futureProfile = fetchProfile(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: FutureBuilder(
            future: futureProfile,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
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
                      Center(
                        child: const Text(
                          "โปรไฟล์",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Center(
                        child: Divider(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
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
                                builder: (context) => const EditNamePage()),
                          );
                        },
                        child: Container(
                          width: 380,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color.fromARGB(255, 240, 240, 240),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "ชื่อ-นามสกุล",
                                      style: TextStyle(fontSize: 14),
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
                                builder: (context) => const EditEmailPage()),
                          );
                        },
                        child: Container(
                          width: 380,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color.fromARGB(255, 240, 240, 240),
                              width: 1,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromARGB(22, 41, 41, 41),
                                  blurRadius: 10,
                                  offset: Offset(0, 2))
                            ],
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(13.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "อีเมล",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Icon(Icons.edit),
                                  ],
                                ),
                                Text(
                                  "sumet.ma@ku.th",
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
                                builder: (context) => AddResPage(
                                      selectedCategories: [],
                                      userId: null,
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AllRestaurantOfme()),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AllFavoriesPage()),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NotificationPage()),
                          );
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
                                    Text(
                                      "รายงานความไม่เหมาะสมร้านอาหารของฉัน",
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ChangePasswordPage()),
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
                                      Icons.key,
                                      color: Color.fromARGB(221, 143, 143, 143),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage(userData.id)),
                          );
                        },
                        child: const SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.login_rounded,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "เข้าสู่ระบบ",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
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
                              PageRouteBuilder(pageBuilder:
                                  (context, animation1, animation2) {
                                return HomePage();
                              }, transitionsBuilder:
                                  (context, animation1, animation2, child) {
                                return FadeTransition(
                                  opacity: animation1,
                                  child: child,
                                );
                              }));
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
                                style:
                                    TextStyle(fontSize: 16, color: Colors.red),
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
            }),
      )),
    );
  }
}
