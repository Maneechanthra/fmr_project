import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fmr_project/api/reportRestaurant_api.dart';
import 'package:fmr_project/screen/login.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '/globals.dart' as globals;

class ReportDialogPage extends StatefulWidget {
  final int? userId;
  final restaurantId;
  const ReportDialogPage(this.userId, this.restaurantId, {Key? key})
      : super(key: key);

  @override
  State<ReportDialogPage> createState() => _ReportDialogPageState();
}

List<String> _optionreport = [
  'ภาพไม่เหมาะสม',
  'เนื้อหาไม่เหมาะสม',
  'ตำแหน่งของร้านไม่ถูกต้อง',
];

class _ReportDialogPageState extends State<ReportDialogPage> {
  final _reportForm = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  @override
  void initState() {
    super.initState();
    print("restaurantId of report : " + widget.restaurantId.toString());
    print("userId of report : " + widget.userId.toString());
  }

  Future<ReportRestaurant?> reportRestaurant() async {
    final body = {
      'title': currentOptionReport,
      'descriptions': descriptionController.text,
      'report_by': widget.userId.toString(),
      'restaurant_id': widget.restaurantId.toString(),
    };

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/report/insert'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '*/*',
        'connection': 'keep-alive',
        'Authorization': 'Bearer ' + globals.jwtToken,
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic>? data = jsonDecode(response.body);
      if (data != null) {
        return ReportRestaurant.fromJson(data);
      } else {
        throw Exception('failed to decode json data');
      }
    } else {
      throw Exception('failed to report restaurant');
    }
  }

  String currentOptionReport = 'ภาพไม่เหมาะสม';
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Form(
        key: _reportForm,
        child: Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Dialog(
            child: Container(
                height: 490,
                width: 600,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Stack(
                  children: [
                    Positioned(
                        top: 0,
                        left: 290,
                        // bottom: 530,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.close,
                            size: 40,
                            color: Colors.red,
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "รายงาน",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'EkkamaiNew',
                              ),
                            ),
                          ),
                          Divider(),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "โปรดเลือกปัญหา",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "โปรดเลือกตัวเลือกที่เกี่ยวข้องมากที่สุด",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            width: 250,
                            child: DropdownButton<String>(
                              value: currentOptionReport,
                              items: _optionreport.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  currentOptionReport = newValue!;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "คำอธิบายเพิ่มเติม",
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: descriptionController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 92, 92, 92)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                      color: const Color.fromARGB(
                                          255, 216, 216, 216)),
                                ),
                                hintText: "เขียนอธิบายปัญหาที่คุณพบ",
                                hintStyle: TextStyle(fontSize: 13)),
                            maxLength: 120,
                            maxLines: 5,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(120),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () async {
                              if (widget.userId == null || widget.userId == 0) {
                                if (widget.userId == 0) {
                                  QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.warning,
                                    text: 'กรุณาเข้าสู่ระบบเพื่อใช้ฟังก์ชันนี้',
                                    confirmBtnText: 'ตกลง',
                                    confirmBtnColor:
                                        Color.fromARGB(255, 0, 113, 219),
                                    // onConfirmBtnTap: () {
                                    //   Navigator.push(
                                    //       context,
                                    //       MaterialPageRoute(
                                    //           builder: (context) =>
                                    //               LoginPage()));
                                    // },
                                  );
                                }
                              } else {
                                if (_reportForm.currentState!.validate()) {
                                  print("Progress");
                                  ReportRestaurant? report =
                                      await reportRestaurant();
                                  print("report successfully");
                                  QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.success,
                                    text: 'บันทึกข้อมูลสำเร็จ!',
                                    confirmBtnText: 'ตกลง',
                                    confirmBtnColor:
                                        Color.fromARGB(255, 0, 113, 219),
                                    onConfirmBtnTap: () {
                                      Navigator.pop(context);
                                    },
                                  );
                                  // AwesomeDialog(
                                  //   context: context,
                                  //   animType: AnimType.topSlide,
                                  //   dialogType: DialogType.success,
                                  //   title: 'บันทึกข้อมูลสำเร็จ',
                                  //   titleTextStyle: TextStyle(
                                  //       fontWeight: FontWeight.bold,
                                  //       fontSize: 20),
                                  //   btnOkOnPress: () {
                                  //     // Navigator.push(
                                  //     //   context,
                                  //     //   MaterialPageRoute(
                                  //     //     builder: (context) => LoginPage(),
                                  //     //   ),
                                  //     // );
                                  //   },
                                  // ).show();
                                }
                              }
                            },
                            child: Container(
                              width: 280,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blue,
                              ),
                              child: Center(
                                child: Text(
                                  "บันทึกข้อมูล",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
