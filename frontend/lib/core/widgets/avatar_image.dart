import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/core/widgets/cached_image_with_place_holder.dart';

class AvatarImage extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  const AvatarImage({Key? key, required this.imageUrl, required this.width, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Container(
        decoration: const BoxDecoration(
            shape: BoxShape.circle, color: Color(0xFFCCC1F0)),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: imageUrl == null || imageUrl == ""
            ? Image.asset(
          "assets/default_profile.png",
          width: width,
          height: height,
          fit: BoxFit.contain,
        )
            : CachedImageWithPlaceHolder(
          imageUrl: imageUrl!,
          width: width,
          height: height,
          fit: BoxFit.contain,
          placeHolderAssetPath: 'assets/profile_placeholder.png',
        ),
      ),
    );
  }
}
