import 'package:frontend/features/authentication/domain/entities/student_entity.dart';

class StudentModel extends StudentEntity {
  const StudentModel({
    required super.email,
    required super.id,
    required super.rfId,
    required super.name,
    required super.entryYear,
    required super.majorId,
    required super.majorName,
    required super.imageUrl,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      email: json["email"],
      id: json["id"],
      rfId: json["rf_id"],
      name: json["name"],
      entryYear: json["entry_year"],
      majorId: json["major_id"],
      majorName: json['major_name'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "id": id,
      "rf_id": rfId,
      "name": name,
      "entry_year": entryYear,
      "major_id": majorId,
      "major_name": majorName,
      "image_url": imageUrl,
    };
  }
}
