extension DateTimeExtension on DateTime {
  double get timeStamp {
    return microsecondsSinceEpoch / 1000000;
  }

  String get dateFormat {
    return "$day/$month/$year";
  }
}