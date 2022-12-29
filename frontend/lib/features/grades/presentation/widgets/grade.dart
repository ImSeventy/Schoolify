import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/core/utils/extensions.dart';
import 'package:frontend/features/grades/domain/entities/grade.py.dart';

class GradeCard extends StatelessWidget {
  final GradeEntity grade;
  final Color color;

  const GradeCard({
    Key? key,
    required this.grade,
    required this.color,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: "${grade.subjectName.toUpperCase()}\n",
          style: context.theme
              .textTheme
              .bodyText1
              ?.copyWith(fontWeight: FontWeight.bold),
          children: [
            TextSpan(
                text: grade.grade.toString(),
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w500)),
            TextSpan(
                text: "/${grade.fullDegree}",
                style: const TextStyle(fontWeight: FontWeight.w500))
          ]),
    );
  }
}
