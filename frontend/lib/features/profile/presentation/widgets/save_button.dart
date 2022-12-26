import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/core/utils/extensions.dart';

class SaveButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool enabled;
  const SaveButton({Key? key, required this.onPressed, required this.enabled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: enabled ? onPressed : null,
      style: TextButton.styleFrom(
        backgroundColor: const Color(0xb300FF94),
        foregroundColor: Colors.white,
        textStyle: context.theme.textTheme.button?.copyWith(
            fontSize: 25.sp,
        )
      ),
      child: const Text("Save"),
    );
  }
}
