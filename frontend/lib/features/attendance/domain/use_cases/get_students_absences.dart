import 'package:dartz/dartz.dart';
import 'package:frontend/core/use_cases/use_case.dart';
import 'package:frontend/features/attendance/domain/entities/absence_entity.dart';
import 'package:frontend/features/attendance/domain/repository/attendance_repository.dart';

import '../../../../core/errors/failures.dart';

class GetStudentAbsencesUseCase extends UseCase<List<AbsenceEntity>, NoParams>{
  final AttendanceRepository attendanceRepository;

  GetStudentAbsencesUseCase({required this.attendanceRepository});

  @override
  Future<Either<Failure, List<AbsenceEntity>>> call(NoParams params) {
    return attendanceRepository.getStudentAbsences();
  }
}