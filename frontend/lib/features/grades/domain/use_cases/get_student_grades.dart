import 'package:dartz/dartz.dart';
import 'package:frontend/core/errors/failures.dart';
import 'package:frontend/core/use_cases/use_case.dart';
import 'package:frontend/features/grades/domain/entities/grade.py.dart';
import 'package:frontend/features/grades/domain/repository/grades_repository.dart';

class GetStudentGradesUseCase extends UseCase<List<GradeEntity>, NoParams> {
  final GradesRepository gradesRepository;

  GetStudentGradesUseCase({required this.gradesRepository});

  @override
  Future<Either<Failure, List<GradeEntity>>> call(NoParams params) {
    return gradesRepository.getStudentGrades();
  }

}