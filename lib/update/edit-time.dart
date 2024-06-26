import 'package:flutter/material.dart';

class EditTimePage extends StatefulWidget {
  final String day;
  final TimeOfDay initialOpeningTime;
  final TimeOfDay initialClosingTime;

  EditTimePage(this.day, this.initialOpeningTime, this.initialClosingTime);

  @override
  _EditTimePageState createState() => _EditTimePageState();
}

class _EditTimePageState extends State<EditTimePage> {
  late TimeOfDay _openingTime;
  late TimeOfDay _closingTime;

  @override
  void initState() {
    super.initState();
    _openingTime = widget.initialOpeningTime;
    _closingTime = widget.initialClosingTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขเวลา ${widget.day}'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('เวลาเปิด: ${_openingTime.format(context)}'),
            onTap: () async {
              TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: _openingTime,
              );
              if (picked != null) {
                setState(() {
                  _openingTime = picked;
                });
              }
            },
          ),
          ListTile(
            title: Text('เวลาปิด: ${_closingTime.format(context)}'),
            onTap: () async {
              TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: _closingTime,
              );
              if (picked != null) {
                setState(() {
                  _closingTime = picked;
                });
              }
            },
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, {
                'openingTime': _openingTime,
                'closingTime': _closingTime,
              });
            },
            child: Text('บันทึก'),
          ),
        ],
      ),
    );
  }
}
