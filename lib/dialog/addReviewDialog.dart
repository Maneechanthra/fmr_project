import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fmr_project/add/addReviewPage.dart';
import 'package:fmr_project/add/addTimeOpenClose.dart';

import 'package:image_picker/image_picker.dart';

class AddReviewDialog extends StatefulWidget {
  const AddReviewDialog({super.key});

  @override
  State<AddReviewDialog> createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends State<AddReviewDialog> {
  List<OpeningClosingTime> selectedTimes = [];
  List<File> selectedImages = [];

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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // physics: NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Dialog(
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
                            print(rating);
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
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Colors.orangeAccent),
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
                              onTap: () {},
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
    );
  }
}
