import 'package:flutter/material.dart';

class disableRestaurant extends StatefulWidget {
  const disableRestaurant({super.key});

  @override
  State<disableRestaurant> createState() => _disableRestaurantState();
}

class _disableRestaurantState extends State<disableRestaurant> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Text(
          "ไม่สามารถเข้าดูข้อมูลร้านอาหารได้ เนื่องจากถูกปิดการเข้าถึงข้อมูล"),
    );
  }
}
