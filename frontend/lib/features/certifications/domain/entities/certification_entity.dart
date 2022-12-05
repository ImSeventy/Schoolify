class CertificationEntity {
  final int id;
  final int studentId;
  final String content;
  final String? imageUrl;

  CertificationEntity({required this.id, required this.studentId, required this.content, required this.imageUrl});
}