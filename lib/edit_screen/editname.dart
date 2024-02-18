import 'package:flutter/material.dart';

class EditNamePage extends StatefulWidget {
  const EditNamePage({super.key});

  @override
  State<EditNamePage> createState() => _EditNamePageState();
}

class _EditNamePageState extends State<EditNamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "แก้ไขชื่อ-นามสกุล",
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 330,
              height: 50,
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  labelText: "ชื่อ-นามสกุล",
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {},
              child: Container(
                width: 330,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: const Center(
                    child: Text(
                  "บันทึกข้อมูล",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
