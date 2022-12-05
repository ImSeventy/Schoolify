import 'package:dartz/dartz.dart';
import 'package:frontend/features/warnings/domain/entities/warning_entity.dart';

import '../../../../core/errors/failures.dart';

abstract class WarningsRepository {
  Future<Either<Failure, List<WarningEntity>>> getStudentWarnings();
}