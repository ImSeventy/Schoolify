import 'package:bloc/bloc.dart';
import 'package:frontend/core/use_cases/use_case.dart';
import 'package:frontend/features/grades/domain/entities/grade.py.dart';
import 'package:frontend/features/grades/presentation/bloc/grades/grades_cubit_states.dart';

import '../../../domain/use_cases/get_student_grades.dart';

class GradesCubit extends Cubit<GradesState> {
  final GetStudentGradesUseCase getStudentGradesUseCase;
  List<GradeEntity> grades = [];

  GradesCubit({required this.getStudentGradesUseCase})
      : super(GradesInitialState());

  void getStudentGrades() async {
    emit(GetStudentGradesLoadingState());
    final response = await getStudentGradesUseCase(NoParams());

    response.fold(
      (failure) => emit(GetStudentGradesFailedState(failure.message)),
      (fetchedGrades) {
        grades = fetchedGrades;
        emit(GetStudentGradeSucceededState());
      },
    );
  }
}
