import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fmr_project/add/addAddress_on_map.dart';
import 'package:fmr_project/add/addTimeOpenClose.dart';
import 'package:fmr_project/api/addCategory_api.dart';
import 'package:fmr_project/api/addRestaurant_api.dart';
import 'package:fmr_project/api/restaurantById_api.dart';
import 'package:fmr_project/detail_page/all_typerestaurant.dart';
import 'package:fmr_project/screen/profile.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '/globals.dart' as globals;
import 'package:http/http.dart' as http;

class AddResPage extends StatefulWidget {
  final List<Map<String, dynamic>> selectedCategories;
  final List<OpeningClosingTime> selectedTimes;
  final int userId;
  const AddResPage(
      {Key? key,
      required this.selectedCategories,
      required this.selectedTimes,
      required this.userId})
      : super(key: key);

  @override
  State<AddResPage> createState() => _AddResPageState();
}

class _AddResPageState extends State<AddResPage> {
  late LatLng _latLng = LatLng(17.2667199760001, 104.134101002072);
  String? _address;

  final _addRestaurantPage = GlobalKey<FormState>();
  final restaurantName = TextEditingController();
  final telephone1 = TextEditingController();
  final telephone2 = TextEditingController();

  List<File> selectedImages = [];
  List<Map<String, dynamic>> selectedCategories = [];
  List<Map<String, dynamic>> selectedTimes = [];

  late TextEditingController _controller;
  late TextEditingController _dayTimeController;

