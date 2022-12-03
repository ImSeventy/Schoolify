extension DateTimeExtension on DateTime {
  double get timeStamp {
    return microsecondsSinceEpoch / 1000000;
  }
}