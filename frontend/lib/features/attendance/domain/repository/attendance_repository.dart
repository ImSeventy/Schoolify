import 'package:dartz/dartz.dart';
import 'package:frontend/core/errors/failures.dart';
import 'package:frontend/features/attendance/domain/entities/absence_entity.dart';

abstract class AttendanceRepository {
  Future<Either<Failure, List<AbsenceEntity>>> getStudentAbsences();
}