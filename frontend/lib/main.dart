import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/router/router.dart';
import 'dependency_container.dart' as dc;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dc.setUp();
  await ScreenUtil.ensureScreenSize();
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
      initialRoute: "/",
    );
  }
}
