import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';

class addReviewPage extends StatefulWidget {
  const addReviewPage({super.key});

  @override
  State<addReviewPage> createState() => _addReviewPageState();
}

class _addReviewPageState extends State<addReviewPage> {
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
            "เขียนรีวิว",
            style: TextStyle(
                fontFamily: 'EkkamaiNew',
                fontWeight: FontWeight.w900,
                fontSize: 18),
          ),
          actions: []),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "หัวเรื่องรีวิว",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 80,
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          10,
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
                      hintText: "เขียนหัวข้อรีวิวไม่เกิน 120 ตัวอักษร"),
                  maxLines: 1,
                  maxLength: 120,
                  inputFormatters: [LengthLimitingTextInputFormatter(120)],
                ),
              ),
              //================================================================
              Text(
                "รายละเอียดรีวิว",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 270,
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey), // สีขอบเทา
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: Colors.grey), // สีขอบเทาเมื่อโฟกัส
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: const Color.fromARGB(
                              255, 214, 214, 214)), // สีขอบเทาเมื่อไม่ได้โฟกัส
                    ),
                    hintText: "เขียนรายละเอียดรีวิวไม่เกิน 255 ตัวอักษร",
                  ),
                  maxLines: 8,
                  maxLength: 255,
                  inputFormatters: [LengthLimitingTextInputFormatter(255)],
                ),
              ),

              //===========================================================

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "รูปภาพ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "ไม่เกิน 10 ภาพ",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Colors.red),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
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
                padding: const EdgeInsets.only(top: 8.0, bottom: 20),
                child: InkWell(
                  onTap: _pickImages,
                  child: Container(
                    width: 380,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 221, 221, 221),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Icon(Icons.photo_camera),
                    ),
                  ),
                ),
              ),
              //===========================================================
              Text(
                "ให้คะแนนร้านอาหารนี้",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: RatingBar.builder(
                  initialRating: 1,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    size: 16,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: 330,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
                child: Center(
                  child: Text(
                    "บันทึกข้อมูล",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
