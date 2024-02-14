import 'package:flutter/material.dart';
import 'package:fmr_project/add_screen/addRestuarant.dart';
import 'package:fmr_project/detail_page/restaurantOfme.dart';
import 'package:fmr_project/edit_screen/changepassword.dart';
import 'package:fmr_project/edit_screen/editemail.dart';
import 'package:fmr_project/edit_screen/editname.dart';
import 'package:fmr_project/screen/home.dart';
import 'package:fmr_project/screen/login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: const Text(
                  "โปรไฟล์",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
                  child: const Padding(
                    padding: EdgeInsets.all(13.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "ชื่อ-นามสกุล",
                              style: TextStyle(fontSize: 14),
                            ),
                            Icon(Icons.edit),
                          ],
                        ),
                        Text(
                          "นายสุเมธ มณีจันทรา",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w800),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              fontSize: 16, fontWeight: FontWeight.w800),
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
                              width: 15,
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
                        builder: (context) => const RestaurantOfMePage()),
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
                              width: 15,
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
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const RestaurantOfMePage()),
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
                              Icons.notifications_active_outlined,
                              color: Color.fromARGB(221, 143, 143, 143),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "แจ้งเตือนของฉัน",
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
                        builder: (context) => const ChangePasswordPage()),
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
                              width: 15,
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
                    MaterialPageRoute(builder: (context) => const LoginPage()),
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
                            width: 15,
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
                      PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) {
                        return const HomePage();
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
                        width: 15,
                      ),
                      Text(
                        "ออกจากระบบ",
                        style: TextStyle(fontSize: 16, color: Colors.red),
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
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.red,
                    ),
                    child: Center(
                      child: Text(
                        "ลบบัญชีผู้ใช้",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
