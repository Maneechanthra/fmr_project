import 'package:flutter/material.dart';
import 'package:fmr_project/screen/index.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    MaterialColor myBlue = MaterialColor(0xFF009BD4, {
      50: Color(0xFFE5F7FF),
      100: Color(0xFFB3E3FF),
      200: Color(0xFF80D0FF),
      300: Color(0xFF4DBDFF),
      400: Color(0xFF26AEFF),
      500: Color(0xFF00B7FF),
      600: Color(0xFF00A9F2),
      700: Color(0xFF009BD4),
      800: Color(0xFF008EB7),
      900: Color(0xFF007B8E),
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FMReataurant',
      theme: ThemeData(
        primarySwatch: myBlue,
        fontFamily: GoogleFonts.prompt().fontFamily,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: IndexPage(),
    );
  }
}
