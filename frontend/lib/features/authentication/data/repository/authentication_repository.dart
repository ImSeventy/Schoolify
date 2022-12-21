import 'package:dartz/dartz.dart';
import 'package:frontend/core/auth_info/auth_info.dart';
import 'package:frontend/core/errors/exceptions.dart';
import 'package:frontend/core/errors/failures.dart';
import 'package:frontend/core/network/network_info.dart';
import 'package:frontend/features/authentication/data/data_providers/authentication_data_provider.dart';
import 'package:frontend/features/authentication/data/data_providers/tokens_data_provider.dart';
import 'package:frontend/features/authentication/data/models/tokens_model.dart';
import 'package:frontend/features/authentication/domain/entities/student_entity.dart';
import 'package:frontend/features/authentication/domain/entities/sutdent_rfid_entity.dart';
import 'package:frontend/features/authentication/domain/repository/authentication_repository.dart';

import '../../domain/entities/tokens_entity.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final NetworkInfo networkInfo;
  final TokensDataProvider tokensDataProvider;
  final AuthenticationDataProvider authenticationDataProvider;

  AuthenticationRepositoryImpl({
    required this.networkInfo,
    required this.tokensDataProvider,
    required this.authenticationDataProvider,
  });

  @override
  Future<Either<Failure, TokensEntity>> login({
    required String email,
    required String password,
  }) async {
    if (!await networkInfo.isConnected()) {
      return Left(NetworkFailure());
    }

    try {
      TokensEntity tokensEntity = await authenticationDataProvider.login(
        email: email,
        password: password,
      );
      return Right(tokensEntity);
    } on ServerException {
      return Left(ServerFailure());
    } on WrongEmailOrPasswordException {
      return Left(WrongEmailOrPasswordFailure());
    }
  }

  @override
  Future<Either<Failure, StudentEntity>> getCurrentStudent() async {
    if (!await networkInfo.isConnected()) {
    return Left(NetworkFailure());
    }


    if (AuthInfo.accessTokens == null) {
      return Left(InvalidAccessTokenFailure());
    }

    try {
      StudentEntity studentEntity =  await authenticationDataProvider.getCurrentStudent();
      return Right(studentEntity);
    } on ServerException {
    return Left(ServerFailure());
    } on WrongEmailOrPasswordException {
    return Left(WrongEmailOrPasswordFailure());
    } on InvalidAccessTokenException {
      return Left(InvalidAccessTokenFailure());
    } on InvalidRefreshTokenException {
      return Left(InvalidRefreshTokenFailure());
    }
  }

  @override
  Future<Either<Failure, TokensEntity>> refreshAccessToken() async {
    if (!await networkInfo.isConnected()) {
    return Left(NetworkFailure());
    }


    if (AuthInfo.accessTokens == null) {
    return Left(InvalidAccessTokenFailure());
    }

    try {
    TokensModel tokensModel =  await authenticationDataProvider.refreshAccessToken();
    return Right(tokensModel);
    } on ServerException {
    return Left(ServerFailure());
    } on InvalidRefreshTokenException {
    return Left(InvalidRefreshTokenFailure());
    }
  }

  @override
  Future<Either<Failure, TokensEntity>> loadCachedAccessTokens() async {
    TokensEntity? tokensEntity = tokensDataProvider.getCachedTokens();

    if (tokensEntity == null) return Left(NoCachedAccessTokensFailure());

    return Right(tokensEntity);
  }

  @override
  Future<Either<Failure, StudentRfidEntity>> getStudentByRfid({required rfid}) async {
    if (!await networkInfo.isConnected()) {
    return Left(NetworkFailure());
    }

    try {
    StudentRfidEntity studentRfidEntity =  await authenticationDataProvider.getStudentFromRfid(rfid: rfid);
    return Right(studentRfidEntity);
    } on ServerException {
    return Left(ServerFailure());
    } on StudentNotFoundException {
    return Left(StudentNotFoundFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logOut() async {
    tokensDataProvider.removeTokensStoredInCache();
    AuthInfo.clear();
    return const Right(null);
  }
}
