import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/features/certifications/domain/entities/certification_entity.dart';
import 'package:readmore/readmore.dart';

import '../../../../core/widgets/avatar_image.dart';

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
              SizedBox(width: 7.w,),
              RichText(
                text: TextSpan(
                  text: "Certified by \n",
                  style: TextStyle(
                    color: const Color(0xFFE7E7E7),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins"
                  ),
                  children: [
                    TextSpan(
                      text: certificationEntity.givenByName,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    )
                  ]
                ),
              )
            ],
          ),
          SizedBox(height: 8.h,),
          ReadMoreText(
            certificationEntity.content,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              fontFamily: "Poppins"
            ),
            trimLines: 2,
            trimMode: TrimMode.Line,
            trimCollapsedText: "Read more",
            trimExpandedText: "  Read less",
            delimiter: "....",
            moreStyle: TextStyle(
              color: const Color(0xFFBDBDBD),
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              fontFamily: "Poppins"
            ),
            lessStyle: TextStyle(
                color: const Color(0xFFBDBDBD),
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                fontFamily: "Poppins"
            ),
          ),
          SizedBox(height: 8.h,),
          Stack(
            children: [
              Container(
                width: 331.w,
                height: 453.h,
                color: Colors.grey[900],
                padding: EdgeInsets.symmetric(horizontal: 44.w, vertical: 44.h),
                child: Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    GestureDetector(
                      onTap: () {
                      },
                      child: LayoutBuilder(
                        builder: (_ , constrains) {
                          return CachedNetworkImage(
                            imageUrl: certificationEntity.imageUrl!,
                            width: constrains.maxWidth,
                            height: constrains.maxHeight,
                            fit: BoxFit.fill,
                            placeholder: (_, __) => Image.asset(
                              "assets/image_placeholder.jpg",
                              width: constrains.maxWidth,
                              height: constrains.maxHeight,
                              fit: BoxFit.fill,
                            ),
                            errorWidget: (_, __, ___) => Image.asset(
                              "assets/image_placeholder.jpg",
                              width: constrains.maxWidth,
                              height: constrains.maxHeight,
                              fit: BoxFit.fill,
                            ),
                          );
                        },
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(20.w, 30.h),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: SvgPicture.asset(
                          "assets/certificate.svg",
                          width: 71.w,
                          height: 71.h,
                        )
                      ),
                    )
                  ],
                ),
              ),
              Transform.translate(
                offset: Offset(13.w, 0),
                child: SvgPicture.asset(
                  "assets/stars.svg",
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
