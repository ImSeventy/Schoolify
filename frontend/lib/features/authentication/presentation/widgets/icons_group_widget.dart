import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class IconsGroupWidget extends StatelessWidget {
  final int flex;
  final String imagePath;
  final Alignment alignment;

  const IconsGroupWidget({
    Key? key,
    required this.flex,
    required this.imagePath,
    required this.alignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Align(
        alignment: alignment,
        child: SvgPicture.asset(
          imagePath,
          allowDrawingOutsideViewBox: false,
          alignment: alignment,
        ),
      ),
    );
  }
}
