import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fmr_project/api/updateName_api.dart';
import 'package:fmr_project/screen/profile.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '/globals.dart' as globals;

class EditNamePage extends StatefulWidget {
  final int userId;
  final String name;
  const EditNamePage(this.userId, this.name, {super.key});

  @override
  State<EditNamePage> createState() => _EditNamePageState();
}

class _EditNamePageState extends State<EditNamePage> {
  final _updateNameForm = GlobalKey<FormState>();
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<UpdateName> _updateName() async {
    final body = {
      'id': widget.userId.toString(),
      'name': nameController.text,
    };

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/user/edit/name'),
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
        return UpdateName.fromJson(data);
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
          "แก้ไขชื่อ-นามสกุล",
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Center(
        child: Form(
          key: _updateNameForm,
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
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    labelText: "ชื่อ-นามสกุล",
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () async {
                  if (_updateNameForm.currentState!.validate()) {
                    print("update progess");
                    UpdateName user = await _updateName();
                    print("update success");
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      text: 'บันทึกข้อมูลสำเร็จ!',
                      confirmBtnText: 'ตกลง',
                      confirmBtnColor: Color.fromARGB(255, 0, 113, 219),
                      onConfirmBtnTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (contxt) => ProfilePage(user.id)));
                        Navigator.pop(context);
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
