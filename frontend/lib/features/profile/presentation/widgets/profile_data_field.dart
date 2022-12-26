import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/core/utils/extensions.dart';
import 'package:frontend/features/authentication/presentation/widgets/credentials_field.dart';

import '../../../../core/constants/fonts.dart';

class ProfileDataField extends StatelessWidget {
  final String fieldName;
  final bool isPassword;
  final bool enabled;
  final bool editable;
  final VoidCallback? editCallback;
  final TextEditingController textEditingController;
  final String? Function(String? value)? validator;

  const ProfileDataField({
    Key? key,
    required this.fieldName,
    required this.isPassword,
    required this.textEditingController,
    this.editCallback,
    this.editable = false,
    this.enabled = true,
    this.validator,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fieldName,
          style: context.theme.textTheme.bodyText1?.copyWith(
            fontFamily: Fonts.secondaryFont,
            color: const Color(0xFF544E4E),
          ),
        ),
        SizedBox(height: 4.h,),
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CredentialsField(isPassword: isPassword, hintText: "", textEditingController: textEditingController, enabled: enabled, validator: validator,),
            if (editable) GestureDetector(
              onTap: editCallback,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: context.theme.scaffoldBackgroundColor, width: 3, strokeAlign: StrokeAlign.outside),
                    color: context.colorScheme.tertiary
                ),
                child: Icon(
                  Icons.edit,
                  color: context.colorScheme.onTertiary,
                  size: 25.sp,
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
