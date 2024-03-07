import 'package:flutter/material.dart';
import 'package:fmr_project/add/addRestuarant.dart';

class AddTimeOpenCloseDialog extends StatefulWidget {
  const AddTimeOpenCloseDialog({Key? key}) : super(key: key);

  @override
  State<AddTimeOpenCloseDialog> createState() => _AddTimeOpenCloseDialogState();
}

class OpeningClosingTime {
  final List<String> days;
  final TimeOfDay openingTime;
  final TimeOfDay closingTime;

  OpeningClosingTime({
    required this.days,
    required this.openingTime,
    required this.closingTime,
  });
}

class _AddTimeOpenCloseDialogState extends State<AddTimeOpenCloseDialog> {
  final List<String> daysOfWeek = [
    'จันทร์',
    'อังคาร',
    'พุธ',
    'พฤหัสบดี',
    'ศุกร์',
    'เสาร์',
    'อาทิตย์'
  ];

  Map<String, TimeOfDay?> openingTimeControllers = {};
  Map<String, TimeOfDay?> closingTimeControllers = {};

  List<String> selectedDays = [];

  @override
  void initState() {
    super.initState();

    // Initialize controllers for each day
    for (var day in daysOfWeek) {
      openingTimeControllers[day] = TimeOfDay.now();
      closingTimeControllers[day] = TimeOfDay.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ระบุวันเวลาเปิด-ปิดร้าน",
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: daysOfWeek.map((day) {
                  bool isOpen = selectedDays.contains(day);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Switch(
                            activeColor: Color.fromARGB(255, 11, 134, 0),
                            value: isOpen,
                            onChanged: (value) {
                              setState(() {
                                if (value) {
                                  selectedDays.add(day);
                                } else {
                                  selectedDays.remove(day);
                                }
                              });
                            },
                          ),
                          Text(
                            day,
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      if (isOpen)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    TimeOfDay? selectedTime =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: openingTimeControllers[day]!,
                                    );
                                    if (selectedTime != null) {
                                      setState(() {
                                        openingTimeControllers[day] =
                                            selectedTime;
                                      });
                                    }
                                  },
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: 'เวลาเปิด',
                                    ),
                                    child: Text(
                                      openingTimeControllers[day]!
                                          .format(context),
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    TimeOfDay? selectedTime =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: closingTimeControllers[day]!,
                                    );
                                    if (selectedTime != null) {
                                      setState(() {
                                        closingTimeControllers[day] =
                                            selectedTime;
                                      });
                                    }
                                  },
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: 'เวลาปิด',
                                    ),
                                    child: Text(
                                      closingTimeControllers[day]!
                                          .format(context),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              height: 15,
            ),
          ],
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
                onTap: () {
                  // Navigator.pop(context);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddResPage(
                                selectedCategories: [],
                              )));
                },
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

//เพิ่มเวลาทำการเปิดปิด 
//  SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: daysOfWeek.map((day) {
//                   return Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Checkbox(
//                               value: selectedDays.contains(day),
//                               onChanged: (value) {
//                                 setState(() {
//                                   if (value != null && value) {
//                                     selectedDays.add(day);
//                                   } else {
//                                     selectedDays.remove(day);
//                                   }
//                                 });
//                               },
//                             ),
//                             Text(day),
//                           ],
//                         ),
//                       ),
//                       SizedBox(width: 10),
//                       Expanded(
//                         child: InkWell(
//                           onTap: () async {
//                             TimeOfDay? selectedTime = await showTimePicker(
//                               context: context,
//                               initialTime: openingTimeControllers[day]!,
//                             );
//                             if (selectedTime != null) {
//                               setState(() {
//                                 openingTimeControllers[day] = selectedTime;
//                               });
//                             }
//                           },
//                           child: InputDecorator(
//                             decoration: InputDecoration(
//                               labelText: 'เวลาเปิด',
//                             ),
//                             child: Text(
//                               openingTimeControllers[day]!.format(context),
//                               style: TextStyle(fontSize: 14),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 16),
//                       Expanded(
//                         child: InkWell(
//                           onTap: () async {
//                             TimeOfDay? selectedTime = await showTimePicker(
//                               context: context,
//                               initialTime: closingTimeControllers[day]!,
//                             );
//                             if (selectedTime != null) {
//                               setState(() {
//                                 closingTimeControllers[day] = selectedTime;
//                               });
//                             }
//                           },
//                           child: InputDecorator(
//                             decoration: InputDecoration(
//                               labelText: 'เวลาปิด',
//                             ),
//                             child: Text(
//                               closingTimeControllers[day]!.format(context),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 }).toList(),
//               ),
//             ),
//             SizedBox(
//               height: 15,
//             ),
//             // Container(
//             //   width: 330,
//             //   height: 40,
//             //   decoration: BoxDecoration(
//             //     borderRadius: BorderRadius.circular(10),
//             //     color: Colors.blue,
//             //   ),
//             // ),
//           ],
//         ),
//       ),




/* Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8.0,
            children: daysOfWeek.map((day) {
              return CheckboxListTile(
                title: Text(day),
                value: selectedDayTemp == day,
                onChanged: (value) {
                  setState(() {
                    if (value != null && value) {
                      selectedDayTemp = day;
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: DropdownButton<String>(
                  value: openingTimeTemp,
                  onChanged: (String? newValue) {
                    setState(() {
                      openingTimeTemp = newValue!;
                    });
                  },
                  items:
                      timesOfDay.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: DropdownButton<String>(
                  value: closingTimeTemp,
                  onChanged: (String? newValue) {
                    setState(() {
                      closingTimeTemp = newValue!;
                    });
                  },
                  items:
                      timesOfDay.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              OpeningClosingTime newTime = OpeningClosingTime(
                day: selectedDayTemp,
                openingTime: openingTimeTemp,
                closingTime: closingTimeTemp,
              );
              setState(() {
                selectedTimes.add(newTime);
              });
              selectedDayTemp = 'ทุกวัน';
              openingTimeTemp = timesOfDay.first;
              closingTimeTemp = timesOfDay.last;
            },
            child: const Text('Add'),
          ),
          const SizedBox(height: 16.0),
          if (selectedTimes.isNotEmpty)
            Text(
              'วันเปิดทำการ: ${selectedTimes.last.day}, เวลาเปิด: ${selectedTimes.last.openingTime}, เวลาปิด: ${selectedTimes.last.closingTime}',
              style: const TextStyle(fontSize: 16),
            ),
        ],
      ),
    );*/