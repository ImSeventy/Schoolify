import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AnimatedHeart extends StatefulWidget {
  final bool isLiked;

  const AnimatedHeart({Key? key, required this.isLiked}) : super(key: key);

  @override
  State<AnimatedHeart> createState() => _AnimatedHeartState();
}

class _AnimatedHeartState extends State<AnimatedHeart> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _animation = Tween<double>(begin: 1, end: 1.2).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AnimatedHeart oldWidget) {
    if (widget.isLiked != oldWidget.isLiked) {
      _animationController.forward().then((value) => _animationController.reverse());
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {

    return ScaleTransition(
      scale: _animation,
      child: SvgPicture.asset(
        "assets/like_heart.svg",
        color: widget.isLiked ? const Color(0xFFFF269B) : Colors.grey,
      ),
    );
  }
}
