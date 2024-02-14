import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fmr_project/screen/home.dart';

import 'package:google_fonts/google_fonts.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()));
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
          // InkWell(
          //   onTap: () {
          //     Navigator.push(
          //         context, MaterialPageRoute(builder: (contdxt) => HomePage()));
          //   },
          //   child: Container(
          //       width: 330,
          //       height: 50,
          //       decoration: BoxDecoration(
          //         color: Colors.blue,
          //         borderRadius: BorderRadius.circular(10),
          //       ),
          //       child: Center(
          //           child: Text(
          //         "เริ่มต้นใช้งาน",
          //         style: TextStyle(fontSize: 18, color: Colors.white),
          //       ))),
          // ),
        ],
      ),
    );
  }
}
