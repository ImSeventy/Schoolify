import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/core/utils/extensions.dart';

class NextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLastPage;

  const NextButton({Key? key, required this.onPressed, required this.isLastPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 177.w,
        height: 59.h,
        padding: EdgeInsets.symmetric(horizontal: 35.w, vertical: 3.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [
            Color(0xFF0064D9),
            Color(0xFF0017E9),
          ]),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isLastPage ? "Start" : "Next",
              style: context.theme.textTheme.button?.copyWith(
                color: Colors.white,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 25.sp,
            ),
          ],
        ),
      ),
    );
  }
}
