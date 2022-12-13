import 'package:bloc/bloc.dart';
import 'package:frontend/core/use_cases/use_case.dart';
import 'package:frontend/dependency_container.dart';
import 'package:frontend/features/authentication/domain/use_cases/get_current_student_use_case.dart';
import 'package:frontend/features/authentication/domain/use_cases/login_use_case.dart';
import 'package:frontend/features/authentication/presentation/bloc/login_cubit/login_states.dart';

import '../../../domain/use_cases/get_student_by_rfid.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;
  final GetCurrentStudentUseCase getCurrentStudentUseCase;
  final GetStudentByRfidUseCase getStudentByRfidUseCase;

  LoginCubit(
      {required this.loginUseCase,
      required this.getCurrentStudentUseCase,
      required this.getStudentByRfidUseCase})
      : super(
          LoginInitialState(),
        );

  void getStudentByRfid({required rfid}) async {
    emit(GetStudentByRfidLoadingState());

    final response = await getStudentByRfidUseCase.call(
      GetStudentByRfidParams(rfid: rfid),
    );


    response.fold(
      (failure) => emit(GetStudentByRfidFailedState(message: failure.message)),
      (student) => emit(GetStudentByRfidSucceededState(student: student)),
    );
  }

  void login({
    required String email,
    required String password,
  }) async {
    LoginParams credentials = LoginParams(email: email, password: password);

    emit(LoginLoadingState());
    final response = await loginUseCase.call(credentials);

    response.fold(
      (failure) => emit(LoginFailedState(message: failure.message)),
      (tokensEntity) async {
        final response = await getCurrentStudentUseCase.call(NoParams());
        response.fold(
          (failure) => emit(LoginFailedState(message: failure.message)),
          (studentEntity) => emit(LoginSucceededState()),
        );
      },
    );
  }
}
