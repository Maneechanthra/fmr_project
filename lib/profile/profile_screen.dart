import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fmr_project/add_new/add_restaurant_new.dart';
import 'package:fmr_project/api/reportRestaurant_api.dart';
import 'package:fmr_project/color/colors.dart';
import 'package:fmr_project/login/login_new.dart';
import 'package:fmr_project/report_restaurant/report_my_restaurant.dart';
import 'package:fmr_project/update/changepassword.dart';
import 'package:fmr_project/update/editemail.dart';
import 'package:fmr_project/update/editname.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  final int? userId;
  const ProfileScreen({required this.userId, super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    // if (widget.userId == 0) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     _login();
    //   });
    // }
  }

  @override
  void dispose() {
    super.dispose();
  }

  // void _login() {
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (context) => LoginScreen()),
  //   );
  // }

  Widget _notLodin() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Image.asset(
            "assets/img/no_info.png",
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.055,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  "เข้าสู่ระบบ / สร้างบัญชีผู้ใช้",
                  style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  )),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.userId == 0
          ? _notLodin()
          : SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.20,
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(0),
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 94, 0, 0),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        "assets/img/bg_2.png",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color.fromARGB(54, 0, 0, 0),
                                          Colors.black
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 60),
                        ],
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.30 - 55,
                        left: MediaQuery.of(context).size.width / 2 - 55,
                        child: Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(55),
                          ),
                          child: Center(
                            child: Container(
                              width: 105,
                              height: 105,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.white,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset(
                                  "assets/img/logo/logo_3.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ///////////////////// personal information //////////////////
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Sumet Maneechanthra",
                            style: GoogleFonts.prompt(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditNamePage(
                                            2, "Sumet Maneechanthra")));
                              },
                              child: Icon(EneftyIcons.edit_2_outline)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Sumet.ma@ku.th",
                              style: GoogleFonts.prompt(
                                textStyle: TextStyle(
                                    color: const Color.fromARGB(171, 0, 0, 0),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditEmailPage(
                                              2, "sumet.ma@ku.th")));
                                },
                                child: Icon(EneftyIcons.edit_2_outline)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  ////////////////// category /////////////////
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 0.1,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 221, 139, 33),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "จำนวนร้านอาหาร",
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Text(
                                  "12",
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        fontSize: 30,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 1,
                              height: 50,
                              color: Colors.white,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "จำนวนร้านอาหารที่ชื่นชอบ",
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Text(
                                  "12",
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        fontSize: 26,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  /////////// category ///////////////////
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /////////////////////// add restaurant ///////////////////////////////////
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddRestaurantScreen(
                                        selectedCategories: [],
                                        userId: widget.userId ?? 0)));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      EneftyIcons.shop_add_outline,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "เพิ่มร้านอาหาร",
                                      style: GoogleFonts.prompt(
                                        textStyle: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Icon(
                                  EneftyIcons.arrow_right_3_outline,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                        ),

                        /////////////////////// report restaurant ///////////////////////////////////
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReportMyRestaurant(
                                          userId: widget.userId,
                                        )));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      EneftyIcons.flag_outline,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "รายงานความไม่เหมาะสมร้านของฉัน",
                                      style: GoogleFonts.prompt(
                                        textStyle: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Icon(
                                  EneftyIcons.arrow_right_3_outline,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                        ),
                        /////////////////////// my restaurant ///////////////////////////////////
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddRestaurantScreen(
                                        selectedCategories: [],
                                        userId: widget.userId ?? 0)));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      EneftyIcons.shop_outline,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "ร้านอาหารของฉัน",
                                      style: GoogleFonts.prompt(
                                        textStyle: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Icon(
                                  EneftyIcons.arrow_right_3_outline,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(),
                        ////////////////////// change password ///////////////////
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChangePasswordPage()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.key_outlined,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "เปลี่ยนรหัสผ่าน",
                                      style: GoogleFonts.prompt(
                                        textStyle: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Icon(
                                  EneftyIcons.arrow_right_3_outline,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                        ),
                        ////////////////////// log out ///////////////////
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddRestaurantScreen(
                                        selectedCategories: [],
                                        userId: widget.userId ?? 0)));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      EneftyIcons.logout_outline,
                                      color: Colors.red,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "ออกจากระบบ",
                                      style: GoogleFonts.prompt(
                                        textStyle: TextStyle(
                                          color: Color.fromARGB(255, 255, 0, 0),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Icon(
                                  EneftyIcons.arrow_right_3_outline,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(),
                        ////////////////////////// delete account ///////////////////////
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 1,
                            height: MediaQuery.of(context).size.height * 0.055,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                "ลบบัญชีผู้ใช้",
                                style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
