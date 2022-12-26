import 'package:flutter/material.dart';
import 'package:frontend/core/auth_info/auth_info.dart';
import 'package:frontend/core/use_cases/use_case.dart';
import 'package:frontend/dependency_container.dart';
import 'package:frontend/features/authentication/domain/entities/student_entity.dart';
import 'package:frontend/features/authentication/domain/entities/sutdent_rfid_entity.dart';
import 'package:frontend/features/authentication/presentation/pages/login_page.dart';
import 'package:frontend/features/authentication/presentation/pages/rfid_login_page.dart';
import 'package:frontend/features/onboarding/domain/use_cases/get_onboarding_status.dart';
import 'package:frontend/features/profile/presentation/pages/profile_page.dart';
import '../features/certifications/presentation/pages/certifications_page.dart';
import '../features/grades/presentation/pages/home_page.dart';
import '../features/onboarding/presentation/pages/onboarding_page.dart';
import '../features/warnings/presentation/pages/warnings_page.dart';
import '../themes/light_theme.dart';
import 'routes.dart';

class AppRouter {
  static ThemeMode themeMode = ThemeMode.light;

  static Route? onGenerateRoute(RouteSettings settings) {
    dynamic args = settings.arguments;
    Widget? screen = getScreenFromRouteName(settings.name, args);
    if (screen == null) return null;

    return MaterialPageRoute(builder: (context) {
      return CurrentThemeWrapper(
        child: screen,
      );
    });
  }

  static Widget? getScreenFromRouteName(String? name, dynamic args)  {
    switch (name) {
      case Routes.root:
        final response = getIt<GetOnBoardingStatus>().call(NoParams());
        return response.fold(
          (failure) => OnBoardingPage(),
          (status) {
            if (!status) {
              return OnBoardingPage();
            }

            if (AuthInfo.accessTokens == null || AuthInfo.currentStudent == null) {
              return LoginPage();
            }
            return HomePage();
          },
        );
      case Routes.home:
        return HomePage();
      case Routes.warnings:
        return WarningsPage();
      case Routes.certifications:
        return CertificationsPage();
      case Routes.rfidLogin:
        StudentRfidEntity student = (args as RfidLoginPageArgs).student;
        return RfidLoginPage(student: student);
      case Routes.login:
        return LoginPage();
      case Routes.profile:
        StudentEntity student = (args as ProfilePageArgs).student;
        return ProfilePage(student: student,);
      default:
        return null;
    }
  }
}

class CurrentThemeWrapper extends StatelessWidget {
  final Widget child;

  const CurrentThemeWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return LightThemeWrapper(child: child);
  }
}
