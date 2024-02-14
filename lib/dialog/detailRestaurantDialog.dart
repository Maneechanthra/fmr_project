import 'package:flutter/material.dart';

class DetailRestaurantdialog extends StatefulWidget {
  const DetailRestaurantdialog({super.key});

  @override
  State<DetailRestaurantdialog> createState() => _DetailRestaurantdialogState();
}

class _DetailRestaurantdialogState extends State<DetailRestaurantdialog> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Dialog(
        child: Container(
          child: Text("ข้อมูลร้าอาหาร"),
        ),
      ),
    );
  }
}
