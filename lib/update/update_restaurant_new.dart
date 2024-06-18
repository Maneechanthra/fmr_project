import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fmr_project/add/addAddress_on_map.dart';
import 'package:fmr_project/add_new/add_opening.dart';
import 'package:fmr_project/api/addRestaurant_api.dart';
import 'package:fmr_project/api/myRestaurant_api.dart';
import 'package:fmr_project/api/update/update_restaurant_api.dart';
import 'package:fmr_project/type_category/all_type_category.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '/globals.dart' as globals;
import 'package:http/http.dart' as http;

class UpdatedRestaurantScreen extends StatefulWidget {
  final int restaurantId;
  final String restaurantName;
  final String telephone1;
  final String? telephone2;
  // final List<RestaurantCategory> selectedCategories;

  final List<Map<String, dynamic>> selectedCategories;
  final List<Map<String, dynamic>> openingList;
  final String address;
  final LatLng location;
  // final List<Map<String, dynamic>> imageUrls;
  final List<String> images;
  final int userId;

  const UpdatedRestaurantScreen(
      {required this.restaurantId,
      required this.restaurantName,
      required this.telephone1,
      required this.telephone2,
      required this.selectedCategories,
      required this.openingList,
      required this.userId,
      required this.address,
      required this.location,
      required this.images,
      super.key});

  @override
  State<UpdatedRestaurantScreen> createState() =>
      _UpdatedRestaurantScreenState();
}

class _UpdatedRestaurantScreenState extends State<UpdatedRestaurantScreen> {
  late Future<getRestaurantModelForUpdated> futureUpdatedRestaurant;
  final _updatedRestaurantForm = GlobalKey<FormState>();
  final _restaurantNameController = TextEditingController();
  final _telephone_1_Controller = TextEditingController();
  final _telephone_2_Controller = TextEditingController();
  late TextEditingController _categoryController;
  List<Map<String, dynamic>> selectedCategories = [];
  final List<File> selectedImages = [];
  String? _address;
  LatLng? _location;
  List<String?> _images = [];

  TextEditingController _openingController = TextEditingController();
  List<OpeningClosingTime> openingClosingTimes = [];
  Map<String, TimeOfDay?> TimeStartControllers = {};
  Map<String, TimeOfDay?> TimeEndControllers = {};

  final List<String> daysOfWeek = [
    'จันทร์',
    'อังคาร',
    'พุธ',
    'พฤหัสบดี',
    'ศุกร์',
    'เสาร์',
    'อาทิตย์'
  ];

  @override
  void initState() {
    futureUpdatedRestaurant = fetchUpdatedRestaurant(widget.restaurantId);
    selectedCategories = widget.selectedCategories;

    _categoryController = TextEditingController(
      text: widget.selectedCategories
          .map((category) => category['category_title'])
          .join(", "),
    );

    _restaurantNameController.text = widget.restaurantName;
    _telephone_1_Controller.text = widget.telephone1;
    _telephone_2_Controller.text = widget.telephone2 ?? '';

    // _address = widget.address;
    // _location = LatLng(
    //   double.parse(widget.location.latitude.toString()),
    //   double.parse(widget.location.longitude.toString()),
    // );

    _address = widget.address;
    if (widget.location != null) {
      _location = LatLng(
        double.parse(widget.location.latitude.toString()),
        double.parse(widget.location.longitude.toString()),
      );
    }

    _openingController.text = (widget.openingList ?? [])
        .map((time) =>
            "${time['day_open']}: ${time['time_open']} - ${time['time_close']}")
        .join("\n");

    _images = widget.images
        .map((file) => 'https://www.smt-online.com/api/public/${file}')
        .toList();

    print("Address: $_address");
    print("Location: $_location");
    print(_restaurantNameController.text);
    print(_telephone_1_Controller.text);
    print(_telephone_2_Controller.text);
    print(_openingController.text);

    super.initState();
  }

  @override
  void dispose() {
    _restaurantNameController.dispose();
    _telephone_1_Controller.dispose();
    _telephone_2_Controller.dispose();
    super.dispose();
  }

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

