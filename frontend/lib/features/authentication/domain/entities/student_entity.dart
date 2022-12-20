import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:frontend/core/constants/semesters_timeline.dart';

class StudentEntity extends Equatable {
  final String email;
  final int id;
  final int rfId;
  final String name;
  final int entryYear;
  final int majorId;
  final String majorName;
  final String? imageUrl;

  const StudentEntity({
    required this.email,
    required this.id,
    required this.rfId,
    required this.name,
    required this.entryYear,
    required this.majorId,
    required this.majorName,
    required this.imageUrl,
  });

  int get gradeYear {
    DateTime currentDate = DateTime.now().toUtc();
    int currentGrade = currentDate.year - entryYear;
    if (currentDate.month >= SemesterTimeLine.firstSemesterStart) {
      currentGrade += 1;
    }
    return min(currentGrade, 5);
  }

  @override
  List<Object?> get props =>
      [email, id, rfId, name, entryYear, majorId, majorName];

  StudentEntity copyWith({
    String? email,
    int? id,
    int? rfId,
    String? name,
    int? entryYear,
    int? majorId,
    String? majorName,
    String? imageUrl,
  }) {
    return StudentEntity(
      email: email ?? this.email,
      id: id ?? this.id,
      rfId: rfId ?? this.rfId,
      name: name ?? this.name,
      entryYear: entryYear ?? this.entryYear,
      majorId: majorId ?? this.majorId,
      majorName: majorName ?? this.majorName,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
