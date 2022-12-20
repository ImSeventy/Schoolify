import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:frontend/core/widgets/cached_image_with_place_holder.dart';

class AvatarImage extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final File? image;
  const AvatarImage(
      {Key? key,
      required this.imageUrl,
      required this.width,
      required this.height,
      this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFCCC1F0),
          image: image == null
              ? null
              : DecorationImage(
                  image: FileImage(
                    image!,
                  ),
                  fit: BoxFit.cover,
                ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: image == null
            ? Conditional.single(
          context: context,
          conditionBuilder: (BuildContext context) => imageUrl == null || imageUrl == "",
          widgetBuilder: (BuildContext context) => Image.asset(
            "assets/default_profile.png",
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
          fallbackBuilder: (BuildContext context) => CachedImageWithPlaceHolder(
            imageUrl: imageUrl!,
            width: width,
            height: height,
            fit: BoxFit.cover,
            placeHolderAssetPath: 'assets/profile_placeholder.png',
          ),
        ) : null,
      ),
    );
  }
}
