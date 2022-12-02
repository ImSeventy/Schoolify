import 'package:frontend/features/attendance/domain/entities/absence_entity.dart';

class AbsenceModel extends AbsenceEntity {
  AbsenceModel({
    required super.id,
    required super.studentId,
    required super.date,
    required super.grade,
    required super.semester,
  });

  factory AbsenceModel.fromJson(Map<String, dynamic> json) {
    return AbsenceModel(
      id: json['id'],
      studentId: json['student_id'],
      date: json['date'],
      grade: json['grade'],
      semester: json['semester'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "student_id": studentId,
      "date": date,
      "grade": grade,
      "semester": semester
    };
  }
}
