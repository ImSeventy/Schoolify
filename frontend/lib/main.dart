import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/core/use_cases/use_case.dart';
import 'package:frontend/features/authentication/domain/use_cases/get_current_student_use_case.dart';
import 'package:frontend/features/authentication/domain/use_cases/load_cached_access_tokens.dart';
import 'package:frontend/router/router.dart';
import 'package:serial_port_win32/serial_port_win32.dart';
import 'dependency_container.dart' as dc;
import 'features/grades/presentation/bloc/data_handler/data_handler_cubit.dart';
import 'router/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dc.setUp();
  await ScreenUtil.ensureScreenSize();
  // await dc.getIt<LoadCachedAccessTokensUseCase>().call(NoParams());
  // await dc.getIt<GetCurrentStudentUseCase>().call(NoParams());
  // final port = SerialPort("COM15", openNow: false, BaudRate: 9600, ByteSize: 8, ReadTotalTimeoutConstant: 10);
  // port.open();
  // List<int> chars = [];
  // String? id;
  // port.readOnListenFunction = (value) {
  //   print(value.first);
  //   if (value.first == 10) {
  //     String newId = String.fromCharCodes(chars);
  //     if (id != newId) {
  //       id = String.fromCharCodes(chars);
  //       print(id);
  //     }
  //     chars.clear();
  //   } else {
  //     chars.add(value.first);
  //   }
  // };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DataHandlerCubit>(
          create: (context) {
            DataHandlerCubit dataHandlerCubit = dc.getIt<DataHandlerCubit>();
            return dataHandlerCubit;
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
