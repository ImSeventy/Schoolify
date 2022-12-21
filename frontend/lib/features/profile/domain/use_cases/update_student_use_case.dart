import 'package:dartz/dartz.dart';
import 'package:frontend/core/auth_info/auth_info.dart';
import 'package:frontend/core/errors/failures.dart';
import 'package:frontend/core/use_cases/use_case.dart';
import 'package:frontend/features/profile/domain/repository/profile_repository.dart';

class UpdateStudentUseCase extends UseCase<void, UpdateStudentParams> {
  final ProfileRepository profileRepository;

  UpdateStudentUseCase({required this.profileRepository});

  @override
  Future<Either<Failure, void>> call(UpdateStudentParams params) async {
    final response = await profileRepository.updateStudent(email: params.email);
    response.fold(
      (_) => null,
      (_) {
        if (AuthInfo.currentStudent == null) {
          return;
      }
        AuthInfo.currentStudent = AuthInfo.currentStudent!.copyWith(email: params.email);
      },
    );

    return response;
  }
}

class UpdateStudentParams {
  final String email;

  UpdateStudentParams({required this.email});
}
