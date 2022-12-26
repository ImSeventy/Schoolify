import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:frontend/core/auth_info/auth_info.dart';
import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/core/constants/semesters_timeline.dart';
import 'package:frontend/features/attendance/domain/entities/absence_entity.dart';
import 'package:frontend/features/certifications/domain/entities/certification_entity.dart';
import 'package:frontend/features/warnings/domain/entities/warning_entity.dart';

import '../../../domain/entities/grade.py.dart';
import 'data_handler_states.dart';

class DataHandlerCubit extends Cubit<DataHandlerState> {
  final Map<String, bool Function(GradeEntity)> gradesPredicates = {
    "This Year": (grade) =>
        grade.gradeYear == AuthInfo.currentStudent!.gradeYear,
    "Last Year": (grade) =>
        grade.gradeYear == (AuthInfo.currentStudent!.gradeYear - 1),
    "1st Semester": (grade) => grade.semester == 1,
    "2nd Semester": (grade) => grade.semester == 2,
    "Grade 1": (grade) => grade.gradeYear == 1,
    "Grade 2": (grade) => grade.gradeYear == 2,
    "Grade 3": (grade) => grade.gradeYear == 3,
    "Grade 4": (grade) => grade.gradeYear == 4,
    "Grade 5": (grade) => grade.gradeYear == 5
  };

  final Map<String, bool Function(AbsenceEntity)> attendancePredicate = {
    "This Year": (absence) =>
        absence.grade == AuthInfo.currentStudent!.gradeYear,
    "Last Year": (absence) =>
        absence.grade == (AuthInfo.currentStudent!.gradeYear - 1),
    "1st Semester": (absence) => absence.semester == 1,
    "2nd Semester": (absence) => absence.semester == 2,
    "Grade 1": (absence) => absence.grade == 1,
    "Grade 2": (absence) => absence.grade == 2,
    "Grade 3": (absence) => absence.grade == 3,
    "Grade 4": (absence) => absence.grade == 4,
    "Grade 5": (absence) => absence.grade == 5
  };

  final Map<String, bool Function(WarningEntity)> warningsPredicates = {
    "This Year": (warning) =>
    warning.gradeYear == AuthInfo.currentStudent!.gradeYear,
    "Last Year": (warning) =>
    warning.gradeYear == (AuthInfo.currentStudent!.gradeYear - 1),
    "1st Semester": (warning) => warning.semester == 1,
    "2nd Semester": (warning) => warning.semester == 2,
    "Grade 1": (warning) => warning.gradeYear == 1,
    "Grade 2": (warning) => warning.gradeYear == 2,
    "Grade 3": (warning) => warning.gradeYear == 3,
    "Grade 4": (warning) => warning.gradeYear == 4,
    "Grade 5": (warning) => warning.gradeYear == 5
  };

  final Map<String, bool Function(CertificationEntity)> certificationsPredicates = {
    "This Year": (certification) =>
    certification.gradeYear == AuthInfo.currentStudent!.gradeYear,
    "Last Year": (certification) =>
    certification.gradeYear == (AuthInfo.currentStudent!.gradeYear - 1),
    "1st Semester": (certification) => certification.semester == 1,
    "2nd Semester": (certification) => certification.semester == 2,
    "Grade 1": (certification) => certification.gradeYear == 1,
    "Grade 2": (certification) => certification.gradeYear == 2,
    "Grade 3": (certification) => certification.gradeYear == 3,
    "Grade 4": (certification) => certification.gradeYear == 4,
    "Grade 5": (certification) => certification.gradeYear == 5
  };


  String currentYearMode = yearOptions[0];
  String currentSemesterMode = semesterOptions[0];

  DataHandlerCubit() : super(DataHandlerInitialState());

  void changeYearMode(String yearMode) {
    currentYearMode = yearMode;
    emit(DataHandlerChangedYearModeState(yearMode));
  }

  void changeSemesterMode(String semesterMode) {
    currentSemesterMode = semesterMode;
    emit(DataHandlerChangedSemesterModeState(semesterMode));
  }

  List<GradeEntity> filterGrades(List<GradeEntity> grades) {
    final yearsPredicate = gradesPredicates[currentYearMode];
    if (yearsPredicate != null) {
      grades = grades.where(yearsPredicate).toList();
    }

    final semesterPredicate = gradesPredicates[currentSemesterMode];
    if (semesterPredicate != null) {
      grades = grades.where(semesterPredicate).toList();
    }
    return grades;
  }

  List<AbsenceEntity> filterAbsences(List<AbsenceEntity> absences) {
    final yearsPredicate = attendancePredicate[currentYearMode];
    if (yearsPredicate != null) {
      absences = absences.where(yearsPredicate).toList();
    }

    final semesterPredicate = attendancePredicate[currentSemesterMode];
    if (semesterPredicate != null) {
      absences = absences.where(semesterPredicate).toList();
    }

    absences.sort((a, b) => b.date.compareTo(a.date));
    return absences;
  }

