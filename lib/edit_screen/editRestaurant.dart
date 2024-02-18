import 'package:flutter/material.dart';
import 'package:fmr_project/add_screen/addTimeOpenClose.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class editRestaurant extends StatefulWidget {
  const editRestaurant({Key? key}) : super(key: key);

  @override
  State<editRestaurant> createState() => _editRestaurantState();
}

class _editRestaurantState extends State<editRestaurant> {
  // String selectedDay = 'ทุกวัน';
  // String openingTime = '';
  // String closingTime = '';
  // List<String> daysOfWeek = [
  //   'ทุกวัน',
  //   'วันจันทร์',
  //   'วันอังคาร',
  //   'วันพุธ',
  //   'วันพฤหัสบดี',
  //   'วันศุกร์',
  //   'วันเสาร์',
  //   'วันอาทิตย์'
  // ];
  // List<String> timesOfDay = [];
  // List<OpeningClosingTime> openingClosingTimes = [];
  // List<OpeningClosingTime> selectedTimes = [];
  List<File> selectedImages = [];

  // @override
  // void initState() {
  //   super.initState();

  //   for (int hour = 0; hour <= 19; hour++) {
  //     for (int minute = 0; minute < 60; minute += 30) {
  //       String time =
  //           '${hour.toString().padLeft(2, '0')}.${minute.toString().padLeft(2, '0')}';
  //       timesOfDay.add(time);
  //     }
  //   }
  //   openingTime = timesOfDay.first;
  //   closingTime = timesOfDay.last;
  // }

  // Future<void> _selectDayAndTime(BuildContext context) async {
  //   String selectedDayTemp = selectedDay;
  //   String openingTimeTemp = openingTime;
  //   String closingTimeTemp = closingTime;

  //   List<OpeningClosingTime> selectedTimes = [];

  //   await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return AlertDialog(
  //             title: const Text('เลือกวันเวลาเปิดปิดร้าน'),
  //             content: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 DropdownButton<String>(
  //                   value: selectedDayTemp,
  //                   onChanged: (String? newValue) {
  //                     setState(() {
  //                       selectedDayTemp = newValue!;
  //                       openingTimeTemp = timesOfDay.first;
  //                       closingTimeTemp = timesOfDay.last;
  //                     });
  //                   },
  //                   items: daysOfWeek
  //                       .map<DropdownMenuItem<String>>((String value) {
  //                     return DropdownMenuItem<String>(
  //                       value: value,
  //                       child: Text(value),
  //                     );
  //                   }).toList(),
  //                 ),
  //                 const SizedBox(height: 16.0),
  //                 Row(
  //                   children: [
  //                     Expanded(
  //                       child: DropdownButton<String>(
  //                         value: openingTimeTemp,
  //                         onChanged: (String? newValue) {
  //                           setState(() {
  //                             openingTimeTemp = newValue!;
  //                           });
  //                         },
  //                         items: timesOfDay
  //                             .map<DropdownMenuItem<String>>((String value) {
  //                           return DropdownMenuItem<String>(
  //                             value: value,
  //                             child: Text(value),
  //                           );
  //                         }).toList(),
  //                       ),
  //                     ),
  //                     const SizedBox(width: 8.0),
  //                     Expanded(
  //                       child: DropdownButton<String>(
  //                         value: closingTimeTemp,
  //                         onChanged: (String? newValue) {
  //                           setState(() {
  //                             closingTimeTemp = newValue!;
  //                           });
  //                         },
  //                         items: timesOfDay
  //                             .map<DropdownMenuItem<String>>((String value) {
  //                           return DropdownMenuItem<String>(
  //                             value: value,
  //                             child: Text(value),
  //                           );
  //                         }).toList(),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 16.0),
  //                 ElevatedButton(
  //                   onPressed: () {
  //                     OpeningClosingTime newTime = OpeningClosingTime(
  //                       day: selectedDayTemp,
  //                       openingTime: openingTimeTemp,
  //                       closingTime: closingTimeTemp,
  //                     );
  //                     setState(() {
  //                       selectedTimes.add(newTime);
  //                     });
  //                     selectedDayTemp = 'ทุกวัน';
  //                     openingTimeTemp = timesOfDay.first;
  //                     closingTimeTemp = timesOfDay.last;
  //                   },
  //                   child: const Text('Add'),
  //                 ),
  //                 const SizedBox(height: 16.0),
  //                 if (selectedTimes.isNotEmpty)
  //                   Text(
  //                     'วันเปิดทำการ: ${selectedTimes.last.day}, เวลาเปิด: ${selectedTimes.last.openingTime}, เวลาปิด: ${selectedTimes.last.closingTime}',
  //                     style: const TextStyle(fontSize: 16),
  //                   ),
  //               ],
  //             ),
  //             actions: [
  //               ElevatedButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: const Text('Cancel'),
  //               ),
  //               ElevatedButton(
  //                 onPressed: () {
  //                   setState(() {
  //                     selectedDay = selectedDayTemp;
  //                     openingTime = openingTimeTemp;
  //                     closingTime = closingTimeTemp;

  //                     OpeningClosingTime newTime = OpeningClosingTime(
  //                       day: selectedDay,
  //                       openingTime: openingTime,
  //                       closingTime: closingTime,
  //                     );
  //                     openingClosingTimes.add(newTime);
  //                   });

  //                   print('Selected Day: $selectedDay');
  //                   print('Selected Opening Time: $openingTime');
  //                   print('Selected Closing Time: $closingTime');

  //                   Navigator.of(context).pop();
  //                 },
  //                 child: const Text('OK'),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "แก้ไขร้านอาหารของฉัน",
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
                    "วัน เวลาเปิด/ปิด",
                    style: TextStyle(
                        fontFamily: 'EkkamaiNew',
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                  SizedBox(width: 40),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddTimeOpenCloseDialog()));
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
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Container(
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
                        width: 380,
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
                onTap: () {},
                child: Container(
                  width: 330,
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
