class CertificationEntity {
  final int id;
  final int studentId;
  final String content;
  final String? imageUrl;
  final int givenBy;
  final String givenByName;
  final String givenByImageUrl;
  final int gradeYear;
  final int semester;
  final DateTime date;

  CertificationEntity({
    required this.id,
    required this.studentId,
    required this.content,
    required this.imageUrl,
    required this.givenBy,
    required this.givenByName,
    required this.givenByImageUrl,
    required this.gradeYear,
    required this.semester,
    required this.date
  });
}
