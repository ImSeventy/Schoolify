import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginSubmitButton extends StatelessWidget {
  final List<Color> colors;
  final bool enabled;
  final VoidCallback onPressed;
  const LoginSubmitButton({Key? key, required this.colors, required this.enabled, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 310.w,
      height: 70.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(colors: colors)),
      child: TextButton(
        style: TextButton.styleFrom(
            backgroundColor: Colors.transparent),
        onPressed: enabled ? onPressed : null,
        child: enabled
            ? FittedBox(
          child: Text(
            "login",
            style: TextStyle(
                fontFamily: "Overpass",
                fontWeight: FontWeight.w400,
                fontSize: 35.sp,
                color: Colors.black),
          ),
        )
            : const FittedBox(child: CircularProgressIndicator(color: Colors.black,)),
      ),
    );
  }
}
