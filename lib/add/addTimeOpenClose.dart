import 'package:flutter/material.dart';
import 'package:fmr_project/add/addRestuarant.dart';

class AddTimeOpenCloseDialog extends StatefulWidget {
  final String restaurantName;
  final String telephone1;
  final String telephone2;

  const AddTimeOpenCloseDialog(
      {required this.restaurantName,
      required this.telephone1,
      required this.telephone2,
      Key? key})
      : super(key: key);

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
                  // Print selected opening and closing times
                  print('Selected Opening-Closing Times:');
                  for (var day in selectedDays) {
                    var openingTime =
                        openingTimeControllers[day]?.format(context) ??
                            'Not selected';
                    var closingTime =
                        closingTimeControllers[day]?.format(context) ??
                            'Not selected';
                    print(
                        'Day: $day, Opening Time: $openingTime, Closing Time: $closingTime');
                  }
                  List<OpeningClosingTime> selectedTimes = [];
                  for (var day in selectedDays) {
                    selectedTimes.add(OpeningClosingTime(
                      days: [day],
                      openingTime: openingTimeControllers[day]!,
                      closingTime: closingTimeControllers[day]!,
                    ));
                  }
                  // Navigator.pop(context, selectedTimes);

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => AddResPage(
                  //       selectedCategories: [],
                  //       selectedTimes: selectedTimes,
                  //       userId: null,
                  //     ),
                  //   ),
                  // );
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
