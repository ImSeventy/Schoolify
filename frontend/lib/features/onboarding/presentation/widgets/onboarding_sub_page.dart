import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/core/utils/extensions.dart';

class OnBoardingSubPage extends StatelessWidget {
  final String imagePath;
  final String text;
  const OnBoardingSubPage({Key? key, required this.imagePath, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Image.asset(
            imagePath,
            height: 320.h,
            width: double.infinity,
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          "Welcome to Schoolify!",
          style: context.theme.textTheme.headline2?.copyWith(
            color: const Color(0xFF4FDBCD),
          ),
        ),
        SizedBox(height: 12.h),
        Expanded(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            maxLines: 7,
            style: context.theme.textTheme.subtitle1,
          ),
        ),
      ],
    );
  }
}
