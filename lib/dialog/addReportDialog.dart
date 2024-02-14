import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReportDialogPage extends StatefulWidget {
  const ReportDialogPage({super.key});

  @override
  State<ReportDialogPage> createState() => _ReportDialogPageState();
}

List<String> _optionreport = [
  'ภาพไม่เหมาะสม',
  'เนื้อหาไม่เหมาะสม',
  'ตำแหน่งของร้านไม่ถูกต้อง',
  'อื่น ๆ'
];

class _ReportDialogPageState extends State<ReportDialogPage> {
  String currentOptionReport = 'ภาพไม่เหมาะสม';
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 80.0),
        child: Dialog(
          child: Container(
              height: 480,
              width: 600,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Stack(
                children: [
                  Positioned(
                      top: 3,
                      left: 240,
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
                          height: 10,
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
                        Container(
                          width: 280,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue,
                          ),
                          child: Center(
                            child: Text(
                              "บันทึกข้อมูล",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
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
    );
  }
}
