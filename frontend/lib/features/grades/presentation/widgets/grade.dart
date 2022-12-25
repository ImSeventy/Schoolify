import 'package:flutter/material.dart';
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
          style: Theme.of(context)
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
