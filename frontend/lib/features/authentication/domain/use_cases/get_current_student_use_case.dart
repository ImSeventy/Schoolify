import 'package:dartz/dartz.dart';
import 'package:frontend/core/auth_info/auth_info.dart';
import 'package:frontend/core/errors/failures.dart';
import 'package:frontend/core/use_cases/use_case.dart';
import 'package:frontend/features/authentication/domain/entities/student_entity.dart';
import 'package:frontend/features/authentication/domain/repository/authentication_repository.dart';

class GetCurrentStudentUseCase extends UseCase<StudentEntity, NoParams> {
  final AuthenticationRepository authenticationRepository;

  GetCurrentStudentUseCase({required this.authenticationRepository});

  @override
  Future<Either<Failure, StudentEntity>> call(NoParams params) async {
    final response = await authenticationRepository.getCurrentStudent();

    response.fold(
      (_) => null,
      (student) {
        AuthInfo.currentStudent = student;
      },
    );

    return response;
  }
}
