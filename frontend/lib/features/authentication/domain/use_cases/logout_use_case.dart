import 'package:dartz/dartz.dart';
import 'package:frontend/features/authentication/domain/repository/authentication_repository.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/use_cases/use_case.dart';

class LogOutUseCase extends UseCase<void, NoParams> {
  final AuthenticationRepository authRepository;

  LogOutUseCase({required this.authRepository});

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await authRepository.logOut();
  }
}