  Future<MyRestaurantModel> _updatedRestaurant() async {
    final Uri url =
        Uri.parse('https://www.smt-online.com/api/restaurant/updated');
    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer ${globals.jwtToken}';

    request.fields['id'] = widget.restaurantId.toString();
    request.fields['restaurant_name'] = _restaurantNameController.text;
    request.fields['telephone_1'] = _telephone_1_Controller.text;
    request.fields['telephone_2'] = _telephone_2_Controller.text;
    request.fields['created_by'] = widget.userId.toString();
    request.fields['address'] = _address!;
    request.fields['latitude'] = _location!.latitude.toString();
    request.fields['longitude'] = _location!.longitude.toString();

    print(_restaurantNameController.text);
    print(_telephone_1_Controller.text);
    print(_telephone_2_Controller.text);
    print(widget.userId.toString());
    print(_telephone_2_Controller.text);
    print(_address);
    print(_location!.longitude);

    try {
      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseJson = await response.stream.bytesToString();
        final Map<String, dynamic> data = jsonDecode(responseJson);

        final restaurantId = widget.restaurantId;
        print("restaurantId of add restaurant : " + restaurantId.toString());

        print(
            "Selected categories before calling _category: $selectedCategories");

        if (selectedCategories.isNotEmpty) {
          await _category(restaurantId);
        } else {
          print("Not category selected");
        }
        if (selectedImages.isNotEmpty) {
          await _uploadImages(restaurantId);
        }

        // if (openingClosingTimes.isNotEmpty) {
        //   await _insertTimeOpeing(restaurantId);
        // } else {
        //   print("ไม่มีข้อมูลเวลา");
        // }

        return MyRestaurantModel.fromJson(data);
      } else {
        throw Exception("Failed to add restaurant");
      }
    } catch (e) {
      print('Error: $e');
      throw Exception("An error occurred: $e");
    }
  }

