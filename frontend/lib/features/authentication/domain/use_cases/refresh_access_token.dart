import 'package:dartz/dartz.dart';
import 'package:frontend/core/auth_info/auth_info.dart';
import 'package:frontend/core/errors/failures.dart';
import 'package:frontend/core/use_cases/use_case.dart';
import 'package:frontend/features/authentication/domain/entities/tokens_entity.dart';
import 'package:frontend/features/authentication/domain/repository/authentication_repository.dart';

class RefreshAccessTokenUseCase extends UseCase<TokensEntity, NoParams> {
  final AuthenticationRepository authenticationRepository;

  RefreshAccessTokenUseCase({required this.authenticationRepository});

  @override
  Future<Either<Failure, TokensEntity>> call(NoParams params) async {
    final response = await authenticationRepository.refreshAccessToken();

    response.fold(
      (l) => null,
      (tokensEntity) => AuthInfo.accessTokens = tokensEntity,
    );

    return response;
  }
}
