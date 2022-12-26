import 'package:flutter/material.dart';

class TextWithStroke extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final double strokeWidth;
  final Color strokeColor;
  const TextWithStroke({Key? key, required this.text, required this.style, required this.strokeWidth, required this.strokeColor,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          style: style?.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = strokeColor,
          ),
        ),
        Text(
          text,
          style: style,
        ),
      ],
    );
  }
}
