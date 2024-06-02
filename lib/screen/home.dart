import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fmr_project/bottom_navigator/bottom_navigator_new.dart';
import 'package:fmr_project/color/colors.dart';
import 'package:fmr_project/search_history/searhHistory.dart';
import 'package:fmr_project/recomented/recomented.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
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
                width: MediaQuery.of(context).size.width * 1,
                child: Lottie.network(
                    'https://lottie.host/abb3c040-8222-44b8-9541-801d75890585/e4hCPyyVYT.json'),
              ),
            )
          : SizedBox(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.30,
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
                          "assets/img/bg.jpg",
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                    GestureDetector(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                builder: (context) => BottomNavigatorScreen(
                                      indexPage: 1,
                                      userId: widget.userId,
                                    )));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
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
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
