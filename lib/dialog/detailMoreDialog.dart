import 'package:flutter/material.dart';

class MoreDialogPage extends StatelessWidget {
  const MoreDialogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "ข้อมูลเพิ่มเติม",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Divider(),
              Row(
                children: [],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
