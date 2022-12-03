import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/core/use_cases/use_case.dart';
import 'package:frontend/features/authentication/domain/use_cases/get_current_student_use_case.dart';
import 'package:frontend/features/authentication/domain/use_cases/load_cached_access_tokens.dart';
import 'package:frontend/router/router.dart';
import 'dependency_container.dart' as dc;
import 'router/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dc.setUp();
  await ScreenUtil.ensureScreenSize();
  await dc.getIt<LoadCachedAccessTokensUseCase>().call(NoParams());
  await dc.getIt<GetCurrentStudentUseCase>().call(NoParams());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Schoolify',
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: Routes.root,
    );
  }
}
