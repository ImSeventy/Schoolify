import 'package:dartz/dartz.dart';
import 'package:frontend/core/auth_info/auth_info.dart';
import 'package:frontend/core/errors/exceptions.dart';
import 'package:frontend/core/errors/failures.dart';
import 'package:frontend/core/network/network_info.dart';
import 'package:frontend/features/grades/data/data_providers/grades_data_provider.dart';
import 'package:frontend/features/grades/data/models/grade.py.dart';
import 'package:frontend/features/grades/domain/entities/grade.py.dart';
import 'package:frontend/features/grades/domain/repository/grades_repository.dart';

class GradesRepositoryImpl implements GradesRepository {
  final NetworkInfo networkInfo;
  final GradesDataProvider gradesDataProvider;

  GradesRepositoryImpl({required this.networkInfo, required this.gradesDataProvider,});

  @override
  Future<Either<Failure, List<GradeEntity>>> getStudentGrades() async {
    if (!await networkInfo.isConnected()) {
      return Left(NetworkFailure());
    }

    if (AuthInfo.accessTokens == null) {
      return Left(InvalidAccessTokenFailure());
    }

    try {
      List<GradeModel> gradeModels = await gradesDataProvider.getStudentGrades();
      return Right(gradeModels);
    } on ServerException {
      return Left(ServerFailure());
    } on InvalidAccessTokenException {
      return Left(InvalidAccessTokenFailure());
    }
  }

}