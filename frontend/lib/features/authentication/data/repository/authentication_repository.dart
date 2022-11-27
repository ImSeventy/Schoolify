import 'package:dartz/dartz.dart';
import 'package:frontend/core/errors/exceptions.dart';
import 'package:frontend/core/errors/failures.dart';
import 'package:frontend/core/network/network_info.dart';
import 'package:frontend/features/authentication/data/data_providers/authentication_data_provider.dart';
import 'package:frontend/features/authentication/data/data_providers/tokens_data_provider.dart';
import 'package:frontend/features/authentication/domain/entities/student_entity.dart';
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
    if (!await networkInfo.isConnected()) {}

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
}