  Future<void> _pickImages() async {
    List<XFile>? images = await ImagePicker().pickMultiImage(
      imageQuality: 80,
      maxWidth: 800,
      maxHeight: 800,
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
  void initState() {
    super.initState();
    selectedCategories = widget.selectedCategories;
    selectedTimes = widget.selectedTimes
        .map((time) => {
              'days': time.days,
              'openingTime':
                  '${time.openingTime.hourOfPeriod}:${time.openingTime.minute} ${time.openingTime.period == DayPeriod.am ? 'AM' : 'PM'}',
              'closingTime':
                  '${time.closingTime.hourOfPeriod}:${time.closingTime.minute} ${time.closingTime.period == DayPeriod.am ? 'AM' : 'PM'}',
            })
        .toList();

    print(selectedTimes);
    _controller = TextEditingController(
      text: widget.selectedCategories
          .map((category) => category["name"])
          .join(", "),
    );
    _dayTimeController = TextEditingController(
      text: selectedTimes.isNotEmpty ? jsonEncode(selectedTimes) : "",
    );

    print("วันเวลาเปิดปิดร้าน : " + _dayTimeController.toString());
    print(widget.selectedTimes);
    print("userId from Profile screen : " + widget.userId.toString());
  }

  Future<AddRestaurantModel?> _addRestaurant() async {
    final Uri url = Uri.parse('http://10.0.2.2:8000/api/restaurant/insert');

    var request = http.MultipartRequest('POST', url);

    request.headers['Authorization'] = 'Bearer ${globals.jwtToken}';

    request.fields['restaurant_name'] = restaurantName.text;
    // request.fields['address'] = _address!;
    request.fields['telephone_1'] = telephone1.text;
    request.fields['telephone_2'] = telephone2.text;
    // request.fields['latitude'] = _latLng.latitude.toString();
    // request.fields['longitude'] = _latLng.longitude.toString();
    request.fields['created_by'] = widget.userId.toString();

    print(restaurantName.text);
    print(telephone1.text);
    print(telephone2.text);
    print(widget.userId.toString());

    try {
      var response = await request.send();
      // print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseJson = await response.stream.bytesToString();
        final Map<String, dynamic> data = jsonDecode(responseJson);

        final restaurantId = data['restaurant_id'];
        // if (selectedImages != null && selectedImages.isNotEmpty) {
        // await _category(restaurantId);
        // }

        return AddRestaurantModel.fromJson(data);
      } else {
        throw Exception("Failed to add review");
      }
    } catch (e) {
      // จัดการข้อผิดพลาด
      print('Error: $e');
      throw Exception("An error occurred: $e");
    }
  }

  //เพิ่มหมวดหมู่ร้านอาหาร
  // Future<AddCategoryModel?> _category(int restaurantId) async {
  //   final Uri url = Uri.parse(
  //       'http://10.0.2.2:8000/api/restaurant/insertCategories/$restaurantId');
  //   var CategoryRequest = http.MultipartRequest('POST', url);
  //   CategoryRequest.headers['Authorization'] = 'Bearer ${globals.jwtToken}';
  //   CategoryRequest.fields['restaurant_id'] = restaurantId.toString();

  //   // Add category data
  //   for (int i = 0; i < selectedCategories.length; i++) {
  //     String fieldName = 'category_data[$i]';
  //     CategoryRequest.fields[fieldName] = jsonEncode(selectedCategories[i]);
  //   }

  //   var response = await CategoryRequest.send();

  //   print(response.statusCode);
  //   if (response.statusCode != 200 && response.statusCode != 201) {
  //     throw Exception("Failed to upload categories");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "เพิ่มร้านอาหารของฉัน",
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _addRestaurantPage,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15.0, top: 30, right: 15),
                child: Row(
                  children: [
                    Text(
                      "ชื่อร้าน",
                      style: TextStyle(
                        fontFamily: 'EkkamaiNew',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 95),
                    Expanded(
                      child: SizedBox(
                          height: 50,
                          child: TextFormField(
                            controller: restaurantName,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: const Color.fromARGB(
                                        255, 214, 214, 214)),
                              ),
                              labelText: "ชื่อร้าน",
                              labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 190, 190, 190)),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0, top: 15, right: 15),
                child: Row(
                  children: [
                    Text(
                      "หมายเลขโทรศัพท์ 1",
                      style: TextStyle(
                          fontFamily: 'EkkamaiNew',
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: SizedBox(
                          height: 50,
                          child: TextFormField(
                            controller: telephone1,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: const Color.fromARGB(
                                        255, 214, 214, 214)),
                              ),
                              labelText: "หมายเลขโทรศัพท์ 1",
                              labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 190, 190, 190)),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0, top: 15, right: 15),
                child: Row(
                  children: [
                    Text(
                      "หมายเลขโทรศัพท์ 2",
                      style: TextStyle(
                          fontFamily: 'EkkamaiNew',
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: SizedBox(
                          height: 50,
                          child: TextFormField(
                            controller: telephone2,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: const Color.fromARGB(
                                        255, 214, 214, 214)),
                              ),
                              labelText: "หมายเลขโทรศัพท์ 2",
                              labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 190, 190, 190)),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0, top: 15, right: 15),
                child: Row(
                  children: [
                    Text(
                      "ประเภทร้านอาหาร",
                      style: TextStyle(
                        fontFamily: 'EkkamaiNew',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 20),
                    // Expanded(
                    //   child: SizedBox(
                    //     height: 60,
                    //     child: Padding(
                    //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    //       child: InkWell(
                    //         onTap: () async {
                    //           final result = await Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //               builder: (context) => TypeRestaurantPage(
                    //                 selectedCategories: [],
                    //               ),
                    //             ),
                    //           );

                    //           if (result != null) {
                    //             setState(() {
                    //               _controller.text = result
                    //                   .map((category) => category["name"])
                    //                   .join(", ");
                    //             });
                    //           }
                    //         },
                    //         child: TextField(
                    //           enabled: false,
                    //           controller: _controller,
                    //           decoration: InputDecoration(
                    //             border: OutlineInputBorder(
                    //               borderSide: BorderSide(color: Colors.blue),
                    //               borderRadius: BorderRadius.all(
                    //                 Radius.circular(10),
                    //               ),
                    //             ),
                    //             focusedBorder: OutlineInputBorder(
                    //               borderRadius: BorderRadius.circular(10),
                    //               borderSide: BorderSide(color: Colors.grey),
                    //             ),
                    //             enabledBorder: OutlineInputBorder(
                    //               borderRadius: BorderRadius.circular(10),
                    //               borderSide: BorderSide(
                    //                 color: const Color.fromARGB(
                    //                     255, 214, 214, 214),
                    //               ),
                    //             ),
                    //             labelText: "ประเภทร้านอาหาร",
                    //             labelStyle: TextStyle(
                    //               color: Color.fromARGB(255, 190, 190, 190),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.only(left: 15.0, top: 15, right: 15),
              //   child: Row(
              //     children: [
              //       Text(
              //         "วัน เวลาเปิด/ปิด",
              //         style: TextStyle(
              //             fontFamily: 'EkkamaiNew',
              //             fontWeight: FontWeight.bold,
              //             fontSize: 14),
              //       ),
              //       SizedBox(width: 45),
              //       widget.selectedTimes != null
              //           ? InkWell(
              //               onTap: () {
              //                 Navigator.push(
              //                     context,
              //                     MaterialPageRoute(
              //                         builder: (context) =>
              //                             AddTimeOpenCloseDialog(
              //                               restaurantName: restaurantName,
              //                               telephone1: '',
              //                               telephone2: '',
              //                             )));
              //               },
              //               child: Container(
              //                 width: 150,
              //                 height: 40,
              //                 decoration: BoxDecoration(
              //                     borderRadius: BorderRadius.circular(5),
              //                     color: Colors.blue),
              //                 child: const Center(
              //                     child: Text(
              //                   "ระบุวัน/เวลา",
              //                   style: TextStyle(color: Colors.white),
              //                 )),
              //               ),
              //             )
              //           : Expanded(
              //               child: TextField(
              //                 controller: _dayTimeController,
              //                 enabled: false,
              //                 decoration: InputDecoration(
              //                   border: InputBorder.none,
              //                   hintText: 'ระบุวัน/เวลา',
              //                   hintStyle: TextStyle(color: Colors.grey),
              //                 ),
              //               ),
              //             ),
              //     ],
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.only(left: 15.0, top: 20, right: 15),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "ที่อยู่ :",
                        style: TextStyle(
                            fontFamily: 'EkkamaiNew',
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ),
                    const SizedBox(width: 50),
                    InkWell(
                      onTap: () async {
                        // final address = await Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) =>
                        //         PlaceMarkerPage(initialPosition: _latLng),
                        //   ),
                        // );
                        // if (address != null) {
                        //   if (mounted) {
                        //     setState(() {
                        //       _address = address["address"];
                        //       _latLng = address["latLng"];
                        //     });
                        //   }
                        // }

                        // print('กดเพื่อระบุตำแหน่งร้านอาหารของคุณ: ${address}');
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Column(
                          children: [
                            Container(
                              width: 400,
                              height: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Colors.blue,
                                ),
                              ),
                              child: GoogleMap(
                                initialCameraPosition: CameraPosition(
                                  target: _latLng,
                                  zoom: 15,
                                ),
                                markers: {
                                  Marker(
                                    markerId: MarkerId('1'),
                                    position: _latLng,
                                  ),
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              _address != null
                                  ? 'ที่อยู่ร้านอาหารของฉัน: $_address'
                                  : 'กดที่นี่เพื่อระบุตำแหน่งร้านอาหารของคุณ',
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.only(left: 15.0, top: 15, right: 15),
              //   child: Column(
              //     children: [
              //       Align(
              //         alignment: Alignment.centerLeft,
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text(
              //               "รูปภาพ",
              //               style: TextStyle(
              //                   fontFamily: 'EkkamaiNew',
              //                   fontWeight: FontWeight.bold,
              //                   fontSize: 14),
              //             ),
              //             Text(
              //               "ไม่เกิน 10 ภาพ",
              //               style: TextStyle(
              //                   fontFamily: 'EkkamaiNew',
              //                   fontWeight: FontWeight.bold,
              //                   fontSize: 14,
              //                   color: Colors.red),
              //             ),
              //           ],
              //         ),
              //       ),
              //       SizedBox(
              //         width: 50,
              //         height: 10,
              //       ),
              //       Container(
              //         height: 100,
              //         child: GridView.builder(
              //           scrollDirection: Axis.horizontal,
              //           itemCount: selectedImages.length,
              //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //             crossAxisCount: 1,
              //             mainAxisSpacing: 8.0,
              //             crossAxisSpacing: 8.0,
              //           ),
              //           itemBuilder: (BuildContext context, int index) {
              //             return Image.file(
              //               selectedImages[index],
              //               fit: BoxFit.cover,
              //             );
              //           },
              //         ),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.only(top: 8.0),
              //         child: InkWell(
              //           onTap: _pickImages,
              //           child: Container(
              //             width: MediaQuery.sizeOf(context).width * 0.93,
              //             height: 40,
              //             decoration: BoxDecoration(
              //               color: Color.fromARGB(255, 218, 218, 218),
              //               borderRadius: BorderRadius.circular(5),
              //             ),
              //             child: Center(
              //               child: Icon(Icons.photo_camera_outlined),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: InkWell(
                  onTap: () async {
                    if (_addRestaurantPage.currentState!.validate()) {
                      AddRestaurantModel? restaurant = await _addRestaurant();
                    }
                  },
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 0.93,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Center(
                        child: Text(
                      "บันทึกข้อมูล",
                      style: TextStyle(color: Colors.white),
                    )),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
