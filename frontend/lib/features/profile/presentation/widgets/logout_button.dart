import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/use_cases/use_case.dart';
import '../../../../dependency_container.dart';
import '../../../authentication/domain/use_cases/logout_use_case.dart';

class LogOutButton extends StatelessWidget {
  const LogOutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.of(context).pushNamedAndRemoveUntil("login", (_) => false,);
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
          style:Theme.of(context).textTheme.headline4?.copyWith(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ),
    );
  }
}
