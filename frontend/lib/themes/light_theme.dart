import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const Color kPrimaryColor = Color.fromRGBO(45, 121, 224, 1);

class LightThemeWrapper extends StatelessWidget {
  final Widget child;
  const LightThemeWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        context,
        designSize: const Size(428, 926),
        minTextAdapt: true,
        splitScreenMode: true
    );
    return Theme(
      data: ThemeData(
        brightness: Brightness.light,
        primaryColor: kPrimaryColor,
        appBarTheme: AppBarTheme(
            color: kPrimaryColor,
            titleTextStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30.sp
            )
        ),
        textTheme: TextTheme(
            headline1: TextStyle(
                fontSize: 45.sp,
                color: Colors.white,
                fontWeight: FontWeight.w400
            ),
            headline2: TextStyle(
                fontSize: 40.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black
            ),
            headline3: TextStyle(
                fontSize: 22.sp,
                color: Colors.black
            ),
            button: const TextStyle(
                color: Colors.grey
            ),
            headline4: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black
            ),
            bodyText1: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w400,
            ),
            subtitle1: TextStyle(
                color: Colors.black,
                fontSize: 15.sp
            ),
            caption: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey
            )
        ),
        colorScheme: const ColorScheme.light().copyWith(
            primary: kPrimaryColor,
            secondary: Colors.lightBlueAccent,
            onPrimary: Colors.white,
            primaryContainer: Colors.grey[400],
            secondaryContainer: Colors.grey[200],
            onBackground: Colors.black
        ),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
                primary: kPrimaryColor,
                padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 55.w),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                backgroundColor: Colors.white
            )
        ),
        inputDecorationTheme: InputDecorationTheme(
            hintStyle: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 20.sp
            ),
            border: InputBorder.none,
            filled: false
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            sizeConstraints: BoxConstraints(minHeight: 50.h, minWidth: 50.w),
            iconSize: 20.sp
        ),
      ),
      child: child,
    );
  }
}