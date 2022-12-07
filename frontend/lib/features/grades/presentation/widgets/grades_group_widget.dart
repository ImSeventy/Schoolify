import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../domain/entities/grade.py.dart';

const colors = [
  Color(0xFFEE6482),
  Color(0xFFF3CFC5),
  Color(0xFF40E1D1),
];


class GradesGroupWidget extends StatelessWidget {
  final List<GradeEntity> grades;
  const GradesGroupWidget({Key? key, required this.grades}) : super(key: key);

  double getPercentage(GradeEntity grade) {
    return (grade.grade / max(grade.fullDegree, 1)) * 100;
  }

  double get totalPercentage {
    return grades.map(getPercentage).reduce((a, b) => a + b) / grades.length;
  }

  Color getColor(double percentage) {
    int colorIndex = ((percentage * colors.length / 100) - 1).round();
    if (colorIndex < 0) colorIndex = 0;
    return colors[colorIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 390.w,
      constraints: BoxConstraints(
        minHeight: 137.h,
      ),
      padding: EdgeInsets.only(left: 30.w, top: 8.h, bottom: 8.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: const Color(0xFF130B51)),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          BackGroundStar(size: 25, offset: Offset(-35.w, 0.h),),
          BackGroundStar(size: 35, offset: Offset(23.w, -8.h),),
          BackGroundStar(size: 30, offset: Offset(63.w, 8.h),),
          BackGroundStar(size: 25, offset: Offset(118.w, -5.h),),
          BackGroundStar(size: 25, offset: Offset(200.w, 10.h),),
          BackGroundStar(size: 28, offset: Offset(295.w, 0.h),),
          BackGroundStar(size: 20, offset: Offset(-20.w, 50.h),),
          BackGroundStar(size: 25, offset: Offset(30.w, 60.h),),
          BackGroundStar(size: 25, offset: Offset(80.w, 55.h),),
          BackGroundStar(size: 25, offset: Offset(150.w, 70.h),),
          BackGroundStar(size: 25, offset: Offset(220.w, 50.h),),
          BackGroundStar(size: 25, offset: Offset(250.w, 45.h),),
          BackGroundStar(size: 35, offset: Offset(345.w, 60.h),),
          BackGroundStar(size: 30, offset: Offset(-45.w, 95.h),),
          BackGroundStar(size: 25, offset: Offset(10.w, 110.h),),
          BackGroundStar(size: 25, offset: Offset(80.w, 102.h),),
          BackGroundStar(size: 40, offset: Offset(160.w, 125.h),),
          BackGroundStar(size: 25, offset: Offset(220.w, 120.h),),
          BackGroundStar(size: 25, offset: Offset(320.w, 107.h),),
          BackGroundStar(size: 25, offset: Offset(-25.w, 140.h),),
          BackGroundStar(size: 25, offset: Offset(5.w, 165.h),),
          BackGroundStar(size: 30, offset: Offset(50.w, 155.h),),
          BackGroundStar(size: 45, offset: Offset(180.w, 176.h),),
          BackGroundStar(size: 25, offset: Offset(100.w, 176.h),),
          BackGroundStar(size: 30, offset: Offset(280.w, 187.h),),
          BackGroundStar(size: 25, offset: Offset(320.w, 107.h),),
          BackGroundStar(size: 25, offset: Offset(-25.w, 200.h),),
          BackGroundStar(size: 25, offset: Offset(20.w, 255.h),),
          BackGroundStar(size: 25, offset: Offset(70.w, 235.h),),
          BackGroundStar(size: 40, offset: Offset(148.w, 220.h),),
          BackGroundStar(size: 30, offset: Offset(220.w, 265.h),),          BackGroundStar(size: 25, offset: Offset(320.w, 107.h),),
          BackGroundStar(size: 28, offset: Offset(305.w, 270.h),),
          BackGroundStar(size: 40, offset: Offset(10.w, 300.h),),
          BackGroundStar(size: 25, offset: Offset(55.w, 350.h),),
          BackGroundStar(size: 25, offset: Offset(165.w, 325.h),),
          BackGroundStar(size: 30, offset: Offset(245.w, 360.h),),          BackGroundStar(size: 25, offset: Offset(320.w, 107.h),),
          BackGroundStar(size: 25, offset: Offset(-7.w, 340.h),),
          BackGroundStar(size: 28, offset: Offset(15.w, 390.h),),
          BackGroundStar(size: 25, offset: Offset(80.w, 420.h),),
          BackGroundStar(size: 35, offset: Offset(180.w, 410.h),),
          BackGroundStar(size: 25, offset: Offset(200.w, 450.h),),          BackGroundStar(size: 25, offset: Offset(320.w, 107.h),),
          BackGroundStar(size: 25, offset: Offset(-10.w, 468.h),),
          BackGroundStar(size: 25, offset: Offset(10.w, 430.h),),
          BackGroundStar(size: 28, offset: Offset(60.w, 455.h),),
          BackGroundStar(size: 25, offset: Offset(180.w, 430.h),),
          BackGroundStar(size: 45, offset: Offset(280.w, 500.h),),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  "G${grades[0].gradeYear} ${grades[0].semester == 1 ? '1st' : '2nd'} Term",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 21.sp,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              Wrap(
                children: [
                  ...grades.map(
                        (grade) => Padding(
                      padding: EdgeInsets.only(right: 16.w, bottom: 9.h),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: "${grade.subjectName.toUpperCase()}\n",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.bold,
                                fontSize: 21.sp),
                            children: [
                              TextSpan(
                                  text: grade.grade.toString(),
                                  style: TextStyle(
                                      color: getColor(getPercentage(grade)),
                                      fontWeight: FontWeight.w500)),
                              TextSpan(
                                  text: "/${grade.fullDegree}",
                                  style: TextStyle(fontWeight: FontWeight.w500))
                            ]),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
              RichText(
                text: TextSpan(
                    text: "Total ",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 24.sp,
                        fontFamily: "Poppins"),
                    children: [
                      TextSpan(
                          text: "${totalPercentage.toStringAsFixed(2)}%",
                          style: const TextStyle(color: Color(0xFFF1CEC4)))
                    ]),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class BackGroundStar extends StatelessWidget {
  final double size;
  final Offset offset;
  const BackGroundStar({
    Key? key,
    required this.size,
    required this.offset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: offset,
      child: Icon(
        Icons.star_rounded,
        color: const Color(0xFF132C71),
        size: size,
      ),
    );
  }
}
