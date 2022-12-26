import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/constants/fonts.dart';

const Color kPrimaryColor = Color(0xFF130B51);

const Color kSecondaryColor = Color(0xFF132C71);

class LightThemeWrapper extends StatelessWidget {
  final Widget child;
  const LightThemeWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(428, 926),
        minTextAdapt: true,
        builder: (context, _) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: Theme(
              data: ThemeData(
                brightness: Brightness.light,
                primaryColor: kPrimaryColor,
                scaffoldBackgroundColor: const Color(0xFF131524),
                appBarTheme: AppBarTheme(
                    color: kPrimaryColor,
                    titleTextStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.sp)),
                textTheme: TextTheme(
                    bodyText1: TextStyle(
                      fontSize: 20.sp,
                      fontFamily: Fonts.primaryFont,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    bodyText2: TextStyle(
                      color: const Color(0xFFCCC1F0),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    headline1: TextStyle(
                      color: Colors.white,
                      fontSize: 45.sp,
                      fontFamily: Fonts.primaryFont,
                      fontWeight: FontWeight.w500,
                    ),
                    headline2: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: Fonts.primaryFont,
                      fontSize: 30.sp,
                      color: Colors.white,
                    ),
                    headline3: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: Fonts.primaryFont,
                      fontSize: 16.sp,
                      color: Colors.white.withOpacity(
                        0.8,
                      ),
                    ),
                    button: TextStyle(
                      fontFamily: Fonts.primaryFont,
                      fontWeight: FontWeight.w400,
                      fontSize: 35.sp,
                      color: Colors.black,
                    ),
                    headline4: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontFamily: Fonts.primaryFont,),
                    subtitle1: TextStyle(
                      fontFamily: Fonts.primaryFont,
                      fontWeight: FontWeight.w500,
                      fontSize: 24.sp,
                      color: Colors.white,
                    ),
                    subtitle2: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                      fontSize: 17.sp,
                      color: Colors.white
                    ),
                    caption: TextStyle(fontSize: 13.sp, color: Colors.grey)),
                colorScheme: const ColorScheme.light().copyWith(
                    primary: kPrimaryColor,
                    secondary: kSecondaryColor,
                    onPrimary: Colors.white,
                    primaryContainer: const Color(0xFF4D4395),
                    secondaryContainer: const Color(0xFF100848),
                    background: const Color(0xFF111E4B),
                    onBackground: Colors.white,
                    shadow: const Color(0xFFB9B9B9),
                    onSurface: const Color(0xFF2d407b),
                    error: Colors.red,
                    onPrimaryContainer: const Color(0xFFF06482),
                    outline: const Color(0xFF306767),
                    tertiary: const Color(0xFF40E1D1),
                    onTertiary: Colors.white,
                ),
                textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                        primary: kPrimaryColor,
                        padding: EdgeInsets.symmetric(
                            vertical: 15.h, horizontal: 55.w),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        backgroundColor: Colors.white)),
                inputDecorationTheme: InputDecorationTheme(
                  hintStyle: TextStyle(
                    fontSize: 20.sp,
                    fontFamily: "Overpass",
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF544E4E),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      10.r,
                    ),
                  ),
                  fillColor: const Color(0xFFC3E5D1),
                  filled: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                ),
                floatingActionButtonTheme: FloatingActionButtonThemeData(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    sizeConstraints:
                        BoxConstraints(minHeight: 50.h, minWidth: 50.w),
                    iconSize: 20.sp),
              ),
              child: child,
            ),
          );
        });
  }
}
