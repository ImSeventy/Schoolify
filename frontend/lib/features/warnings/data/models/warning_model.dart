import 'package:frontend/features/warnings/domain/entities/warning_entity.dart';

class WarningModel extends WarningEntity {
  WarningModel(
      {required super.id, required super.studentId, required super.content});

  factory WarningModel.fromJson(Map<String, dynamic> json) {
    return WarningModel(
      id: json["id"],
      studentId: json["student_id"],
      content: json["content"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "content": content,
      "student_id": studentId
    };
  }
}
