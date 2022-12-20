import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/features/authentication/presentation/widgets/credentials_field.dart';

class ProfileDataField extends StatelessWidget {
  final String fieldName;
  final bool isPassword;
  final bool enabled;
  final bool editable;
  final VoidCallback? editCallback;
  final TextEditingController textEditingController;
  final void Function(String? value)? validator;

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
          style: TextStyle(
            color: const Color(0xFF544E4E),
            fontFamily: "Overpass",
            fontSize: 20.sp,
            fontWeight: FontWeight.w400
          ),
        ),
        SizedBox(height: 4.h,),
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CredentialsField(isPassword: isPassword, hintText: "", textEditingController: textEditingController, enabled: enabled,),
            if (editable) GestureDetector(
              onTap: editCallback,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF131524), width: 3, strokeAlign: StrokeAlign.outside),
                    color: const Color(0xFF40E1D1)
                ),
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
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
