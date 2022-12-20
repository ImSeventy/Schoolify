import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class CustomPaintedBackground extends StatelessWidget {
  const CustomPaintedBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return CustomPaint(
      painter: CustomPaintedBackgroundPainter(),
      size: screenSize,
    );
  }
}


class CustomPaintedBackgroundPainter extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {



    Paint paint0 = Paint()
      ..color = const Color(0xFF000350)
      ..style = PaintingStyle.fill;
    paint0.shader = ui.Gradient.linear(Offset(0, size.height),Offset(size.width, size.height*0.92),const [Color(0xFF101010), Color(0xFF000350)]);

    Path path0 = Path();
    path0.moveTo(0,size.height*1.0090817);
    path0.lineTo(0,size.height*0.4956357);
    path0.lineTo(size.width*0.0186916,size.height*0.4957114);
    path0.quadraticBezierTo(size.width*0.0258178,size.height*0.2718718,size.width*0.0490654,size.height*0.2648840);
    path0.cubicTo(size.width*0.1363318,size.height*0.2665111,size.width*0.8365187,size.height*0.2658047,size.width*0.9418224,size.height*0.2654263);
    path0.cubicTo(size.width*0.9797664,size.height*0.2789102,size.width*0.9698832,size.height*0.1508325,size.width*0.9813084,size.height*0.1115035);
    path0.quadraticBezierTo(size.width*0.9938551,size.height*0.1065086,size.width,size.height*0.1117684);
    path0.lineTo(size.width,size.height*1.0074041);

    canvas.drawPath(path0, paint0);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}

