import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/core/utils/extensions.dart';
import 'package:frontend/features/attendance/domain/entities/absence_entity.dart';

class AbsenceWidget extends StatelessWidget {
  final AbsenceEntity absenceEntity;

  const AbsenceWidget({
    Key? key,
    required this.absenceEntity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 126,
      height: 94,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFF130B51),
        borderRadius: BorderRadius.circular(7)
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.clipboardUser,
              color: const Color(0xFF112B6D),
              size: 55.sp,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "G${absenceEntity.grade}\n",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                  fontSize: 17.sp,
                ),
                children: [
                  TextSpan(
                    text: "${absenceEntity.semester == 1 ? '1st' : '2nd'} term\n"
                  ),
                  TextSpan(
                    text: absenceEntity.date.dateFormat,
                    style: const TextStyle(
                      color: Color(0xFFF06482)
                    )
                  )
                ]

              ),
            ),
          ],
        ),
      ),
    );
  }
}
