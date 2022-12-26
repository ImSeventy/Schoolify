import 'dart:ui';

final RegExp emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

const tokensInCacheKey = "access_tokens";

const List<Color> percentageColors = [
  Color(0xFFEE6482),
  Color(0xFFF3CFC5),
  Color(0xFF40E1D1),
];

const List<String> yearOptions = [
  "All Years",
  "This Year",
  "Last Year",
];

const List<String> semesterOptions = [
  "Whole Year",
  "1st Semester",
  "2nd Semester"
];
