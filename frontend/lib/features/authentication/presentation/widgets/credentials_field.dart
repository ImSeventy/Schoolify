import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CredentialsField extends StatelessWidget {
  final bool isPassword;
  final String hintText;
  final TextEditingController textEditingController;
  final String? Function(String? value)? validator;
  final bool enabled;

  const CredentialsField({
    Key? key,
    required this.isPassword,
    required this.hintText,
    required this.textEditingController,
    this.validator,
    this.enabled = true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70.h,
      width: 310.w,
      child: TextFormField(
        validator: validator,
        enabled: enabled,
        obscureText: isPassword,
        keyboardType: isPassword ? TextInputType.visiblePassword : TextInputType.emailAddress,
        controller: textEditingController,
        style: TextStyle(
            fontSize: 20.sp,
            fontFamily: "Overpass",
            fontWeight: FontWeight.w400,
            color: const Color(0xFF544E4E)),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
          filled: true,
          fillColor: const Color(0xFFC3E5D1),
          hintText: hintText,
          hintStyle: TextStyle(
              fontSize: 20.sp,
              fontFamily: "Overpass",
              fontWeight: FontWeight.w400,
              color: const Color(0xFF544E4E)),
          contentPadding:
              EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
        ),
      ),
    );
  }
}
