import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fmr_project/add/addReviewPage.dart';
import 'package:fmr_project/api/reviewRestaurant_api.dart';
import 'package:fmr_project/detail_restaurant/detail_restaurant_new.dart';
import 'package:fmr_project/login/login_new.dart';
import 'package:fmr_project/screen/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '/globals.dart' as globals;
import 'package:image_picker/image_picker.dart';

class AddReviewDialog extends StatefulWidget {
  final int restaurantId;
  final int userId;
  const AddReviewDialog(this.restaurantId, this.userId, {super.key});

  @override
  State<AddReviewDialog> createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends State<AddReviewDialog> {
  final _reviewForm = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  double ratingScore = 1.0;
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

  Future<ReviewRestaurant?> _reviewRestaurant() async {
    final Uri url = Uri.parse('https://www.smt-online.com/api/review/insert');

    var request = http.MultipartRequest('POST', url);

    request.headers['Authorization'] = 'Bearer ${globals.jwtToken}';
    request.fields['content'] = contentController.text;
    request.fields['rating'] = ratingScore.toString();
    request.fields['review_by'] = widget.userId.toString();
    request.fields['restaurant_id'] = widget.restaurantId.toString();

    print("content: " + contentController.text);
    print("rating body : " + ratingScore.toString());
    print("review_by body : " + widget.userId.toString());
    print("restaurant_id body : " + widget.restaurantId.toString());

    try {
      var response = await request.send();

      print("response statusCode: " + response.statusCode.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseJson = await response.stream.bytesToString();
        final Map<String, dynamic>? data = jsonDecode(responseJson);

        if (data == null) {
          throw Exception("Failed to parse response data");
        }

        final reviewId = data['review_id'];
        if (selectedImages != null && selectedImages!.isNotEmpty) {
          await _uploadImages(reviewId);
        }
        return ReviewRestaurant.fromJson(data);
      } else {
        throw Exception("Failed to add review");
      }
    } catch (e) {
      print('Error: $e');
      throw Exception("An error occurred: $e");
    }
  }

  Future<void> _uploadImages(int reviewId) async {
    final Uri url = Uri.parse(
        'https://www.smt-online.com/api/review/insert/insertImages/$reviewId');

    var imageRequest = http.MultipartRequest('POST', url);
    imageRequest.headers['Authorization'] = 'Bearer ${globals.jwtToken}';

    imageRequest.fields['review_id'] = reviewId.toString();

    // ตรวจสอบ selectedImages ก่อน
    if (selectedImages != null && selectedImages.isNotEmpty) {
      for (int i = 0; i < selectedImages.length; i++) {
        String fieldName = 'path[]';
        imageRequest.files.add(await http.MultipartFile.fromPath(
          fieldName,
          selectedImages[i].path,
        ));
        print(selectedImages[i].path);
      }
    } else {
      print("No images selected for upload.");
    }

    print("review id by image: " + reviewId.toString());

    try {
      var response = await imageRequest.send();

      print(response.statusCode);
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("Failed to upload images");
      }
    } catch (e) {
      print('Image upload error: $e');
      throw Exception("An error occurred while uploading images: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                      left: MediaQuery.of(context).size.width * 0.70,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.close,
                          size: 28,
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
                          style:
                              GoogleFonts.sarabun(fontWeight: FontWeight.w600),
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
                                ratingScore = rating;
                                print(ratingScore);
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
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color:
                                      const Color.fromARGB(255, 214, 214, 214)),
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
                                    AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.error,
                                        animType: AnimType.topSlide,
                                        title: "ไม่พบบัญชีผู้ใช้",
                                        desc:
                                            "ไม่พบบัญชีผู้ใช้ กรุณาสร้างบัญชีใหม่",
                                        btnOkOnPress: () {
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginScreen(),
                                            ),
                                          );
                                        }).show();
                                  } else {
                                    if (_reviewForm.currentState!.validate()) {
                                      print("progress");
                                      ReviewRestaurant? review =
                                          await _reviewRestaurant();
                                      AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.success,
                                          animType: AnimType.topSlide,
                                          title: "บันทึกข้อมูลสำเร็จ",
                                          desc: "คุณเพิ่มรีวิวร้านอาหารสำเร็จ",
                                          btnOkOnPress: () {
                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailRestaurantScreen(
                                                  restaurantId:
                                                      widget.restaurantId,
                                                  userId: widget.userId,
                                                ),
                                              ),
                                            );
                                          }).show();
                                    }

                                    print("review successfuly");
                                  }
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.400,
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
