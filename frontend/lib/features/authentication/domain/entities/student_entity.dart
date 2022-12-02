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

  const StudentEntity({
    required this.email,
    required this.id,
    required this.rfId,
    required this.name,
    required this.entryYear,
    required this.majorId,
    required this.majorName,
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
  List<Object?> get props => [
    email,
    id,
    rfId,
    name,
    entryYear,
    majorId,
    majorName
  ];
}
