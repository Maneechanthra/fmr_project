import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fmr_project/api/updateEmail_api.dart';
import 'package:fmr_project/screen/profile.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '/globals.dart' as globals;
import 'package:http/http.dart' as http;

class EditEmailPage extends StatefulWidget {
  final int userId;
  final String email;
  const EditEmailPage(this.userId, this.email, {super.key});

  @override
  State<EditEmailPage> createState() => _EditEmailPageState();
}

class _EditEmailPageState extends State<EditEmailPage> {
  final _updateEmailForm = GlobalKey<FormState>();
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: widget.email);
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  Future<UpdateEmail> _updateEmail() async {
    final body = {
      'id': widget.userId.toString(),
      'email': emailController.text,
    };

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/user/edit/email'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': "*/*",
        'connection': 'keep-alive',
        'Authorization': 'Bearer ' + globals.jwtToken,
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic>? data = jsonDecode(response.body);

      if (data != null) {
        return UpdateEmail.fromJson(data);
      } else {
        throw Exception('Failed to decode JSON data');
      }
    } else {
      throw Exception('Failed to update name.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "แก้ไขอีเมล",
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Center(
        child: Form(
          key: _updateEmailForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 330,
                height: 50,
                child: TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    labelText: "อีเมล",
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () async {
                  if (_updateEmailForm.currentState!.validate()) {
                    print("progress");
                    UpdateEmail user = await _updateEmail();
                    print("success");
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      text: 'บันทึกข้อมูลสำเร็จ!',
                      confirmBtnText: 'ตกลง',
                      confirmBtnColor: Color.fromARGB(255, 0, 113, 219),
                      onConfirmBtnTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (contxt) => ProfilePage(user.id)));
                      },
                    );
                  }
                },
                child: Container(
                  width: 330,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: const Center(
                      child: Text(
                    "บันทึกข้อมูล",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
