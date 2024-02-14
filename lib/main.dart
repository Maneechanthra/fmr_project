import 'package:flutter/material.dart';
import 'package:fmr_project/screen/home.dart';
import 'package:fmr_project/screen/index.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    MaterialColor myWhite = const MaterialColor(0xFFFFFFFF, {
      50: Color(0xFFFFFFFF),
      100: Color(0xFFFFFFFF),
      200: Color(0xFFFFFFFF),
      300: Color(0xFFFFFFFF),
      400: Color(0xFFFFFFFF),
      500: Color(0xFFFFFFFF),
      600: Color(0xFFFFFFFF),
      700: Color(0xFFFFFFFF),
      800: Color(0xFFFFFFFF),
      900: Color(0xFFFFFFFF),
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FMReataurant',
      theme: ThemeData(
        primarySwatch: myWhite, // Set primarySwatch to the custom MaterialColor
        useMaterial3: true,
        fontFamily: GoogleFonts.prompt().fontFamily,
      ),
      home: IndexPage(),
    );
  }
}
