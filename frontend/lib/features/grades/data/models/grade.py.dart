import 'package:frontend/features/grades/domain/entities/grade.py.dart';

class GradeModel extends GradeEntity {
  GradeModel({
    required super.grade,
    required super.fullDegree,
    required super.id,
    required super.subjectName,
    required super.subjectId,
    required super.semester,
    required super.gradeYear
  });

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    return GradeModel(
      grade: json["grade"],
      fullDegree: json["full_degree"],
      id: json["id"],
      subjectName: json["subject_name"],
      subjectId: json["subject_id"],
      semester: json["semester"],
      gradeYear: json["grade_year"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "grade": grade,
      "full_degree": fullDegree,
      "id": id,
      "subject_name": subjectName,
      "subject_id": subjectId,
      "semester": semester,
      "grade_year": gradeYear
    };
  }

}
