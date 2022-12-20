import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImageWithPlaceHolder extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final String placeHolderAssetPath;
  const CachedImageWithPlaceHolder({
    Key? key,
    required this.imageUrl,
    required this.width,
    required this.height,
    required this.fit,
    required this.placeHolderAssetPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (_, __) => Image.asset(
        placeHolderAssetPath,
        width: width,
        height: height,
        fit: fit,
      ),
      errorWidget: (_, __, ___) => Image.asset(
        placeHolderAssetPath,
        width: width,
        height: height,
        fit: fit,
      ),
    );
  }
}