  List<WarningEntity> filterWarnings(List<WarningEntity> warnings) {
    final yearsPredicate = warningsPredicates[currentYearMode];
    if (yearsPredicate != null) {
      warnings = warnings.where(yearsPredicate).toList()..sort((a, b) => b.date.compareTo(a.date));
    }

    final semesterPredicate = warningsPredicates[currentSemesterMode];
    if (semesterPredicate != null) {
      warnings = warnings.where(semesterPredicate).toList();
    }

    warnings.sort((a, b) => b.date.compareTo(a.date));
    return warnings;
  }

  List<CertificationEntity> filterCertifications(List<CertificationEntity> certifications) {
    final yearsPredicate = certificationsPredicates[currentYearMode];
    if (yearsPredicate != null) {
      certifications = certifications.where(yearsPredicate).toList()..sort((a, b) => b.date.compareTo(a.date));
    }

    final semesterPredicate = certificationsPredicates[currentSemesterMode];
    if (semesterPredicate != null) {
      certifications = certifications.where(semesterPredicate).toList();
    }

    certifications.sort((a, b) => b.date.compareTo(a.date));
    return certifications;
  }

  int getDaysFromTheBeginningOfTheSemester(int semester) {
    if (semester == 1) {
      DateTime currentDate = DateTime.now().toUtc();
      DateTime semesterStartingDate = DateTime.utc(
        SemesterTimeLine.firstSemesterStart > currentDate.month
            ? currentDate.year - 1
            : currentDate.year,
        SemesterTimeLine.firstSemesterStart,
      );
      int days = currentDate.difference(semesterStartingDate).inDays;
      days = days - ((days ~/ 30) * 9);
      return min(days, SemesterTimeLine.firstSemesterDaysNumber);
    } else {
      DateTime currentDate = DateTime.now().toUtc();
      if (currentDate.month < SemesterTimeLine.secondSemesterStart || currentDate.month >= SemesterTimeLine.firstSemesterStart) {
        return 0;
      }
      DateTime semesterStartingDate = DateTime.utc(
        currentDate.year,
        SemesterTimeLine.secondSemesterStart,
      );
      int days = currentDate.difference(semesterStartingDate).inDays;
      days = days - ((days ~/ 30) * 9);
      return min(days, SemesterTimeLine.secondSemesterDaysNumber);
    }
  }

  int getDaysFromTheBeginningOfTheYear() {
    int days = getDaysFromTheBeginningOfTheSemester(1) + getDaysFromTheBeginningOfTheSemester(2);

    return min(days, (SemesterTimeLine.firstSemesterDaysNumber + SemesterTimeLine.secondSemesterDaysNumber));
  }

  int get totalAttendanceDays {
    if (currentYearMode == "This Year" || currentYearMode == "Grade ${AuthInfo.currentStudent!.gradeYear}") {
      switch (currentSemesterMode) {
        case "Whole Year":
          return getDaysFromTheBeginningOfTheYear();
        case "1st Semester":
          return getDaysFromTheBeginningOfTheSemester(1);
        case "2nd Semester":
          return getDaysFromTheBeginningOfTheSemester(2);
      }
    }

    if (currentYearMode != "All Years") {
      if (currentSemesterMode == "Whole Year") {
        return SemesterTimeLine.firstSemesterDaysNumber +
            SemesterTimeLine.secondSemesterDaysNumber;
      } else if (currentSemesterMode == "1st Semester") {
        return SemesterTimeLine.firstSemesterDaysNumber;
      } else {
        return SemesterTimeLine.secondSemesterDaysNumber;
      }
    }

    int oneYearDays = 0;
    switch (currentSemesterMode) {
      case "Whole Year":
        oneYearDays = SemesterTimeLine.firstSemesterDaysNumber +
            SemesterTimeLine.secondSemesterDaysNumber;
        break;
      case "1st Semester":
        oneYearDays = SemesterTimeLine.firstSemesterDaysNumber;
        break;
      case "2nd Semester":
        oneYearDays = SemesterTimeLine.secondSemesterDaysNumber;
        break;
    }

    int days = oneYearDays * (AuthInfo.currentStudent!.gradeYear - 1);

    switch (currentSemesterMode) {
      case "Whole Year":
        days += getDaysFromTheBeginningOfTheYear();
        break;
      case "1st Semester":
        days += getDaysFromTheBeginningOfTheSemester(1);
        break;
      case "2nd Semester":
        days += getDaysFromTheBeginningOfTheSemester(2);
        break;

    }

    return days;
  }

  double calculateAttendancePercentage(List<AbsenceEntity> absences) {
    absences = filterAbsences(absences);
    int totalDays = totalAttendanceDays;
    if (totalDays == 0) return 0;
    double percentage = 100 - ((absences.length / totalDays) * 100);
    return min(percentage, 100);
  }

  double calculateGradesPercentage(List<GradeEntity> grades) {
    grades = filterGrades(grades);
    if (grades.isEmpty) return 0;

    double fullDegree = 0;
    double degree = 0;
    for (GradeEntity grade in grades) {
      fullDegree += grade.fullDegree;
      degree += grade.grade;
    }

    return ((degree / fullDegree) * 100);
  }
}