//////////////////// add categories ////////////////////
  Future<void> _category(int restaurantId) async {
    final Uri url = Uri.parse(
        'https://www.smt-online.com/api/restaurant/updateCategories/$restaurantId');
    var categoryRequest = http.MultipartRequest('POST', url);
    categoryRequest.headers['Authorization'] = 'Bearer ${globals.jwtToken}';

    categoryRequest.fields['restaurant_id'] = restaurantId.toString();

    for (int i = 0; i < selectedCategories.length; i++) {
      String fieldName = 'category_data[$i][category_id]';
      var categoryId = selectedCategories[i]['id'].toString();

      categoryRequest.fields[fieldName] = categoryId;
    }

    var response = await categoryRequest.send();

    print(response.statusCode);
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to upload categories");
    } else {
      print("insert category successfully");
    }
  }

  //////////////////// upload imaged ///////////////////
  Future<void> _uploadImages(int restaurantId) async {
    final Uri url = Uri.parse(
        'https://www.smt-online.com/api/restaurant/updatedImages/$restaurantId');

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

  // Future<void> _insertTimeOpeing(int restaurantId) async {
  //   final Uri url = Uri.parse(
  //       'https://www.smt-online.com/api/restaurant/updatedOpening/$restaurantId');

  //   List<Map<String, dynamic>> openingsData = [];

  //   for (var opening in openingClosingTimes) {
  //     List<int> dayNumbers = _convertDaysToNumbers(opening.days);

  //     var openingData = {
  //       'day_open': dayNumbers[0],
  //       'time_open': TimeStartControllers[daysOfWeek[dayNumbers[0] - 1]]!
  //           .format(context),
  //       'time_close':
  //           TimeEndControllers[daysOfWeek[dayNumbers[0] - 1]]!.format(context),
  //     };

  //     openingsData.add(openingData);
  //   }

  //   var requestBody = {
  //     'restaurant_id': restaurantId.toString(),
  //     'openings': openingsData,
  //   };

  //   print("requestBody: $requestBody");
  //   var openingTimeBody = await http.post(
  //     url,
  //     headers: {
  //       'Authorization': 'Bearer ${globals.jwtToken}',
  //       'Content-Type': 'application/json',
  //     },
  //     body: jsonEncode(requestBody),
  //   );

  //   print("Response Body: ${openingTimeBody.body}");

  //   var response = jsonDecode(openingTimeBody.body);

  //   print("Response Status Code: ${response.statusCode}");

  //   if (openingTimeBody.statusCode != 200 &&
  //       openingTimeBody.statusCode != 201) {
  //     throw Exception("Failed to upload openings");
  //   } else {
  //     print("Upload openings successfully");
  //   }
  // }

  // List<int> _convertDaysToNumbers(List<String> days) {
  //   final Map<String, int> daysOfWeekMap = {
  //     'จันทร์': 1,
  //     'อังคาร': 2,
  //     'พุธ': 3,
  //     'พฤหัสบดี': 4,
  //     'ศุกร์': 5,
  //     'เสาร์': 6,
  //     'อาทิตย์': 7
  //   };

  //   return days.map((day) => daysOfWeekMap[day]!).toList();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "แก้ไขข้อมูลร้านอาหาร",
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
            key: _updatedRestaurantForm,
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
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(19, 63, 63, 63),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextFormField(
                          controller: _restaurantNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอกชื่อร้าน';
                            }
                            return null;
                          },
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
                              horizontal: 20,
                              vertical: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ////////////// telephon number 1 /////////////
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "เบอร์โทรศัพท์ 1",
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
                          controller: _telephone_1_Controller,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอกหมายเลขโทรศัพท์';
                            }
                            return null;
                          },
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
                ////////////// telephon number 2 option /////////////
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "เบอร์โทรศัพท์ 2",
                            style: GoogleFonts.kanit(
                                textStyle: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "(option)",
                            style: GoogleFonts.kanit(
                                textStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black38)),
                          ),
                        ],
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
                          controller: _telephone_2_Controller,
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

                ////////////// category of restaurant /////////////
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ประเภทร้านอาหาร",
                        style: GoogleFonts.kanit(
                            textStyle: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      InkWell(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TypeCategoryScreen(
                                  // selectedCategories: [],
                                  ),
                            ),
                          );

                          if (result != null) {
                            setState(() {
                              _categoryController.text = result
                                  .map((category) => category["name"])
                                  .join(", ");

                              print(" _categoryController : " +
                                  _categoryController.text);

                              selectedCategories = result;
                            });
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(19, 63, 63, 63),
                              borderRadius: BorderRadius.circular(12)),
                          child: TextField(
                            style: TextStyle(color: Colors.black),
                            enabled: false,
                            controller: _categoryController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Color.fromARGB(159, 96, 183, 255),
                                  width: 2.0,
                                ),
                              ),
                              hintText: "เลือกประเภทร้านอาหาร",
                              hintStyle: TextStyle(
                                fontSize: 16,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                ////////////// add opening of restaurant /////////////
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "เลือกเวลาเปิด-ปิดร้าน",
                        style: GoogleFonts.kanit(
                          textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      InkWell(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OpeningTimeScreen(),
                            ),
                          );

                          if (result != null &&
                              result is List<OpeningClosingTime>) {
                            setState(() {
                              openingClosingTimes = result;
                              _openingController.text = openingClosingTimes
                                  .map((time) => time.formattedString(context))
                                  .join("\n");
                            });
                            print(_openingController.text);
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(19, 63, 63, 63),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            style: TextStyle(color: Colors.black),
                            enabled: false,
                            controller: _openingController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Color.fromARGB(159, 96, 183, 255),
                                  width: 2.0,
                                ),
                              ),
                              hintText: "เลือกเวลาเปิด-ปิดร้าน",
                              hintStyle: TextStyle(
                                fontSize: 16,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                ////////////// address of restaurant //////////////
                SizedBox(height: 15),
                Text(
                  "ที่อยู่",
                  style: GoogleFonts.kanit(
                      textStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ),
                SizedBox(height: 5),

                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () async {
                    final address = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlaceMarkerPage(),
                      ),
                    );
                    if (address != null &&
                        address is Map<String, dynamic> &&
                        mounted) {
                      setState(() {
                        _address = address["address"];

                        _location = address["latLng"];
                      });
                    }
                  },
                  child: Center(
                    child: Text(
                      _address != null
                          ? 'ที่อยู่ร้านอาหารของฉัน: $_address + Location : $_location'
                          : 'กดที่นี่เพื่อระบุตำแหน่งร้านอาหารของคุณ',
                    ),
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
                      "ไม่เกิน 10 ภาพ",
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
                  child: widget.images.isNotEmpty || selectedImages.isNotEmpty
                      ? GridView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              widget.images.length + selectedImages.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisSpacing: 8.0,
                            crossAxisSpacing: 8.0,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            if (index < selectedImages.length) {
                              return Image.file(
                                selectedImages[index],
                                fit: BoxFit.cover,
                              );
                            } else {
                              int newIndex = index - selectedImages.length;
                              if (newIndex < widget.images.length) {
                                return Image.network(
                                  _images[newIndex]!,
                                  fit: BoxFit.cover,
                                );
                              } else {
                                return Container();
                              }
                            }
                          },
                        )
                      : Center(
                          child: Text(
                            "ยังไม่มีรูปภาพ",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black45,
                            ),
                          ),
                        ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: InkWell(
                    onTap: () {
                      _pickImages().then((_) {
                        setState(() {});
                      });
                    },
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
                    if (_updatedRestaurantForm.currentState!.validate()) {
                      MyRestaurantModel restaurant = await _updatedRestaurant();
                    }
                    print("_categoryController : " + _categoryController.text);
                    if (selectedCategories.isNotEmpty) {
                      print("มีข้อมูลประเภทร้านอาหาร" +
                          selectedCategories[0].toString());
                    } else {
                      print("ไม่มีมีข้อมูลประเภทร้านอาหาร");
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
