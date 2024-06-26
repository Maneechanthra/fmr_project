import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fmr_project/api/login_api.dart';
import 'package:fmr_project/bottom_navigator/bottom_navigator.dart';
import 'package:fmr_project/bottom_navigator/bottom_navigator_new.dart';
import 'package:fmr_project/forgot_password/forgotpassword.dart';
import 'package:fmr_project/screen/home.dart';
import 'package:fmr_project/screen/register.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import '/globals.dart' as globals;

import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  // final int userId;
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginForm = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  Future<LoginResponse> verifyLogin() async {
    final body = {
      'email': emailController.text,
      'password': passwordController.text
    };

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': "*/*",
        'connection': 'keep-alive',
        'Authorization': 'Bearer ' + globals.jwtToken,
      },
      body: jsonEncode(body),
    );

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      final Map<String, dynamic>? data = jsonDecode(response.body);

      if (data != null) {
        return LoginResponse.fromJson(data);
      } else {
        throw Exception('Failed to decode JSON data');
      }
    } else {
      throw Exception('Failed to Login.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 0,
        // title: Text(
        //   "เข้าสู่ระบบ",
        //   style: TextStyle(
        //       fontWeight: FontWeight.w900, fontSize: 18, color: Colors.black),
        // ),
        // centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _loginForm,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              // Center(
              //   child: Image.asset(
              //     "assets/img/logo/logo.png",
              //     width: 100,
              //   ),
              // ),
              // Text(
              //   "FMRestaurant",
              //   style: GoogleFonts.mitr(
              //       fontSize: 30,
              //       fontWeight: FontWeight.bold,
              //       color: Colors.blue),
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/img/logo/logo.png",
                      width: 100,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "เข้าสู่ระบบ",
                        style: TextStyle(
                          fontSize: 40,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "กรุณาเข้าสู่ระบบหรือสมัครสมาชิกเพื่อเข้าใช้งานแอปพลิเคชัน",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.85,
                // height: 30,
                child: TextFormField(
                  controller: emailController,
                  onChanged: (String value) {},
                  validator: (value) {
                    return value!.isEmpty ? "กรุณากรอกอีเมล" : null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    labelText: "อีเมล",
                    labelStyle: TextStyle(fontSize: 14),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15),
                    helperText: "ex. user@gmail.com",
                    // prefixIcon: Icon(Icons.email),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.85,
                child: TextFormField(
                  controller: passwordController,
                  onChanged: (String value) {},
                  validator: (value) {
                    return value!.isEmpty ? "กรุณากรอกรหัสผ่าน" : null;
                  },
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    labelText: "รหัสผ่าน",
                    labelStyle: TextStyle(fontSize: 14),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15),

                    // prefixIcon: Icon(Icons.password_rounded),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 200,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotPasswordPage()));
                      },
                      child: Text(
                        "ลืมรหัสผ่าน?",
                        style: GoogleFonts.prompt(color: Colors.black45),
                      ),
                    ),
                  ],
                ),
              ),
              // const SizedBox(
              //   height: 20,
              // ),
              InkWell(
                onTap: () async {
                  if (_loginForm.currentState!.validate()) {
                    LoginResponse response = await verifyLogin();
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      text: 'เข้าสู่ระบบสำเร็จ!',
                      confirmBtnText: 'ตกลง',
                      confirmBtnColor: Color.fromARGB(255, 0, 113, 219),
                      onConfirmBtnTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BottomNavigatorScreen(
                                      userId: response.userId,
                                      indexPage: 0,
                                    )));
                      },
                    );
                    globals.isLoggedIn = true;
                    globals.jwtToken = response.jwtToken;
                    print(response.userId);
                    print(response.jwtToken);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("กรอกข้อมูลไม่ครบถ้วนหรือไม่ถูกต้อง"),
                    ));
                  }
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.85,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  child: const Center(
                      child: Text(
                    "เข้าสู่ระบบ",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  )),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "ยังไม่มีบัญชีผู้ใช้?",
                    style: GoogleFonts.prompt(color: Colors.black45),
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
                        style: GoogleFonts.prompt(color: Colors.blue),
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
