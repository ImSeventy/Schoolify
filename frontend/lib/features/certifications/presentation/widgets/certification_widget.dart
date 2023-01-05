import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/core/constants/images_paths.dart';
import 'package:frontend/core/utils/extensions.dart';
import 'package:frontend/features/certifications/domain/entities/certification_entity.dart';
import 'package:readmore/readmore.dart';

import '../../../../core/widgets/avatar_image.dart';
import '../../../../core/widgets/zoomable_cached_image.dart';

class CertificationWidget extends StatelessWidget {
  final CertificationEntity certificationEntity;
  const CertificationWidget({
    Key? key,
    required this.certificationEntity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 48.5.w, left: 48.5.w, top: 25.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AvatarImage(
                imageUrl: certificationEntity.givenByImageUrl,
                width: 62.w,
                height: 64.h,
              ),
              SizedBox(
                width: 7.w,
              ),
              RichText(
                text: TextSpan(
                    text: "Certified by \n",
                    style: context.theme.textTheme.headline3?.copyWith(
                          color: context.colorScheme.onBackground,
                        ),
                    children: [
                      TextSpan(
                        text: certificationEntity.givenByName,
                        style: TextStyle(
                          color: context.colorScheme.shadow,
                        ),
                      )
                    ]),
              )
            ],
          ),
          SizedBox(
            height: 8.h,
          ),
          ReadMoreText(
            certificationEntity.content,
            style: context.theme.textTheme.headline3?.copyWith(
                  color: context.colorScheme.onBackground,
                ),
            trimLines: 2,
            trimMode: TrimMode.Line,
            trimCollapsedText: "Read more",
            trimExpandedText: "  Read less",
            delimiter: "....",
            moreStyle: context.theme.textTheme.headline4?.copyWith(
                  color: context.colorScheme.shadow,
                ),
            lessStyle: context.theme.textTheme.headline4?.copyWith(
              color: context.colorScheme.shadow,
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          Stack(
            children: [
              Container(
                width: 600.w,
                height: 350.h,
                color: Colors.grey[900],
                padding: EdgeInsets.symmetric(horizontal: 44.w, vertical: 44.h),
                child: Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    LayoutBuilder(
                      builder: (_, constrains) {
                        return ZoomableCachedImage(
                          imageUrl: certificationEntity.imageUrl!,
                          width: constrains.maxWidth,
                          height: constrains.maxHeight,
                          zoomHeight: 400,
                          zoomWidth: 600,
                          fit: BoxFit.fill,
                          placeHolderAssetPath: ImagesPaths.imagePlaceholder,
                        );
                      },
                    ),
                    Transform.translate(
                      offset: Offset(20.w, 30.h),
                      child: Align(
                          alignment: Alignment.bottomRight,
                          child: SvgPicture.asset(
                            ImagesPaths.certificate,
                            width: 71.w,
                            height: 71.h,
                          )),
                    )
                  ],
                ),
              ),
              Transform.translate(
                offset: Offset(13.w, 0),
                child: SvgPicture.asset(
                  ImagesPaths.stars,
                  width: 35.w,
                  height: 42.h,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
