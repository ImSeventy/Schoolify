import 'package:flutter/material.dart';

Map<int, String> monthsNames = {
  1: "Jan",
  2: "Feb",
  3: "Mar",
  4: "Apr",
  5: "May",
  6: "Jun",
  7: "Jul",
  8: "Aug",
  9: "Sep",
  10: "Oct",
  11: "Nov",
  12: "Dec"
};


extension DateTimeExtension on DateTime {
  double get timeStamp {
    return microsecondsSinceEpoch / 1000000;
  }

  String get dateFormat {
    return "$monthShortName $day, $year";
  }

  String get monthShortName {
    return monthsNames[month]!;
  }
}


extension ContextExtension on BuildContext {
  ThemeData get theme {
    return Theme.of(this);
  }

  ColorScheme get colorScheme {
    return theme.colorScheme;
  }

  NavigatorState get navigator {
    return Navigator.of(this);
  }

  Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    return navigator.pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushNamedAndRemove(String routeName, {Object? arguments}) {
    return navigator.pushNamedAndRemoveUntil(routeName, (_) => false, arguments: arguments);
  }
}