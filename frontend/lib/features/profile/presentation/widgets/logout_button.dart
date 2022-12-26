import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/core/utils/extensions.dart';

import '../../../../core/use_cases/use_case.dart';
import '../../../../dependency_container.dart';
import '../../../authentication/domain/use_cases/logout_use_case.dart';

class LogOutButton extends StatelessWidget {
  const LogOutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        context.pushNamedAndRemove("login");
        await getIt<LogOutUseCase>().call(NoParams());
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        margin: EdgeInsetsDirectional.only(end: 25.w),
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Text(
          "Log Out",
          style:context.theme.textTheme.headline4?.copyWith(
            color: context.colorScheme.error,
          ),
        ),
      ),
    );
  }
}
