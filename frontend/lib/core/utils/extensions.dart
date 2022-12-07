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
    return "${monthShortName} $day, $year";
  }

  String get monthShortName {
    return monthsNames[month]!;
  }
}