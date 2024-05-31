import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:fmr_project/color/colors.dart';
import 'package:fmr_project/favorite/favorite.dart';
import 'package:fmr_project/profile/profile_screen.dart';
import 'package:fmr_project/screen/home.dart';
import 'package:fmr_project/screen/map.dart';
import 'package:fmr_project/screen/profile.dart';

class BottomNavigatorScreen extends StatefulWidget {
  final int indexPage;
  final int? userId;

  const BottomNavigatorScreen({
    required this.indexPage,
    required this.userId,
    Key? key,
  }) : super(key: key);

  @override
  State<BottomNavigatorScreen> createState() => _BottomNavigatorScreenState();
}

class _BottomNavigatorScreenState extends State<BottomNavigatorScreen> {
  late int _selectedIndex;
  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.indexPage;
    _widgetOptions = [
      HomePage(widget.userId ?? 0),
      MapsPage(widget.userId ?? 0),
      FavoriteScreen(widget.userId ?? 0),
      ProfileScreen(userId: widget.userId ?? 0),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        animationDuration: const Duration(seconds: 1),
        indicatorColor: const Color.fromARGB(0, 255, 255, 255),
        surfaceTintColor: Colors.white,
        destinations: const [
          NavigationDestination(
            icon: Icon(
              EneftyIcons.home_2_outline,
              size: 30,
              color: AppColors.primaryColor,
            ),
            selectedIcon: Icon(
              EneftyIcons.home_2_bold,
              size: 30,
              color: AppColors.primaryColor,
            ),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(
              EneftyIcons.location_outline,
              size: 30,
              color: AppColors.primaryColor,
            ),
            selectedIcon: Icon(
              EneftyIcons.location_bold,
              size: 30,
              color: AppColors.primaryColor,
            ),
            label: "Maps",
          ),
          NavigationDestination(
            icon: Icon(
              Icons.favorite_outline,
              size: 30,
              color: AppColors.primaryColor,
            ),
            selectedIcon: Icon(
              Icons.favorite,
              size: 30,
              color: AppColors.primaryColor,
            ),
            label: "Favorites",
          ),
          NavigationDestination(
            icon: Icon(
              EneftyIcons.user_outline,
              size: 30,
              color: AppColors.primaryColor,
            ),
            selectedIcon: Icon(
              EneftyIcons.user_bold,
              size: 30,
              color: AppColors.primaryColor,
            ),
            label: "Profile",
          ),
        ],
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
