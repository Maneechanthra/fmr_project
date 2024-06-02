import 'package:flutter/material.dart';

class OpeningTimeScreen extends StatefulWidget {
  const OpeningTimeScreen({super.key});

  @override
  State<OpeningTimeScreen> createState() => _OpeningTimeScreenState();
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

  String formattedString(BuildContext context) {
    return "${days.join(", ")}: ${openingTime.format(context)} - ${closingTime.format(context)}";
  }
}

class _OpeningTimeScreenState extends State<OpeningTimeScreen> {
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

  List<OpeningClosingTime> _collectOpeningClosingTimes() {
    return selectedDays.map((day) {
      return OpeningClosingTime(
        days: [day],
        openingTime: openingTimeControllers[day]!,
        closingTime: closingTimeControllers[day]!,
      );
    }).toList();
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
                            activeColor: Color.fromARGB(255, 255, 136, 0),
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
            SizedBox(height: 15),
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
                  List<OpeningClosingTime> selectedTimes =
                      _collectOpeningClosingTimes();
                  Navigator.pop(context, selectedTimes);
                  selectedTimes.forEach((time) => print(time));
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
