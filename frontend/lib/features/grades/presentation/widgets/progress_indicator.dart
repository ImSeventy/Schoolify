import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/core/utils/extensions.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../core/constants/constants.dart';


class FancyProgressIndicator extends StatelessWidget {
  final Color backgroundColor;
  final double percentage;
  final String name;

  const FancyProgressIndicator({Key? key, required this.backgroundColor, required this.percentage, required this.name,}) : super(key: key);

  get color {
    int colorIndex = ((percentage * percentageColors.length / 100) - 1).round();
    if (colorIndex < 0) colorIndex = 0;
    return percentageColors[colorIndex];
  }

  bool getPieceState(int pieceIndex) {
     bool state = (percentage * 9 / 100) >= pieceIndex;

     if (!state) {
       if (pieceIndex == 1 && percentage > 0) {
         return true;
       }
     }

     return state;
  }

  Color getPieceColor(int pieceIndex) {
    if (getPieceState(pieceIndex)) return color;

    return backgroundColor;
  }

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
        radius: 80,
        progressColor: color,
        backgroundColor: backgroundColor,
        percent: percentage / 100,
        lineWidth: 18,
        animation: true,
        center: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ProgressDotPiece(color: getPieceColor(9),),
            ProgressRectanglePiece(width: 35, color: getPieceColor(8),),
            ProgressRectanglePiece(width: 77, color: getPieceColor(7),),
            ProgressRectanglePiece(width: 93, color: getPieceColor(6),),
            ProgressRectanglePiece(width: 113, color: getPieceColor(5),),
            ProgressRectanglePiece(width: 93, color: getPieceColor(4),),
            ProgressRectanglePiece(width: 77, color: getPieceColor(3),),
            ProgressRectanglePiece(width: 35, color: getPieceColor(2),),
            ProgressDotPiece(color: getPieceColor(1),),
          ],
        ),
        footer: Column(
          children: [
            const SizedBox(height: 8,),
            RichText(
              text: TextSpan(
                text: "$name  ",
                style: context.theme.textTheme.bodyText1,
                children: [
                  TextSpan(
                    text: "${percentage.toStringAsFixed(1)} %",
                    style: TextStyle(
                      color: color
                    )
                  )
                ]
              ),
            ),
          ],
        ),
        animateFromLastPercent: true,
        animationDuration: 1000,
        circularStrokeCap: CircularStrokeCap.round
    );
  }
}


class ProgressDotPiece extends StatelessWidget {
  final Color color;
  const ProgressDotPiece({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.circle,
      size: 15,
      color: color,
    );
  }
}



class ProgressRectanglePiece extends StatelessWidget {
  final double width;
  final Color color;

  const ProgressRectanglePiece({Key? key, required this.width, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      margin: EdgeInsets.symmetric(vertical: 3.h),
      width: width,
      height: 6,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12)
      ),
    );
  }
}

