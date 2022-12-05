import 'package:frontend/core/utils/extensions.dart';
import 'package:frontend/features/warnings/domain/entities/warning_entity.dart';

class WarningModel extends WarningEntity {
  WarningModel({
    required super.id,
    required super.studentId,
    required super.content,
    required super.date,
    required super.semester,
    required super.gradeYear
  });

  factory WarningModel.fromJson(Map<String, dynamic> json) {
    return WarningModel(
      id: json["id"],
      studentId: json["student_id"],
      content: json["content"],
      gradeYear: json["grade_year"],
      semester: json["semester"],
      date: DateTime.fromMicrosecondsSinceEpoch(
        (json["date"] * 1000000.0).round(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "content": content,
      "student_id": studentId,
      "date": date.timeStamp,
      "grade_year": gradeYear,
      "semester": semester
    };
  }
}
