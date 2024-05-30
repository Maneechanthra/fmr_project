import 'package:flutter/material.dart';
import 'package:fmr_project/screen/home.dart';
import 'package:fmr_project/screen/map.dart';
import 'package:fmr_project/screen/profile.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:enefty_icons/enefty_icons.dart';

class BottomNavigatorPage extends StatefulWidget {
  final int indexPage;
  final int? userId;

  const BottomNavigatorPage({required this.indexPage, this.userId, Key? key})
      : super(key: key);

  @override
  State<BottomNavigatorPage> createState() => _BottomNavigatorPageState();
}

class _BottomNavigatorPageState extends State<BottomNavigatorPage> {
  late PageController _pageController;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.indexPage;
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      HomePage(widget.userId ?? 0),
      MapsPage(widget.userId ?? 0),
      ProfilePage(widget.userId ?? 0),
    ];

    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _widgetOptions,
      ),
      bottomNavigationBar: GNav(
        color: Colors.black,
        activeColor: Colors.green,
        tabs: const [
          GButton(
            icon: EneftyIcons.home_2_bold,
            iconSize: 30,
            text: 'หน้าแรก',
          ),
          GButton(
            icon: Icons.location_on_rounded,
            iconSize: 30,
            text: 'แผนที่',
          ),
          GButton(
            icon: Icons.person,
            iconSize: 30,
            text: 'ฉัน',
          ),
        ],
        selectedIndex: _selectedIndex,
        onTabChange: (index) {
          _pageController.jumpToPage(index);
        },
      ),
    );
  }
}
