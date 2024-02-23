import 'package:flutter/material.dart';
import 'package:fmr_project/screen/forgotpassword.dart';
import 'package:fmr_project/screen/home.dart';
import 'package:fmr_project/screen/register.dart';

import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "เข้าสู่ระบบ",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            Center(
              child: Image.asset(
                "assets/img/logo/logo.png",
                width: 100,
              ),
            ),
            Text(
              "FMRestaurant",
              style: GoogleFonts.mitr(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            Text(
              "เข้าสู่ระบบ",
              style:
                  GoogleFonts.mitr(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.9,
              height: 50,
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.9,
              height: 50,
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: "Password",
                  prefixIcon: Icon(Icons.password_rounded),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
              child: Container(
                width: MediaQuery.sizeOf(context).width * 0.9,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: const Center(
                    child: Text(
                  "เข้าสู่ระบบ",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                )),
              ),
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.95,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPasswordPage()));
                    },
                    child: Text(
                      "ลืมรหัสผ่าน",
                      style: GoogleFonts.mitr(color: Colors.black45),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "ยังไม่มีบัญชีผู้ใช้?",
                        style: GoogleFonts.mitr(color: Colors.black45),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return RegisterPage();
                              }),
                            );
                          },
                          child: Text(
                            "สมัครสมาชิก",
                            style: GoogleFonts.mitr(color: Colors.blue),
                          ))
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
