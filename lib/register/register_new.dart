import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fmr_project/login/login_new.dart';
import 'package:google_fonts/google_fonts.dart';

class RegsiterScreen extends StatefulWidget {
  const RegsiterScreen({super.key});

  @override
  State<RegsiterScreen> createState() => _RegsiterScreenState();
}

class _RegsiterScreenState extends State<RegsiterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 119, 255),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.11,
                        height: MediaQuery.of(context).size.height * 0.05,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100)),
                        child: Center(
                          child: Icon(Icons.arrow_back_ios_new_outlined),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "ย้อนกลับ",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "FMRestaurant",
              style: GoogleFonts.prompt(
                textStyle: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                "ค้นหาร้านอาหารที่คุณต้องการ",
                style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  EneftyIcons.profile_add_outline,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "สร้างบัญชีผู้ใช้ใหม่",
                                    style: GoogleFonts.prompt(
                                      textStyle: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "สร้างบัญชีผู้ใช้ใหม่ เพื่อเข้าใช้งานระบบ",
                              style: GoogleFonts.prompt(
                                textStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            ///////////////////// input for fullname ////////////////////
                            Container(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(19, 0, 0, 0),
                                  borderRadius: BorderRadius.circular(12)),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'กรุณากรอกชื่อ-นามสกุล';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: true,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: const Color.fromARGB(
                                          255, 0, 132, 240),
                                      width: 2.0,
                                    ),
                                  ),
                                  hintText: "ชื่อ-นามสกุล",
                                  hintStyle: TextStyle(
                                    fontSize: 16,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  prefixIcon: Icon(EneftyIcons.profile_outline),
                                  prefixIconColor: Colors.blue,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ///////////////////// input for email ////////////////////
                            Container(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(19, 0, 0, 0),
                                  borderRadius: BorderRadius.circular(12)),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'กรุณากรอกอิเมล';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: true,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: const Color.fromARGB(
                                          255, 0, 132, 240),
                                      width: 2.0,
                                    ),
                                  ),
                                  hintText: "อีเมล",
                                  hintStyle: TextStyle(
                                    fontSize: 16,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  prefixIcon: Icon(Icons.email_outlined),
                                  prefixIconColor: Colors.blue,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ///////////////////// input for password ////////////////////
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(19, 0, 0, 0),
                                  borderRadius: BorderRadius.circular(12)),
                              // height: 70,r
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'กรุณากรอกรหัสผ่าน';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: true,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: const Color.fromARGB(
                                          255, 0, 132, 240),
                                      width: 2.0,
                                    ),
                                  ),
                                  hintText: "รหัสผ่าน",
                                  hintStyle: TextStyle(
                                    fontSize: 16,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  prefixIcon: Icon(EneftyIcons.lock_2_outline),
                                  prefixIconColor: Colors.blue,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ///////////////////// input for confirm password ////////////////////
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(19, 0, 0, 0),
                                  borderRadius: BorderRadius.circular(12)),
                              // height: 70,r
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'กรุณากรอกยืนยันรหัสผ่าน';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: true,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: const Color.fromARGB(
                                          255, 0, 132, 240),
                                      width: 2.0,
                                    ),
                                  ),
                                  hintText: "ยืนยันรหัสผ่าน",
                                  hintStyle: TextStyle(
                                    fontSize: 16,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  prefixIcon: Icon(EneftyIcons.lock_2_outline),
                                  prefixIconColor: Colors.blue,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ///////////////////// button for save ////////////////////
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.07,
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(31, 0, 174, 255),
                                      offset: Offset(0, 10),
                                      blurRadius: 10,
                                    )
                                  ]),
                              child: Center(
                                child: Text(
                                  "สมัครสมาชิก",
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),

                            Center(
                              child: Text(
                                "มีบัญชีผู้ใช้?",
                                style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                        color: Colors.black45, fontSize: 16)),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ///////////////////// button for login ////////////////////
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()));
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.blue),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              Color.fromARGB(31, 0, 174, 255),
                                          offset: Offset(0, 10),
                                          blurRadius: 10,
                                        )
                                      ]),
                                  child: Center(
                                    child: Text(
                                      "เข้าสู่ระบบ",
                                      style: GoogleFonts.prompt(
                                        textStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
