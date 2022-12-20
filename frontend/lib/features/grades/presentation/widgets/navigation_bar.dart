import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomNavigationBar extends StatelessWidget {
  final int initialIndex;
  final void Function(int) onTap;

  const CustomNavigationBar({
    Key? key,
    required this.onTap,
    required this.initialIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75.h,
      padding: EdgeInsets.symmetric(horizontal: 23.h),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [Color(0xFF23263E), Color(0xFF373C61), Color(0xFF20233B)]),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      clipBehavior: Clip.hardEdge,
      child: GNav(
        selectedIndex: initialIndex,
        backgroundColor: Colors.transparent,
        tabBorderRadius: 10,
        curve: Curves.linear, // tab animation curves
        duration: const Duration(milliseconds: 200), // tab animation duration
        gap: 10, // the tab button gap between icon and text
        color: const Color(0xFF40E1D1), // unselected icon color
        activeColor: const Color(0xFF40E1D1), // selected icon and text color
        iconSize: 24, // tab button icon size
        tabBackgroundColor:
            const Color(0xFF133398), // selected tab background color
        padding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 10), // navigation bar padding
        tabs: const [
          GButton(
            icon: FontAwesomeIcons.house,
            text: 'Home',
          ),
          GButton(
            icon: FontAwesomeIcons.clipboardUser,
            text: 'Attendance',
          ),
          GButton(
            icon: FontAwesomeIcons.squarePollHorizontal,
            text: 'Grades',
          ),
          GButton(
            icon: FontAwesomeIcons.message,
            text: 'Feed',
          )
        ],
        onTabChange: onTap,
      ),
    );
  }
}
