import 'package:frontend/features/certifications/domain/entities/certification_entity.dart';

class CertificationModel extends CertificationEntity {
  CertificationModel({required super.id, required super.studentId, required super.content, required super.imageUrl});

  factory CertificationModel.fromJson(Map<String, dynamic> json) {
    return CertificationModel(
      id: json['id'],
      studentId: json['student_id'],
      content: json['content'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'content': content,
      'image_url': imageUrl,
    };
  }
}