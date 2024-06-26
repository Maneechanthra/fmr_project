import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fmr_project/bottom_navigator/bottom_navigator.dart';
import 'package:fmr_project/bottom_navigator/bottom_navigator_new.dart';
import 'package:fmr_project/screen/home.dart';

import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => BottomNavigatorScreen(
                indexPage: 0,
                userId: null,
              )));
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 100,
          ),
          Center(
            child: Image.asset(
              "assets/img/logo/logo.png",
              width: 200,
              height: 200,
            ),
          ),
          Text(
            "FMRestaurant",
            style: GoogleFonts.mitr(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 0, 122, 221)),
          ),
          Text(
            "การค้นหาร้านอาหารของคุณจะกลายเป็นเรื่องง่าย ๆ",
            style: GoogleFonts.mitr(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: const Color.fromARGB(255, 0, 0, 0)),
          ),
          const SizedBox(
            height: 300,
          ),
        ],
      ),
    );
  }
}
