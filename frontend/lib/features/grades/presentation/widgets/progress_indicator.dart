import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class FancyProgressIndicator extends StatelessWidget {
  final List<Color> colors;
  final Color backgroundColor;
  final double percentage;
  final String name;

  const FancyProgressIndicator({Key? key, required this.colors, required this.backgroundColor, required this.percentage, required this.name,}) : super(key: key);

  get color {
    int colorIndex = ((percentage * colors.length / 100) - 1).round();
    return colors[colorIndex];
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
        radius: 100.r,
        progressColor: color,
        backgroundColor: backgroundColor,
        percent: percentage / 100,
        lineWidth: 18,
        animation: true,
        center: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ProgressDotPiece(color: getPieceColor(9),),
            ProgressRectanglePiece(width: 35.w, color: getPieceColor(8),),
            ProgressRectanglePiece(width: 77.w, color: getPieceColor(7),),
            ProgressRectanglePiece(width: 93.w, color: getPieceColor(6),),
            ProgressRectanglePiece(width: 113.w, color: getPieceColor(5),),
            ProgressRectanglePiece(width: 93.w, color: getPieceColor(4),),
            ProgressRectanglePiece(width: 77.w, color: getPieceColor(3),),
            ProgressRectanglePiece(width: 35.w, color: getPieceColor(2),),
            ProgressDotPiece(color: getPieceColor(1),),
          ],
        ),
        footer: Column(
          children: [
            SizedBox(height: 10.h,),
            RichText(
              text: TextSpan(
                text: "$name  ",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20.sp,
                  fontFamily: "Poppins",
                  color: Colors.white
                ),
                children: [
                  TextSpan(
                    text: "$percentage %",
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
      size: 20.sp,
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
      height: 8.h,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12)
      ),
    );
  }
}

