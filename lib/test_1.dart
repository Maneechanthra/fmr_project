import 'package:flutter/material.dart';

class SelectDateTimePage extends StatefulWidget {
  @override
  _SelectDateTimePageState createState() => _SelectDateTimePageState();
}

class _SelectDateTimePageState extends State<SelectDateTimePage> {
  Map<String, Map<String, TimeOfDay>> selectedDaysAndTimes = {
    'วันจันทร์': {
      'เวลาเปิดร้าน': TimeOfDay(hour: 8, minute: 0),
      'เวลาปิดร้าน': TimeOfDay(hour: 20, minute: 0)
    },
    'วันอังคาร': {
      'เวลาเปิดร้าน': TimeOfDay(hour: 8, minute: 0),
      'เวลาปิดร้าน': TimeOfDay(hour: 20, minute: 0)
    },
    'วันพุธ': {
      'เวลาเปิดร้าน': TimeOfDay(hour: 8, minute: 0),
      'เวลาปิดร้าน': TimeOfDay(hour: 20, minute: 0)
    },
    // เพิ่มวันอื่นๆ และเวลาที่เปิด-ปิดร้านเริ่มต้นได้ที่นี่
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เลือกวันและเวลาเปิด-ปิดร้าน'),
      ),
      body: ListView(
        children: selectedDaysAndTimes.keys.map((day) {
          return Column(
            children: [
              ListTile(
                title: Text(day),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('เวลาเปิดร้าน:'),
                    TextButton(
                      onPressed: () async {
                        final selectedTime = await showTimePicker(
                          context: context,
                          initialTime:
                              selectedDaysAndTimes[day]!['เวลาเปิดร้าน']!,
                        );
                        if (selectedTime != null) {
                          setState(() {
                            selectedDaysAndTimes[day]!['เวลาเปิดร้าน'] =
                                selectedTime;
                          });
                        }
                      },
                      child: Text(
                        '${selectedDaysAndTimes[day]!['เวลาเปิดร้าน']!.format(context)}',
                      ),
                    ),
                    Text('เวลาปิดร้าน:'),
                    TextButton(
                      onPressed: () async {
                        final selectedTime = await showTimePicker(
                          context: context,
                          initialTime:
                              selectedDaysAndTimes[day]!['เวลาปิดร้าน']!,
                        );
                        if (selectedTime != null) {
                          setState(() {
                            selectedDaysAndTimes[day]!['เวลาปิดร้าน'] =
                                selectedTime;
                          });
                        }
                      },
                      child: Text(
                        '${selectedDaysAndTimes[day]!['เวลาปิดร้าน']!.format(context)}',
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
            ],
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // นำข้อมูลไปยังหน้าที่สอง
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DisplaySelectedDateTimePage(
                selectedDaysAndTimes: selectedDaysAndTimes,
              ),
            ),
          );
        },
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}

class DisplaySelectedDateTimePage extends StatelessWidget {
  final Map<String, Map<String, TimeOfDay>> selectedDaysAndTimes;

  DisplaySelectedDateTimePage({
    required this.selectedDaysAndTimes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('วันและเวลาที่เลือก'),
      ),
      body: ListView(
        children: selectedDaysAndTimes.keys.map((day) {
          return Column(
            children: [
              ListTile(
                title: Text(day),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'เวลาเปิดร้าน: ${selectedDaysAndTimes[day]!['เวลาเปิดร้าน']!.format(context)}'),
                    Text(
                        'เวลาปิดร้าน: ${selectedDaysAndTimes[day]!['เวลาปิดร้าน']!.format(context)}'),
                  ],
                ),
              ),
              Divider(),
            ],
          );
        }).toList(),
      ),
    );
  }
}
