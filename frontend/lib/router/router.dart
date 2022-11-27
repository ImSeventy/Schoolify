import 'package:flutter/material.dart';
import 'package:frontend/features/authentication/presentation/pages/login_page.dart';
import '../themes/light_theme.dart';

class AppRouter {
  static ThemeMode themeMode = ThemeMode.light;

  static Route? onGenerateRoute(RouteSettings settings) {
    dynamic args = settings.arguments;
    Widget? screen = getScreenFromRouteName(settings.name, args);
    if (screen == null) return null;

    return MaterialPageRoute(
        builder: (context) {
          return CurrentThemeWrapper(
            child: screen,
          );
        }
    );
  }

  static Widget? getScreenFromRouteName(String? name, dynamic args) {
    switch (name) {
      case "/":
        return const LoginPage();
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
