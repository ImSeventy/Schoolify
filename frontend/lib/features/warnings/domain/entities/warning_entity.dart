class WarningEntity {
  final int id;
  final int studentId;
  final int gradeYear;
  final int semester;
  final String content;
  final DateTime date;

  WarningEntity({
    required this.id,
    required this.studentId,
    required this.content,
    required this.date,
    required this.gradeYear,
    required this.semester
  });
}
