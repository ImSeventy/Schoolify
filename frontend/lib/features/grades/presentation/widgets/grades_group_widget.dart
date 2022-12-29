import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/core/utils/extensions.dart';
import 'package:frontend/features/grades/presentation/widgets/grade.dart';

import '../../domain/entities/grade.py.dart';


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
    int colorIndex = ((percentage * percentageColors.length / 100) - 1).round();
    if (colorIndex < 0) colorIndex = 0;
    return percentageColors[colorIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 390.w,
      constraints: BoxConstraints(
        minHeight: 137.h,
      ),
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 15.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: const Color(0xFF130B51)),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          BackGroundStar(
            size: 25,
            offset: Offset(-35.w, 0.h),
          ),
          BackGroundStar(
            size: 35,
            offset: Offset(23.w, -8.h),
          ),
          BackGroundStar(
            size: 30,
            offset: Offset(63.w, 8.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(118.w, -5.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(200.w, 10.h),
          ),
          BackGroundStar(
            size: 28,
            offset: Offset(295.w, 0.h),
          ),
          BackGroundStar(
            size: 20,
            offset: Offset(-20.w, 50.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(30.w, 60.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(80.w, 55.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(150.w, 70.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(220.w, 50.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(250.w, 45.h),
          ),
          BackGroundStar(
            size: 35,
            offset: Offset(345.w, 60.h),
          ),
          BackGroundStar(
            size: 30,
            offset: Offset(-45.w, 95.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(10.w, 110.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(80.w, 102.h),
          ),
          BackGroundStar(
            size: 40,
            offset: Offset(160.w, 125.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(220.w, 120.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(320.w, 107.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(-25.w, 140.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(5.w, 165.h),
          ),
          BackGroundStar(
            size: 30,
            offset: Offset(50.w, 155.h),
          ),
          BackGroundStar(
            size: 45,
            offset: Offset(180.w, 176.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(100.w, 176.h),
          ),
          BackGroundStar(
            size: 30,
            offset: Offset(280.w, 187.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(320.w, 107.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(-25.w, 200.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(20.w, 255.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(70.w, 235.h),
          ),
          BackGroundStar(
            size: 40,
            offset: Offset(148.w, 220.h),
          ),
          BackGroundStar(
            size: 30,
            offset: Offset(220.w, 265.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(320.w, 107.h),
          ),
          BackGroundStar(
            size: 28,
            offset: Offset(305.w, 270.h),
          ),
          BackGroundStar(
            size: 40,
            offset: Offset(10.w, 300.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(55.w, 350.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(165.w, 325.h),
          ),
          BackGroundStar(
            size: 30,
            offset: Offset(245.w, 360.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(320.w, 107.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(-7.w, 340.h),
          ),
          BackGroundStar(
            size: 28,
            offset: Offset(15.w, 390.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(80.w, 420.h),
          ),
          BackGroundStar(
            size: 35,
            offset: Offset(180.w, 410.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(200.w, 450.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(320.w, 107.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(-10.w, 468.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(10.w, 430.h),
          ),
          BackGroundStar(
            size: 28,
            offset: Offset(60.w, 455.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(180.w, 430.h),
          ),
          BackGroundStar(
            size: 45,
            offset: Offset(280.w, 500.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(-35.w, 520.h),
          ),
          BackGroundStar(
            size: 35,
            offset: Offset(23.w, 530.h),
          ),
          BackGroundStar(
            size: 30,
            offset: Offset(63.w, 505.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(118.w, 535.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(200.w, 540.h),
          ),
          BackGroundStar(
            size: 28,
            offset: Offset(295.w, 545.h),
          ),
          BackGroundStar(
            size: 20,
            offset: Offset(-20.w, 550.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(30.w, 540.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(80.w, 555.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(150.w, 560.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(220.w, 570.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(250.w, 565.h),
          ),
          BackGroundStar(
            size: 35,
            offset: Offset(345.w, 580.h),
          ),
          BackGroundStar(
            size: 30,
            offset: Offset(-45.w, 575.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(10.w, 590.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(80.w, 600.h),
          ),
          BackGroundStar(
            size: 40,
            offset: Offset(160.w, 595.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(220.w, 610.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(320.w, 615.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(-25.w, 625.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(5.w, 620.h),
          ),
          BackGroundStar(
            size: 30,
            offset: Offset(50.w, 630.h),
          ),
          BackGroundStar(
            size: 45,
            offset: Offset(180.w, 640.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(100.w, 645.h),
          ),
          BackGroundStar(
            size: 30,
            offset: Offset(280.w, 660.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(320.w, 655.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(-25.w, 670.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(20.w, 680.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(70.w, 685.h),
          ),
          BackGroundStar(
            size: 40,
            offset: Offset(148.w, 690.h),
          ),
          BackGroundStar(
            size: 30,
            offset: Offset(220.w, 700.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(320.w, 710.h),
          ),
          BackGroundStar(
            size: 28,
            offset: Offset(305.w, 705.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(-35.w, 520.h),
          ),
          BackGroundStar(
            size: 35,
            offset: Offset(23.w, 530.h),
          ),
          BackGroundStar(
            size: 30,
            offset: Offset(63.w, 505.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(118.w, 535.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(200.w, 540.h),
          ),
          BackGroundStar(
            size: 28,
            offset: Offset(295.w, 545.h),
          ),
          BackGroundStar(
            size: 20,
            offset: Offset(-20.w, 550.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(30.w, 540.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(80.w, 555.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(150.w, 560.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(220.w, 570.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(250.w, 565.h),
          ),
          BackGroundStar(
            size: 35,
            offset: Offset(345.w, 580.h),
          ),
          BackGroundStar(
            size: 30,
            offset: Offset(-45.w, 575.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(10.w, 590.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(80.w, 600.h),
          ),
          BackGroundStar(
            size: 40,
            offset: Offset(160.w, 595.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(220.w, 610.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(320.w, 615.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(-25.w, 625.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(5.w, 620.h),
          ),
          BackGroundStar(
            size: 30,
            offset: Offset(50.w, 630.h),
          ),
          BackGroundStar(
            size: 45,
            offset: Offset(180.w, 640.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(100.w, 645.h),
          ),
          BackGroundStar(
            size: 30,
            offset: Offset(280.w, 660.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(320.w, 655.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(-25.w, 670.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(20.w, 680.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(70.w, 685.h),
          ),
          BackGroundStar(
            size: 40,
            offset: Offset(148.w, 690.h),
          ),
          BackGroundStar(
            size: 30,
            offset: Offset(220.w, 700.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(320.w, 710.h),
          ),
          BackGroundStar(
            size: 28,
            offset: Offset(305.w, 705.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(-35.w, 715.h),
          ),
          BackGroundStar(
            size: 35,
            offset: Offset(23.w, 725.h),
          ),
          BackGroundStar(
            size: 30,
            offset: Offset(63.w, 720.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(118.w, 740.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(200.w, 750.h),
          ),
          BackGroundStar(
            size: 28,
            offset: Offset(295.w, 760.h),
          ),
          BackGroundStar(
            size: 20,
            offset: Offset(-20.w, 780.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(30.w, 800.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(80.w, 815.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(150.w, 830.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(220.w, 825.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(250.w, 845.h),
          ),
          BackGroundStar(
            size: 35,
            offset: Offset(345.w, 860.h),
          ),
          BackGroundStar(
            size: 30,
            offset: Offset(-45.w, 875.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(10.w, 890.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(80.w, 910.h),
          ),
          BackGroundStar(
            size: 40,
            offset: Offset(160.w, 925.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(220.w, 935.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(320.w, 950.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(-25.w, 940.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(5.w, 965.h),
          ),
          BackGroundStar(
            size: 30,
            offset: Offset(50.w, 980.h),
          ),
          BackGroundStar(
            size: 45,
            offset: Offset(180.w, 1000.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(100.w, 1020.h),
          ),
          BackGroundStar(
            size: 30,
            offset: Offset(280.w, 1035.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(320.w, 1050.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(-25.w, 1070.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(20.w, 1085.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(70.w, 1100.h),
          ),
          BackGroundStar(
            size: 40,
            offset: Offset(148.w, 1125.h),
          ),
          BackGroundStar(
            size: 30,
            offset: Offset(220.w, 1120.h),
          ),
          BackGroundStar(
            size: 25,
            offset: Offset(320.w, 1150.h),
          ),
          BackGroundStar(
            size: 28,
            offset: Offset(305.w, 1175.h),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  "G${grades[0].gradeYear} ${grades[0].semester == 1 ? '1st' : '2nd'} Term",
                  style: context.theme.textTheme.bodyText1,
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              // Wrap(
              //   alignment: WrapAlignment.spaceBetween,
              //   runSpacing: 8.h,
              //   spacing: 10.w,
              //   children: [
              //     ...grades.map((grade) => GradeCard(grade: grade, color: getColor(getPercentage(grade),),)).toList(),
              //   ],
              // ),
              GridView.builder(
                itemCount: grades.length,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h,
                  crossAxisCount: 3,
                ),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  GradeEntity grade = grades[index];
                  return FittedBox(fit: BoxFit.scaleDown,child: GradeCard(grade: grade, color: getColor(getPercentage(grade),),));
                },
              ),
              SizedBox(
                height: 20.h,
              ),
              RichText(
                text: TextSpan(
                    text: "Total ",
                    style: context.theme.textTheme.subtitle1,
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
        color: context.colorScheme.secondary,
        size: size,
      ),
    );
  }
}
