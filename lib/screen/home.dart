import 'package:flutter/material.dart';
import 'package:fmr_project/api/recommentded_api.dart';
import 'package:fmr_project/bottom_navigator/bottom_navigator.dart';
import 'package:fmr_project/detail_restaurant/detail_restaurant.dart';
import 'package:fmr_project/screen/searhHistory.dart';
import 'package:fmr_project/recomented/recomented.dart';
import 'package:fmr_project/screen/map.dart';
import 'package:fmr_project/screen/profile.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lottie/lottie.dart';
import '/globals.dart' as globals;

class HomePage extends StatefulWidget {
  final int? userId;
  const HomePage(this.userId, {Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  late PageController _pageController = PageController();
  double? userLatitude;
  double? userLongitude;
  bool isLoadingLocation = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _delayedLoadUserLocation();
    print("userId: " + widget.userId.toString());
    print("_pageController: " + _pageController.toString());
    print("latitude : " + userLatitude.toString());
    print("longtitude : " + userLongitude.toString());
    print("jwt : " + globals.jwtToken);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _delayedLoadUserLocation() async {
    await Future.delayed(Duration(seconds: 1));
    await _loadUserLocation();
  }

  Future<void> _loadUserLocation() async {
    try {
      Position userPosition = await getUserCurrentLocation();
      print(
          'ตำแหน่งปัจจุบัน : ${userPosition.latitude}, ${userPosition.longitude}');
      setState(() {
        userLatitude = userPosition.latitude;
        userLongitude = userPosition.longitude;
        isLoadingLocation = false;
      });
    } catch (e) {
      print("Error fetching user location: $e");
    }
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print("error " + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoadingLocation
          ? Center(
              child: SizedBox(
                width: 300,
                child: Lottie.network(
                    'https://lottie.host/e5abe087-7811-44fa-a384-e5df4243c00f/mK3LQGpd4P.json'),
              ),
            )
          : SizedBox(
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                          color: const Color.fromARGB(255, 197, 197, 197),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                          child: Image.asset(
                            "assets/img/banner.png",
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SearchHistoryPage(widget.userId ?? 0)));
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: Container(
                            height: 50,
                            margin: const EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color.fromARGB(255, 240, 239, 239),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "ค้นหาร้านอาหาร",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 107, 107, 107),
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  Icon(
                                    Icons.search,
                                    color: Color.fromARGB(255, 107, 107, 107),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 15, top: 15, bottom: 5, right: 15),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                      width: 20,
                                      child: Image.asset(
                                        "assets/img/icons/restaurant_re.png",
                                      )),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "ร้านแนะนำ",
                                    style: GoogleFonts.mitr(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 65, 65, 65),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (userLatitude != null && userLongitude != null)
                        RecomentedPage(
                            widget.userId!, userLatitude!, userLongitude!),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DetailRestaurantPage_2(1, null)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 14, 167, 0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(255, 190, 190, 190),
                                  blurRadius: 5.0,
                                  offset: Offset(0, 2),
                                )
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "ดูทั้งหมด",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
    // bottomNavigationBar: GNav(
    //   color: Colors.black,
    //   activeColor: Colors.green,
    //   tabs: const [
    //     GButton(
    //       icon: Icons.home,
    //       iconSize: 30,
    //       text: 'หน้าแรก',
    //     ),
    //     GButton(
    //       icon: Icons.location_on_rounded,
    //       iconSize: 30,
    //       text: 'แผนที่',
    //     ),
    //     GButton(
    //       icon: Icons.person,
    //       iconSize: 30,
    //       text: 'ฉัน',
    //     ),
    //   ],
    //   onTabChange: (index) {
    //     _pageController.jumpToPage(index); // กระโดดไปยังหน้าที่เลือก
    //     print(
    //         'PageController: $_pageController'); // แสดงรายละเอียดของ PageController
    //     print('Selected Index: $index'); // แสดงดัชนีที่เลือก
    //   },
    // ),
  }
}
