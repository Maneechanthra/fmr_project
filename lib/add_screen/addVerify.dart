import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class VerifyRestaurantPage extends StatefulWidget {
  const VerifyRestaurantPage({super.key});

  @override
  State<VerifyRestaurantPage> createState() => _VerifyRestaurantPageState();
}

class _VerifyRestaurantPageState extends State<VerifyRestaurantPage> {
  String selectedDay = 'ทุกวัน';
  String openingTime = '';
  String closingTime = '';
  List<String> daysOfWeek = [
    'ทุกวัน',
    'วันจันทร์',
    'วันอังคาร',
    'วันพุธ',
    'วันพฤหัสบดี',
    'วันศุกร์',
    'วันเสาร์',
    'วันอาทิตย์'
  ];

  List<File> selectedImages = [];

  Future<void> _pickImages() async {
    List<XFile>? images = await ImagePicker().pickMultiImage(
      imageQuality: 80,
      maxWidth: 800,
      maxHeight: 800,
    );

    if (images != null) {
      if (selectedImages.length + images.length > 10) {
        // แจ้งเตือนว่าไม่สามารถเลือกรูปภาพมากกว่า 10 รูปได้
        // ในตัวอย่างนี้เราให้แสดง AlertDialog แสดงข้อความแจ้งเตือน
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('แจ้งเตือน'),
              content: Text('ไม่สามารถเลือกรูปภาพมากกว่า 10 รูปได้'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('ตกลง'),
                ),
              ],
            );
          },
        );
      } else {
        setState(() {
          selectedImages.addAll(images.map((image) => File(image.path)));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ยืนยันตัวตน",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "ชื่อร้าน:",
                    style: TextStyle(
                        fontFamily: 'EkkamaiNew',
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                  SizedBox(width: 95),
                  Expanded(
                    child: SizedBox(
                        height: 50,
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      Colors.blue), // Change the border color
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.grey), // สีขอบเทาเมื่อโฟกัส
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: const Color.fromARGB(255, 214, 214,
                                      214)), // สีขอบเทาเมื่อไม่ได้โฟกัส
                            ),
                            labelText: "ชื่อร้าน",
                            labelStyle: TextStyle(
                                color: Color.fromARGB(255, 190, 190,
                                    190)), // Change the label text color
                          ),
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    "ประเภทร้านอาหาร: ",
                    style: TextStyle(
                        fontFamily: 'EkkamaiNew',
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: SizedBox(
                        height: 50,
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      Colors.blue), // Change the border color
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.grey), // สีขอบเทาเมื่อโฟกัส
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: const Color.fromARGB(255, 214, 214,
                                      214)), // สีขอบเทาเมื่อไม่ได้โฟกัส
                            ),
                            labelText: "ประเภทร้านอาหาร",
                            labelStyle: TextStyle(
                                color: Color.fromARGB(255, 190, 190,
                                    190)), // Change the label text color
                          ),
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    "ชื่อ-นามสกุล:           ",
                    style: TextStyle(
                        fontFamily: 'EkkamaiNew',
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: SizedBox(
                        height: 50,
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      Colors.blue), // Change the border color
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.grey), // สีขอบเทาเมื่อโฟกัส
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: const Color.fromARGB(255, 214, 214,
                                      214)), // สีขอบเทาเมื่อไม่ได้โฟกัส
                            ),
                            labelText: "ชื่อ-นามสกุล ผู้ขอยืนยันตัวตน",
                            labelStyle: TextStyle(
                                color: Color.fromARGB(255, 190, 190,
                                    190)), // Change the label text color
                          ),
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "รูปภาพ/หลักฐานยืนยันตัวตน",
                    style: TextStyle(
                        fontFamily: 'EkkamaiNew',
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                  Text(
                    "ไม่เกิน 5 ภาพ",
                    style: TextStyle(
                        fontFamily: 'EkkamaiNew',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.red),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 100,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: selectedImages.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return Image.file(
                      selectedImages[index],
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: InkWell(
                  onTap: _pickImages,
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 0.93,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 218, 218, 218),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Icon(Icons.photo_camera_outlined),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        Container(
          height: 80,
          width: double.infinity,
          child: ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  height: 100,
                  width: 330,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue,
                  ),
                  child: Center(
                    child: Text(
                      "บันทึกข้อมูล",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
