import 'package:dartz/dartz.dart';
import 'package:frontend/core/errors/failures.dart';
import 'package:frontend/core/use_cases/use_case.dart';
import 'package:frontend/features/warnings/domain/entities/warning_entity.dart';
import 'package:frontend/features/warnings/domain/reposistory/warnings_repository.dart';

class GetStudentWarningsUseCase extends UseCase<List<WarningEntity>, NoParams> {
  final WarningsRepository warningsRepository;

  GetStudentWarningsUseCase({required this.warningsRepository});

  @override
  Future<Either<Failure, List<WarningEntity>>> call(NoParams params) {
    return warningsRepository.getStudentWarnings();
  }

}