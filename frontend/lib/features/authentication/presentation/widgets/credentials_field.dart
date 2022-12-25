import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/core/constants/fonts.dart';

class CredentialsField extends StatelessWidget {
  final bool isPassword;
  final String hintText;
  final TextEditingController textEditingController;
  final String? Function(String? value)? validator;
  final bool enabled;

  const CredentialsField(
      {Key? key,
      required this.isPassword,
      required this.hintText,
      required this.textEditingController,
      this.validator,
      this.enabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70.h,
      width: 310.w,
      child: TextFormField(
        validator: validator,
        enabled: enabled,
        obscureText: isPassword,
        keyboardType: isPassword
            ? TextInputType.visiblePassword
            : TextInputType.emailAddress,
        controller: textEditingController,
        style: Theme.of(context).textTheme.bodyText1?.copyWith(
          color: const Color(0xFF544E4E),
          fontWeight: FontWeight.w400,
          fontFamily: Fonts.secondaryFont
        ),
        decoration: InputDecoration(
          hintText: hintText,
        ),
      ),
    );
  }
}
