import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:frontend/features/profile/domain/use_cases/update_student_use_case.dart';
import 'package:frontend/features/profile/presentation/bloc/profile_cubit/profile_states.dart';

import '../../../domain/use_cases/update_student_password_use_case.dart';
import '../../../domain/use_cases/update_student_profile_image_use_case.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UpdateStudentUseCase updateStudentUseCase;
  final UpdateStudentProfileImageUseCase updateStudentProfileImageUseCase;
  final UpdateStudentPasswordUseCase updateStudentPasswordUseCase;

  ProfileCubit({
    required this.updateStudentUseCase,
    required this.updateStudentPasswordUseCase,
    required this.updateStudentProfileImageUseCase,
  }) : super(ProfileInitialState());

  Future<void> updateStudent({required String email}) async {
    emit(UpdateStudentProfileLoadingState());
    final response = await updateStudentUseCase.call(
      UpdateStudentParams(
        email: email,
      ),
    );

    response.fold(
      (failure) => emit(UpdateStudentProfileFailedState(message: failure.message)),
      (r) => emit(UpdateStudentProfileSucceededState()),
    );
  }

  Future<void> updateStudentProfileImage({required File image}) async {
    emit(UpdateStudentProfileImageLoadingState());
    final response = await updateStudentProfileImageUseCase.call(
      UpdateStudentProfileImageParams(
        image: image,
      ),
    );

    response.fold(
          (failure) => emit(UpdateStudentProfileImageFailedState(message: failure.message)),
          (r) => emit(UpdateStudentProfileImageSucceededState()),
    );
  }

  Future<void> updateStudentPassword({required String currentPassword, required String newPassword}) async {
    emit(UpdateStudentPasswordLoadingState());
    final response = await updateStudentPasswordUseCase.call(
      UpdateStudentPasswordParams(
        currentPassword: currentPassword,
        newPassword: newPassword,
      ),
    );

    response.fold(
          (failure) => emit(UpdateStudentPasswordFailedState(message: failure.message)),
          (r) => emit(UpdateStudentPasswordSucceededState()),
    );
  }
}
