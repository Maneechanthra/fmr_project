import 'package:flutter/material.dart';
import 'package:fmr_project/test_1.dart';

class DisplaySelectedDateTimePage extends StatefulWidget {
  final List<String> selectedDays;
  final TimeOfDay? openingTime;
  final TimeOfDay? closingTime;

  DisplaySelectedDateTimePage({
    required this.selectedDays,
    required this.openingTime,
    required this.closingTime,
  });

  @override
  State<DisplaySelectedDateTimePage> createState() =>
      _DisplaySelectedDateTimePageState();
}

class _DisplaySelectedDateTimePageState
    extends State<DisplaySelectedDateTimePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selected Date and Time'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 100,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SelectDateTimePage()));
                },
                child: Center(
                  child: Text("data"),
                ),
              ),
            ),
            Text(
              'Selected Days: ${widget.selectedDays.join(", ")}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              'Opening Time: ${widget.openingTime != null ? widget.openingTime!.format(context) : "Not selected"}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              'Closing Time: ${widget.closingTime != null ? widget.closingTime!.format(context) : "Not selected"}',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
