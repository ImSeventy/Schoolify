import 'package:frontend/core/utils/extensions.dart';
import 'package:frontend/features/certifications/domain/entities/certification_entity.dart';

class CertificationModel extends CertificationEntity {
  CertificationModel({
    required super.id,
    required super.studentId,
    required super.content,
    required super.imageUrl,
    required super.givenBy,
    required super.givenByName,
    required super.givenByImageUrl,
    required super.gradeYear,
    required super.semester,
    required super.date
  });

  factory CertificationModel.fromJson(Map<String, dynamic> json) {
    return CertificationModel(
      id: json['id'],
      studentId: json['student_id'],
      content: json['content'],
      imageUrl: json['image_url'],
      givenBy: json['given_by'],
      givenByName: json['given_by_name'],
      givenByImageUrl: json['given_by_image_url'],
      gradeYear: json['grade_year'],
      semester: json['semester'],
      date: DateTime.fromMicrosecondsSinceEpoch(
        (json["date"] * 1000000.0).round(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'content': content,
      'image_url': imageUrl,
      'given_by': givenBy,
      'given_by_name': givenByName,
      'given_by_image_url': givenByImageUrl,
      'grade_year': gradeYear,
      'semester': semester,
      'date': date.timeStamp
    };
  }
}
