import 'package:dartz/dartz.dart';
import 'package:frontend/core/auth_info/auth_info.dart';
import 'package:frontend/core/errors/exceptions.dart';
import 'package:frontend/core/errors/failures.dart';
import 'package:frontend/core/network/network_info.dart';
import 'package:frontend/features/warnings/data/data_providers/warnings_data_provider.dart';
import 'package:frontend/features/warnings/data/models/warning_model.dart';
import 'package:frontend/features/warnings/domain/entities/warning_entity.dart';
import 'package:frontend/features/warnings/domain/reposistory/warnings_repository.dart';

class WarningsRepositoryImpl implements WarningsRepository {
  final NetworkInfo networkInfo;
  final WarningsDataProvider warningsDataProvider;

  WarningsRepositoryImpl({required this.networkInfo, required this.warningsDataProvider});

  @override
  Future<Either<Failure, List<WarningEntity>>> getStudentWarnings() async {
    if (! await networkInfo.isConnected()) {
      return Left(NetworkFailure());
    }

    if (AuthInfo.accessTokens == null) {
      return Left(InvalidAccessTokenFailure());
    }

    try {
      List<WarningModel> warnings = await warningsDataProvider.getStudentWarning();
      return Right(warnings);
    } on ServerException {
      return Left(ServerFailure());
    } on InvalidAccessTokenException {
      return Left(InvalidAccessTokenFailure());
    } on InvalidRefreshTokenException {
      return Left(InvalidRefreshTokenFailure());
    }
  }

}