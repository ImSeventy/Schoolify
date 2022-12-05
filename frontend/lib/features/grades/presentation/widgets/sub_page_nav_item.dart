import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SubPageNavItem extends StatelessWidget {

  final void Function() onTap;
  final String label;
  final Color iconColor;
  final String iconPath;

  const SubPageNavItem({
    Key? key,
    required this.onTap,
    required this.label,
    required this.iconColor,
    required this.iconPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 160.w,
        height: 52.h,
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        decoration: BoxDecoration(
            color: const Color(0xFF111E4B),
            borderRadius: BorderRadius.circular(6)),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              height: 40.h,
              color: iconColor,
            ),
            SizedBox(
              width: 12.w,
            ),
            Expanded(
              child: FittedBox(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Poppins",
                      color: const Color(0xFFBAC5C5)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
