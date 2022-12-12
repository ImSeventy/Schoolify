import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/router/router.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dependency_container.dart' as dc;
import 'features/attendance/presentation/bloc/attendance_cubit/attendance_cubit.dart';
import 'features/authentication/presentation/bloc/login_cubit/login_cubit.dart';
import 'features/grades/presentation/bloc/data_handler/data_handler_cubit.dart';
import 'features/grades/presentation/bloc/grades/grades_cubit.dart';
import 'router/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dc.setUp();
  await ScreenUtil.ensureScreenSize();
  // await dc.getIt<LoadCachedAccessTokensUseCase>().call(NoParams());
  // await dc.getIt<GetCurrentStudentUseCase>().call(NoParams());

  runApp(const MyApp());
}

Stream<String> getRfIdStream() {
  StreamController<String> streamController = StreamController<String>();

  void setupWebSocketConnection() {
    WebSocketChannel channel = IOWebSocketChannel.connect(Uri.parse("ws://localhost:8679"));
    channel.stream.listen((message) {
      streamController.sink.add(message);
    }, onDone: () async {
      await Future.delayed(const Duration(seconds: 5));
      setupWebSocketConnection();
    }, onError: (e) {});
  }

  setupWebSocketConnection();

  return streamController.stream;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Color(0xFCF131524)
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
