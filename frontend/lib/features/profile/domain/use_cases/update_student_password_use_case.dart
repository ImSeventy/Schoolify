import 'package:dartz/dartz.dart';
import 'package:frontend/core/errors/failures.dart';
import 'package:frontend/core/use_cases/use_case.dart';
import 'package:frontend/features/profile/domain/repository/profile_repository.dart';

class UpdateStudentPasswordUseCase
    extends UseCase<void, UpdateStudentPasswordParams> {
  final ProfileRepository profileRepository;

  UpdateStudentPasswordUseCase({required this.profileRepository});

  @override
  Future<Either<Failure, void>> call(UpdateStudentPasswordParams params) {
    return profileRepository.updateStudentPassword(
      currentPassword: params.currentPassword,
      newPassword: params.newPassword,
    );
  }
}

class UpdateStudentPasswordParams {
  final String currentPassword;
  final String newPassword;

  UpdateStudentPasswordParams(
      {required this.currentPassword, required this.newPassword});
}
