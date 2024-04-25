import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fmr_project/api/register_api.dart';
import 'package:fmr_project/screen/home.dart';
import 'package:fmr_project/screen/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '/globals.dart' as globals;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerForm = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<Register> register() async {
    final body = {
      'name': nameController.text,
      'email': emailController.text,
      'password': passwordController.text
    };

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '*/*',
        'connection': 'keep-alive',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic>? data = jsonDecode(response.body);
      if (data != null) {
        return Register.fromJson(data);
      } else {
        throw Exception('failed to decode json data');
      }
    } else {
      throw Exception('failed to register');
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
        title: Text(
          "สมัครสมาชิก",
          style: TextStyle(
              fontWeight: FontWeight.w900, fontSize: 18, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Image.asset(
                "assets/img/logo/logo.png",
                width: 100,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Form(
                key: _registerForm,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      child: TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        onChanged: (String value) {},
                        validator: (value) {
                          return value!.isEmpty
                              ? "กรุณากรอกชื่อ-นามสกุล"
                              : null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          labelText: "ชื่อ-นามสกุล",
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 1,
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (String value) {},
                        validator: (value) {
                          return value!.isEmpty ? "กรุณากรอกอีเมล" : null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          labelText: "อีเมล",
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 1,
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: (String value) {},
                        validator: (value) {
                          return value!.isEmpty ? "กรุณากรอกรหัสผ่าน" : null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          labelText: "รหัสผ่าน",
                          prefixIcon: Icon(
                            Icons.key,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 1,
                      child: TextFormField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: (String value) {},
                        validator: (value) {
                          return value!.isEmpty
                              ? "กรุณากรอกยืนยันรหัสผ่าน"
                              : null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          labelText: "ยืนยันรหัสผ่าน",
                          prefixIcon: Icon(
                            Icons.key_rounded,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () async {
                        if (passwordController.text ==
                            confirmPasswordController.text) {
                          print("รหัสผ่านตรงกัน");
                          if (_registerForm.currentState!.validate()) {
                            print("Register Progress");
                            Register data = await register();
                            print("register successfully");
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.success,
                              text: 'สมัครสมาชิกสำเร็จ!',
                              confirmBtnText: 'ตกลง',
                              confirmBtnColor: Color.fromARGB(255, 0, 113, 219),
                              onConfirmBtnTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (contxt) => LoginPage()));
                              },
                            );
                            // PanaraInfoDialog.showAnimatedGrow(
                            //   context,
                            //   title: "สมัครสมาชิกสำเร็จ",
                            //   message: "กดตกลง เพื่อกลับไปยังหน้าแรก",
                            //   buttonText: "ตกลง",
                            //   onTapDismiss: () {
                            //     Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //             builder: (contxt) => LoginPage()));
                            //   },
                            //   panaraDialogType: PanaraDialogType.normal,
                            //   barrierDismissible:
                            //       false, // optional parameter (default is true)
                            // );
                            // AwesomeDialog(
                            //   context: context,
                            //   animType: AnimType.topSlide,
                            //   dialogType: DialogType.success,
                            //   title: 'สมัครสมาชิกสำเร็จ',
                            //   titleTextStyle: TextStyle(
                            //       fontWeight: FontWeight.bold, fontSize: 20),
                            //   btnOkOnPress: () {
                            //     // Navigator.push(
                            //     //   context,
                            //     //   MaterialPageRoute(
                            //     //     builder: (context) => LoginPage(),
                            //     //   ),
                            //     // );
                            //   },
                            // ).show();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("รหัสผ่านไม่ตรงกัน"),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text("กรอกข้อมูลไม่ครบถ้วนหรือไม่ถูกต้อง"),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 1,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 7,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                            child: Text(
                          "สมัครสมาชิก",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 1,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 1, right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "มีบัญชีผู้ใช้แล้ว",
                              style: GoogleFonts.mitr(color: Colors.black45),
                            ),
                            TextButton(
                                onPressed: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(builder: (context) {
                                  //     return LoginPage();
                                  //   }),
                                  // );
                                },
                                child: Text(
                                  "เข้าสู่ระบบ",
                                  style: GoogleFonts.mitr(color: Colors.blue),
                                ))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
