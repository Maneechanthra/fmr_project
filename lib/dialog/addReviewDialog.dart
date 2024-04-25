import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fmr_project/add/addReviewPage.dart';
import 'package:fmr_project/add/addTimeOpenClose.dart';
import 'package:fmr_project/api/reviewRestaurant_api.dart';
import 'package:fmr_project/screen/login.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '/globals.dart' as globals;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

class AddReviewDialog extends StatefulWidget {
  final int restaurantId;
  final int userId;
  const AddReviewDialog(this.restaurantId, this.userId, {super.key});

  @override
  State<AddReviewDialog> createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends State<AddReviewDialog> {
  // List<OpeningClosingTime> selectedTimes = [];
  final _reviewForm = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final rating = 1;
  final List<File> selectedImages = [];

  Future<void> _pickImages() async {
    List<XFile>? images = await ImagePicker().pickMultiImage(
      imageQuality: 80,
      maxWidth: 500,
      maxHeight: 500,
    );

    if (images != null) {
      if (selectedImages.length + images.length > 10) {
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
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
  }

  @override
  void initState() {
    super.initState();
    print("restaurantId : " + widget.restaurantId.toString());
  }

  Future<ReviewRestaurant> _reviewRestaurant() async {
    final Uri url = Uri.parse('http://10.0.2.2:8000/api/review/insert');

    // สร้าง MultipartRequest เพื่อส่งข้อมูล
    var request = http.MultipartRequest('POST', url);

    request.headers['Authorization'] = 'Bearer ${globals.jwtToken}';

    // เพิ่มข้อมูลรีวิว
    request.fields['content'] = contentController.text;
    request.fields['rating'] = rating.toString();
    request.fields['review_by'] = widget.userId.toString();
    request.fields['restaurant_id'] = widget.restaurantId.toString();

    try {
      // ส่งรีวิวเพื่อรับ review_id
      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseJson = await response.stream.bytesToString();
        final Map<String, dynamic> data = jsonDecode(responseJson);

        final reviewId = data['review_id']; // รับ review_id ที่สร้างใหม่

        // สร้าง MultipartRequest ใหม่เพื่ออัปโหลดรูปภาพพร้อม review_id
        var imageRequest = http.MultipartRequest('POST', url);

        imageRequest.headers['Authorization'] = 'Bearer ${globals.jwtToken}';
        imageRequest.fields['review_id'] =
            reviewId.toString(); // เพิ่ม review_id

        // เพิ่มไฟล์รูปภาพ
        for (File image in selectedImages) {
          imageRequest.files.add(await http.MultipartFile.fromPath(
            'path', // ชื่อ field ที่สอดคล้องกับ backend
            image.path,
          ));
        }

        // ส่งคำขอใหม่เพื่ออัปโหลดรูปภาพ
        var imageResponse = await imageRequest.send();

        if (imageResponse.statusCode == 200 ||
            imageResponse.statusCode == 201) {
          return ReviewRestaurant.fromJson(data); // ส่งกลับข้อมูลรีวิว
        } else {
          throw Exception(
              "Failed to upload images"); // ข้อผิดพลาดในการอัปโหลดรูปภาพ
        }
      } else {
        throw Exception("Failed to add review"); // ข้อผิดพลาดในการสร้างรีวิว
      }
    } catch (e) {
      // จัดการข้อผิดพลาด
      print('Error: $e');
      throw Exception("An error occurred: $e"); // แจ้งข้อผิดพลาด
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // physics: NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Dialog(
          child: Form(
            key: _reviewForm,
            child: Container(
              width: 700,
              height: 570,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Stack(
                children: [
                  Positioned(
                      top: 3,
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
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                            child: Text(
                          "ให้คะแนนร้านนี้",
                          style: TextStyle(
                              fontFamily: 'EkkamaiNew',
                              fontWeight: FontWeight.w900),
                        )),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: RatingBar.builder(
                            initialRating: 1,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              setState(() {
                                rating = rating;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 17,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "เขียนรีวิว",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: contentController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:
                                  BorderSide(color: Colors.orangeAccent),
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
                            hintText: "เขียนรีวิวสั้น ๆ",
                          ),
                          maxLength: 150,
                          maxLines: 5,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(150),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "รูปภาพ",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "ไม่เกิน 10 ภาพ",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red),
                            )
                          ],
                        ),
                        Container(
                          height: 80,
                          child: GridView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: selectedImages.length > 0
                                ? selectedImages.length
                                : 1,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              mainAxisSpacing: 8.0,
                              crossAxisSpacing: 8.0,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              if (selectedImages.length > 0) {
                                return Image.file(
                                  selectedImages[index],
                                  fit: BoxFit.cover,
                                );
                              } else {
                                // Display a message when there are no selected images
                                return Center(
                                  child: Text(
                                    "ยังไม่มีรูปภาพ",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black45),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: InkWell(
                            onTap: _pickImages,
                            child: Container(
                              width: 380,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 241, 241, 241),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Icon(
                                Icons.photo_camera,
                                color: const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const addReviewPage()));
                                },
                                child: Container(
                                  width: 100,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 255, 166, 0),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                      child: Text(
                                    "เขียนเพิ่มเติม",
                                    style: TextStyle(color: Colors.white),
                                  )),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                onTap: () async {
                                  if (widget.userId == null ||
                                      widget.userId == 0) {
                                    QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.warning,
                                      text: 'ยังไม่ได้เข้าสู่ระบบ!',
                                      confirmBtnText: 'ตกลง',
                                      confirmBtnColor:
                                          Color.fromARGB(255, 0, 113, 219),
                                      onConfirmBtnTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (contxt) =>
                                                    LoginPage()));
                                      },
                                    );
                                  }
                                  if (_reviewForm.currentState!.validate()) {
                                    print("progress");
                                    ReviewRestaurant review =
                                        await _reviewRestaurant();
                                  }
                                  print("review successfuly");
                                },
                                child: Container(
                                  width: 145,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 0, 153, 255),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                      child: Text(
                                    "โพสต์",
                                    style: TextStyle(color: Colors.white),
                                  )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
