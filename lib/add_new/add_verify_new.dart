import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fmr_project/add/addAddress_on_map.dart';
import 'package:fmr_project/add_new/add_opening.dart';
import 'package:fmr_project/api/addCategory_api.dart';
import 'package:fmr_project/api/addRestaurant_api.dart';
import 'package:fmr_project/api/verified/verified_api.dart';
import 'package:fmr_project/detail_page/all_typerestaurant.dart';
import 'package:fmr_project/my_restaurant/myRestaurant.dart';
import 'package:fmr_project/type_category/all_type_category.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '/globals.dart' as globals;
import 'package:http/http.dart' as http;

class AddVerifyScreen extends StatefulWidget {
  final int userId;
  final String userName;
  final String restaurantName;
  final int restaurantid;

  const AddVerifyScreen(
      {required this.userId,
      required this.userName,
      required this.restaurantName,
      required this.restaurantid,
      super.key});

  @override
  State<AddVerifyScreen> createState() => _AddVerifyScreenState();
}

class _AddVerifyScreenState extends State<AddVerifyScreen> {
  final _addVerify = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _restaurantNameController = TextEditingController();

  final List<File> selectedImages = [];

  Map<String, TimeOfDay?> TimeStartControllers = {};
  Map<String, TimeOfDay?> TimeEndControllers = {};

  @override
  void initState() {
    _nameController.text = widget.userName;
    _restaurantNameController.text = widget.restaurantName;
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _restaurantNameController.dispose();

    super.dispose();
  }

  Future<void> _pickImages() async {
    List<XFile>? images = await ImagePicker().pickMultiImage(
      imageQuality: 80,
      maxWidth: 500,
      maxHeight: 500,
    );

    if (images != null) {
      if (selectedImages.length + images.length > 3) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('แจ้งเตือน'),
              content: Text('ไม่สามารถเลือกรูปภาพมากกว่า 3 รูปได้'),
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

  //////////////////// future add restaurant /////////////////////
  Future<VerifiedModel> _verifiedResturant(int restaurantId) async {
    final Uri url =
        Uri.parse('http://10.0.2.2:8000/api/verified/insert/$restaurantId');
    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer ${globals.jwtToken}';
    // request.fields['restaurant_name'] = _nameController.text;
    // request.fields['telephone_1'] = _restaurantNameController.text;
    // request.fields['created_by'] = widget.userId.toString();
    request.fields['updated_by'] = widget.userId.toString();

    try {
      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseJson = await response.stream.bytesToString();
        final Map<String, dynamic> data = jsonDecode(responseJson);

        final restaurantId = data['restaurant_id'];
        print("restaurantId of add restaurant : " + restaurantId.toString());

        if (selectedImages.isNotEmpty) {
          await _uploadImages(restaurantId);
        }

        return VerifiedModel.fromJson(data);
      } else {
        throw Exception("Failed to add restaurant");
      }
    } catch (e) {
      print('Error: $e');
      throw Exception("An error occurred: $e");
    }
  }

  //////////////////// upload imaged ///////////////////
  Future<void> _uploadImages(int restaurantId) async {
    final Uri url = Uri.parse(
        'http://10.0.2.2:8000/api/verified/insertImages/$restaurantId');

    var imageRequest = http.MultipartRequest('POST', url);
    imageRequest.headers['Authorization'] = 'Bearer ${globals.jwtToken}';

    imageRequest.fields['restaurant_id'] = restaurantId.toString();
    for (int i = 0; i < selectedImages.length; i++) {
      String fieldName = 'path[]';
      imageRequest.files.add(await http.MultipartFile.fromPath(
        fieldName,
        selectedImages[i].path,
      ));
      print(
        selectedImages[i].path,
      );
    }

    var response = await imageRequest.send();

    print(response.statusCode);
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to upload images");
    } else {
      print("upload image successfully");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "คำร้องขอสถานะรับรองร้านอาหาร",
          style: GoogleFonts.prompt(
            textStyle: TextStyle(fontSize: 16),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Form(
            key: _addVerify,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ////////////// restaurant name /////////////
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ชื่อร้าน Restaurant Name",
                        style: GoogleFonts.kanit(
                            textStyle: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(19, 63, 63, 63),
                            borderRadius: BorderRadius.circular(12)),
                        child: TextFormField(
                          controller: _restaurantNameController,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'กรุณากรอกชื่อร้าน';
                          //   }
                          //   return null;
                          // },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Color.fromARGB(159, 96, 183, 255),
                                width: 2.0,
                              ),
                            ),
                            hintText: "กรอกชื่อร้านอาหาร",
                            hintStyle: TextStyle(
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ////////////// เจ้าของร้าน /////////////
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "เจ้าของร้าน",
                        style: GoogleFonts.kanit(
                            textStyle: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(19, 63, 63, 63),
                            borderRadius: BorderRadius.circular(12)),
                        child: TextFormField(
                          controller: _nameController,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'กรุณากรอกชื่อ-เจ้าของร้าน';
                          //   }
                          //   return null;
                          // },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Color.fromARGB(159, 96, 183, 255),
                                width: 2.0,
                              ),
                            ),
                            hintText: "กรอกหมายเลขโทรศัพท์",
                            hintStyle: TextStyle(
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //////////////////////// images for add restaurant //////////////////////////
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "รูปภาพ",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "ไม่เกิน 3 ภาพ",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.red),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 80,
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        selectedImages.length > 0 ? selectedImages.length : 1,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                            style:
                                TextStyle(fontSize: 12, color: Colors.black45),
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
                SizedBox(
                  height: 15,
                ),
                ////////////// button for save /////////////
                GestureDetector(
                  onTap: () async {
                    if (_addVerify.currentState!.validate()) {
                      VerifiedModel restaurant =
                          await _verifiedResturant(widget.restaurantid);
                      print("register successfully");
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.success,
                        animType: AnimType.topSlide,
                        title: "บันทึกข้อมูลสำเร็จ",
                        desc: "คุณได้ส่งคำร้องขอสถานะรับรองร้านอาหารแล้ว",
                        btnOkOnPress: () {
                          // Navigator.of(context).pushReplacement(
                          //   MaterialPageRoute(
                          //     builder: (context) => MyRestaurantScreen(
                          //       uesrId: widget.userId,
                          //     ),
                          //   ),
                          //   // (Route<dynamic> route) => false,
                          // );
                          Navigator.pop(context);
                        },
                      ).show();
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.06,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        "บันทึกข้อมูล",
                        style: GoogleFonts.kanit(
                            textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        )),
                      ),
                    ),
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
