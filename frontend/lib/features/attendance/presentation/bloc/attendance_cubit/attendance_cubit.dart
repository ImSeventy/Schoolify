import 'package:bloc/bloc.dart';
import 'package:frontend/core/use_cases/use_case.dart';
import 'package:frontend/features/attendance/domain/entities/absence_entity.dart';
import 'package:frontend/features/attendance/presentation/bloc/attendance_cubit/attendance_states.dart';

import '../../../domain/use_cases/get_students_absences.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  final GetStudentAbsencesUseCase getStudentAbsencesUseCase;
  List<AbsenceEntity> absences = [];
  AttendanceCubit({required this.getStudentAbsencesUseCase})
      : super(AttendanceInitialState());

  void getStudentAbsences() async {
    emit(GetStudentAbsencesLoadingState());

    final response = await getStudentAbsencesUseCase.call(NoParams());

    response.fold(
      (failure) {
        emit(GetStudentAbsencesFailedState(msg: failure.message));
      },
      (absencesEntities) {
        absences = absencesEntities;
        emit(GetStudentAbsencesSucceededState());
      },
    );
  }
}
