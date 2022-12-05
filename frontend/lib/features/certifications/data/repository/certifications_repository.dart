import 'package:dartz/dartz.dart';
import 'package:frontend/core/errors/failures.dart';
import 'package:frontend/core/network/network_info.dart';
import 'package:frontend/features/certifications/data/data_providers/certifiactions_data_provider.dart';
import 'package:frontend/features/certifications/data/models/certifications_model.dart';
import 'package:frontend/features/certifications/domain/entities/certification_entity.dart';
import 'package:frontend/features/certifications/domain/repository/certifications_repository.dart';

import '../../../../core/auth_info/auth_info.dart';
import '../../../../core/errors/exceptions.dart';

class CertificationsRepositoryImpl implements CertificationsRepository {
  final NetworkInfo networkInfo;
  final CertificationsDataProvider certificationsDataProvider;

  CertificationsRepositoryImpl({
    required this.networkInfo,
    required this.certificationsDataProvider,
  });

  @override
  Future<Either<Failure, List<CertificationEntity>>> getStudentCertifications() async {
    if (!await networkInfo.isConnected()) {
      return Left(NetworkFailure());
    }

    if (AuthInfo.accessTokens == null) {
      return Left(InvalidAccessTokenFailure());
    }

    try {
      List<CertificationModel> certifications = await certificationsDataProvider.getStudentCertifications();
      return Right(certifications);
    } on ServerException {
      return Left(ServerFailure());
    } on InvalidAccessTokenException {
      return Left(InvalidAccessTokenFailure());
    } on InvalidRefreshTokenException {
      return Left(InvalidRefreshTokenFailure());
    }
  }
}
