class AbsenceEntity {
  final int id;
  final int studentId;
  final DateTime date;
  final int grade;
  final int semester;

  AbsenceEntity({
    required this.id,
    required this.studentId,
    required this.date,
    required this.grade,
    required this.semester,
  });
}
