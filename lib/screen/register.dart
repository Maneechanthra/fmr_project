import 'package:flutter/material.dart';
import 'package:fmr_project/screen/login.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "สมัครสมาชิก",
          style: TextStyle(
              fontFamily: 'EkkamaiNew',
              fontWeight: FontWeight.w900,
              fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
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
            // SizedBox(
            //   height: 20,
            // ),
            const Center(
              child: Text(
                "สมัครสมาชิก",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 350,
                    height: 50,
                    child: TextFormField(
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
                    height: 20,
                  ),
                  SizedBox(
                    width: 350, // Set the width
                    height: 50, // Set the height
                    child: TextFormField(
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
                    height: 20,
                  ),
                  SizedBox(
                    width: 350, // Set the width
                    height: 50, // Set the height
                    child: TextFormField(
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
                    height: 20,
                  ),
                  SizedBox(
                    width: 350, // Set the width
                    height: 50, // Set the height
                    child: TextFormField(
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
                ],
              ),
            ),
            InkWell(
              onTap: () {
                print("สมัครสมาชิก");
              },
              child: Container(
                width: MediaQuery.sizeOf(context).width * 0.86,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Set shadow color

                      blurRadius: 7, // Set blur radius
                      offset: Offset(
                          0, 2), // Set shadow position (horizontal, vertical)
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
              width: 350,
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return const LoginPage();
                            }),
                          );
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
    );
  }
}
