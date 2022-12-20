import 'package:bloc/bloc.dart';
import 'package:frontend/core/use_cases/use_case.dart';
import 'package:frontend/features/warnings/presentation/bloc/warnings_cubit/warnings_states.dart';

import '../../../domain/entities/warning_entity.dart';
import '../../../domain/use_cases/get_student_warnings.dart';

class WarningsCubit extends Cubit<WarningsState> {
  final GetStudentWarningsUseCase getStudentWarningsUseCase;
  List<WarningEntity> warnings = [];
  WarningsCubit({required this.getStudentWarningsUseCase})
      : super(WarningsInitialState());

  Future<void> loadStudentWarnings() async {
    emit(GetStudentWarningsLoadingState());
    final response = await getStudentWarningsUseCase.call(NoParams());

    response.fold(
      (failure) => emit(GetStudentWarningsFailedState(message: failure.message)),
      (studentWarnings) {
        warnings = studentWarnings;
        emit(GetStudentWarningsSucceededState());
      },
    );
  }
}
