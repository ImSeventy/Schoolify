import 'package:dartz/dartz.dart';
import 'package:frontend/core/errors/failures.dart';

import '../entities/grade.py.dart';

abstract class GradesRepository{
  Future<Either<Failure, List<GradeEntity>>> getStudentGrades();
}