import 'dart:async';
import 'dart:io';
import 'package:desktop_window/desktop_window.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/router/router.dart';
import 'core/use_cases/use_case.dart';
import 'dependency_container.dart' as dc;
import 'features/attendance/presentation/bloc/attendance_cubit/attendance_cubit.dart';
import 'features/authentication/domain/use_cases/get_current_student_use_case.dart';
import 'features/authentication/domain/use_cases/load_cached_access_tokens.dart';
import 'features/authentication/presentation/bloc/login_cubit/login_cubit.dart';
import 'features/grades/presentation/bloc/data_handler/data_handler_cubit.dart';
import 'features/grades/presentation/bloc/grades/grades_cubit.dart';
import 'router/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dc.setUp();
  await ScreenUtil.ensureScreenSize();
  await dc.getIt<LoadCachedAccessTokensUseCase>().call(NoParams());
  await dc.getIt<GetCurrentStudentUseCase>().call(NoParams());

  if (Platform.isWindows) {
    Process.run('cd %RFID_SERVER% && py main.py', [], runInShell: true);
  }

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    const minSize = Size(550, 500);
    const maxSize = Size(700, 2400);
    await DesktopWindow.setWindowSize(Size(maxSize.width, 1000));
    await DesktopWindow.setMinWindowSize(minSize);
    await DesktopWindow.setMaxWindowSize(maxSize);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF131524)
    ));


    return MultiBlocProvider(
      providers: [
        BlocProvider<DataHandlerCubit>(
          create: (context) {
            DataHandlerCubit dataHandlerCubit = dc.getIt<DataHandlerCubit>();
            return dataHandlerCubit;
          },
        ),
        BlocProvider<GradesCubit>(create: (_) {
          GradesCubit gradesCubit = dc.getIt<GradesCubit>();
          gradesCubit.getStudentGrades();
          return gradesCubit;
        }),
        BlocProvider<AttendanceCubit>(create: (_) {
          AttendanceCubit attendanceCubit = dc.getIt<AttendanceCubit>();
          attendanceCubit.getStudentAbsences();
          return attendanceCubit;
        }),
        BlocProvider<LoginCubit>(
          create: (BuildContext context) {
            return dc.getIt<LoginCubit>();
          },
        )
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Schoolify',
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: Routes.root,
      ),
    );
  }
}
