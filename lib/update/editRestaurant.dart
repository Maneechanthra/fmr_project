import 'package:flutter/material.dart';
import 'package:fmr_project/add/addAddress_on_map.dart';
import 'package:fmr_project/add/addAddress_on_map_for_editForm.dart';
import 'package:fmr_project/add/addTimeOpenClose.dart';
import 'package:fmr_project/add/addTimeOpenClose_for_editForm.dart';
import 'package:fmr_project/detail_page/all_typerestaurant.dart';
import 'package:fmr_project/detail_page/all_typerestaurant_for_editForm.dart';
import 'package:fmr_project/model/restaurant_info.dart';
import 'package:fmr_project/screen/profile.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class editRestaurant extends StatefulWidget {
  final List<Map<String, dynamic>> selectedCategories;
  final int res_id;
  const editRestaurant(
      {Key? key, required this.selectedCategories, required this.res_id})
      : super(key: key);

  @override
  State<editRestaurant> createState() => _editRestaurantState();
}

class _editRestaurantState extends State<editRestaurant> {
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
  late TextEditingController restaurantNameController;
  late TextEditingController phone1NumberController;
  late TextEditingController phone2NumberController;
  late TextEditingController type_restaurant_nameController;

  // final nameController = TextEditingController();
  // final phone1NumberController = TextEditingController(text: "0630038428");
  // final phone2NumberController = TextEditingController(text: "08296075902");

  late Future<List<Restaurant_2>> futureEditRestaurant;

  List<File> selectedImages = [];

  List<Map<String, dynamic>> selectedCategories = [];

  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.selectedCategories
          .map((category) => category["name"])
          .join(", "),
    );
    restaurantNameController =
        TextEditingController(text: allRestaurants_2[widget.res_id - 1].name);
    phone1NumberController = TextEditingController(
        text: allRestaurants_2[widget.res_id - 1].telephone_1);
    phone2NumberController = TextEditingController(
        text: allRestaurants_2[widget.res_id - 1].telephone_2);
    type_restaurant_nameController = TextEditingController(
        text: allRestaurants_2[widget.res_id - 1].type_restaurant);
  }

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
  static const LatLng _latLng = LatLng(17.27274239, 104.1265007);
  String? _address;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "แก้ไขข้อมูลร้านอาหารของฉัน",
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
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
                        child: TextField(
                          controller: restaurantNameController,
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
                        child: TextField(
                          controller: phone1NumberController,
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
                            labelText: "หมายเลขโทรศัพท์ 1",
                            labelStyle: TextStyle(
                                color: Color.fromARGB(255, 190, 190,
                                    190)), // Change the label text color
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
                        child: TextField(
                          controller: phone2NumberController,
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
                                  color:
                                      const Color.fromARGB(255, 214, 214, 214)),
                            ),
                            labelText: "หมายเลขโทรศัพท์ 2",
                            labelStyle: TextStyle(
                                color: Color.fromARGB(255, 190, 190,
                                    190)), // Change the label text color
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
                  //               builder: (context) => TypeRestaurantEditPage(
                  //                 selectedCategories: [],
                  //                 res_id:
                  //                     allRestaurants_2[widget.res_id - 1].id,
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
                  //           controller: _controller != null
                  //               ? _controller
                  //               : type_restaurant_nameController,
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
                  //                 color:
                  //                     const Color.fromARGB(255, 214, 214, 214),
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
            Padding(
              padding: EdgeInsets.only(left: 15.0, top: 15, right: 15),
              child: Row(
                children: [
                  Text(
                    "วัน เวลาเปิด/ปิด",
                    style: TextStyle(
                        fontFamily: 'EkkamaiNew',
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                  SizedBox(width: 45),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AddTimeOpenCloseEditDialog()));
                    },
                    child: Container(
                      width: 150,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.blue),
                      child: const Center(
                          child: Text(
                        "ระบุวัน/เวลา",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                  ),
                ],
              ),
            ),
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
                      final address = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PlaceMarkerEditPage(initialPosition: _latLng),
                        ),
                      );
                      setState(() {
                        _address = address;
                      });
                      print('กดเพื่อระบุตำแหน่งร้านอาหารของคุณ: $address');
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
            Padding(
              padding: EdgeInsets.only(left: 15.0, top: 15, right: 15),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "รูปภาพ",
                          style: TextStyle(
                              fontFamily: 'EkkamaiNew',
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        Text(
                          "ไม่เกิน 10 ภาพ",
                          style: TextStyle(
                              fontFamily: 'EkkamaiNew',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    height: 10,
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
                    padding: const EdgeInsets.only(top: 8.0),
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
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
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
    );
  }
}
