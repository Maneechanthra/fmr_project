import 'package:flutter/material.dart';
import 'package:fmr_project/update/changepassword.dart';

class LogoutPgae extends StatefulWidget {
  const LogoutPgae({super.key});

  @override
  State<LogoutPgae> createState() => _LogoutPgaeState();
}

class _LogoutPgaeState extends State<LogoutPgae> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
              SizedBox(
                height: 300,
              ),
              Text(
                "สมัครสมาชิก/เข้าสู่ระบบ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blue),
                child: Center(
                  child: Text(
                    "สมัครสมาชิก/เข้าสู่ระบบ",
                    style: TextStyle(color: Colors.white),
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
