import 'package:dartz/dartz.dart';
import 'package:frontend/core/errors/failures.dart';
import 'package:frontend/core/use_cases/use_case.dart';
import 'package:frontend/features/authentication/domain/entities/sutdent_rfid_entity.dart';
import 'package:frontend/features/authentication/domain/repository/authentication_repository.dart';

class GetStudentByRfidUseCase extends UseCase<StudentRfidEntity, GetStudentByRfidParams> {
  final AuthenticationRepository authenticationRepository;

  GetStudentByRfidUseCase({required this.authenticationRepository});

  @override
  Future<Either<Failure, StudentRfidEntity>> call(GetStudentByRfidParams params) {
    return authenticationRepository.getStudentByRfid(rfid: params.rfid);
  }
}


class GetStudentByRfidParams {
  final int rfid;

  GetStudentByRfidParams({required this.rfid});
}