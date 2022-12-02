import 'package:bloc/bloc.dart';
import 'package:frontend/core/auth_info/auth_info.dart';

import '../../../domain/entities/grade.py.dart';
import 'data_handler_states.dart';

class DataHandlerCubit extends Cubit<DataHandlerState> {
  final Map<String, bool Function(GradeEntity)> gradesPredicates = {
    "This Year": (grade) =>
        grade.gradeYear == AuthInfo.currentStudent!.gradeYear,
    "Last Year": (grade) =>
        grade.gradeYear == (AuthInfo.currentStudent!.gradeYear - 1),
    "1st Semester": (grade) => grade.semester == 1,
    "2nd Semester": (grade) => grade.semester == 2
  };

  String currentYearMode = "All Years";
  String currentSemesterMode = "Whole Year";

  List<GradeEntity> currentGrades = [];
  DataHandlerCubit() : super(DataHandlerInitialState());

  void changeYearMode(String yearMode) {
    currentYearMode = yearMode;
    emit(DataHandlerChangedYearModeState(yearMode));
  }

  void changeSemesterMode(String semesterMode) {
    currentSemesterMode = semesterMode;
    emit(DataHandlerChangedSemesterModeState(semesterMode));
  }

  void setNewGrades({
    required List<GradeEntity> grades,
  }) {
    currentGrades = grades;
    emit(DataHandlerSetNewGradesState());
  }

  List<GradeEntity> get filteredGrades {
    List<GradeEntity> grades = currentGrades;
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
}
