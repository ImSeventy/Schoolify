import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/core/utils/extensions.dart';
import 'package:frontend/features/warnings/domain/entities/warning_entity.dart';
import 'package:readmore/readmore.dart';

class WarningWidget extends StatelessWidget {
  final WarningEntity warningEntity;
  const WarningWidget({Key? key, required this.warningEntity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 339.w,
      constraints: BoxConstraints(
        minHeight: 131.h,
      ),
      margin: EdgeInsets.only(bottom: 13.h),
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 13.h),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          RotatedCube(
            rotationAngle: 20.17,
            width: 57.97.w,
            height: 44.29.h,
            offset: Offset(0, -50.h),
          ),
          RotatedCube(
            rotationAngle: 20.17,
            width: 41.73.w,
            height: 31.54.h,
            offset: Offset(120.w, -20.h),
          ),
          RotatedCube(
            rotationAngle: 20.17,
            width: 30.4.w,
            height: 20.86.h,
            offset: Offset(40.w, 20.h),
          ),
          RotatedCube(
            rotationAngle: 20.17,
            width: 51.22.w,
            height: 39.74.h,
            offset: Offset(110.w, 55.h),
          ),
          RotatedCube(
            rotationAngle: 20.17,
            width: 50.59.w,
            height: 36.54.h,
            offset: Offset(-55.w, 25.h),
          ),
          RotatedCube(
            rotationAngle: 20.17,
            width: 50.56.w,
            height: 36.83.h,
            offset: Offset(-110.w, -35.h),
          ),
          RotatedCube(
            rotationAngle: 20.17,
            width: 40.9.w,
            height: 38.08.h,
            offset: Offset(-110.w, 60.h),
          ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReadMoreText(
              warningEntity.content,
              trimLines: 2,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'Show more',
              trimExpandedText: ' Show less',
              moreStyle: TextStyle(color: Theme.of(context).colorScheme.shadow),
              lessStyle: TextStyle(color: Theme.of(context).colorScheme.shadow),
              delimiter: ".... ",
              style: Theme.of(context).textTheme.subtitle2,
            ),
            SizedBox(height: 30.h,),
            Row(
              children: [
                const Spacer(),
                Text(
                  warningEntity.date.dateFormat,
                  style: Theme.of(context).textTheme.subtitle2?.copyWith(
                    color: const Color(0XFFD45A76),
                  ),
                ),
              ],
            ),
          ],
        )
        ],
      ),
    );
  }
}

class RotatedCube extends StatelessWidget {
  final double rotationAngle;
  final Offset offset;
  final double width;
  final double height;
  const RotatedCube({
    Key? key,
    required this.rotationAngle,
    required this.offset,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: offset,
      child: Transform.rotate(
        angle: rotationAngle * (pi / 180),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF18357F).withOpacity(0.44),
                  const Color(0xFF0F2767)
                ],
              ),
              borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
