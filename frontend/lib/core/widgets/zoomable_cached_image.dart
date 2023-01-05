import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/core/constants/images_paths.dart';

import 'cached_image_with_place_holder.dart';

class ZoomableCachedImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final double zoomHeight;
  final double zoomWidth;
  final BoxFit fit;
  final String placeHolderAssetPath;
  const ZoomableCachedImage({
    Key? key,
    required this.imageUrl,
    required this.width,
    required this.height,
    required this.fit,
    required this.placeHolderAssetPath,
    this.zoomHeight = 650,
    this.zoomWidth = 400
  }) : super(key: key);

  void showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            width: zoomWidth.w,
            height: zoomHeight.h,
            child: InteractiveViewer(
              minScale: 0.5,
              child: CachedImageWithPlaceHolder(
                imageUrl: imageUrl!,
                width: 400.w,
                height: 650.h,
                fit: fit,
                placeHolderAssetPath: ImagesPaths.imagePlaceholder,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showImageDialog(context),
      child: CachedImageWithPlaceHolder(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeHolderAssetPath: ImagesPaths.imagePlaceholder,
      ),
    );
  }
}
