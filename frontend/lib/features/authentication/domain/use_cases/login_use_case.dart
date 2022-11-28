import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/core/auth_info/auth_info.dart';
import 'package:frontend/core/errors/failures.dart';
import 'package:frontend/core/use_cases/use_case.dart';
import 'package:frontend/dependency_container.dart';
import 'package:frontend/features/authentication/data/data_providers/tokens_data_provider.dart';
import 'package:frontend/features/authentication/data/models/tokens_model.dart';
import 'package:frontend/features/authentication/domain/entities/tokens_entity.dart';
import 'package:frontend/features/authentication/domain/repository/authentication_repository.dart';
import 'package:frontend/features/authentication/domain/use_cases/get_current_student_use_case.dart';

class LoginUseCase implements UseCase<TokensEntity, LoginParams> {
  final AuthenticationRepository authenticationRepository;

  LoginUseCase({required this.authenticationRepository});

  @override
  Future<Either<Failure, TokensEntity>> call(LoginParams params) async {
    final response = await authenticationRepository.login(
        email: params.email, password: params.password);

    response.fold(
      (failure) => null,
      (tokensEntity) async {
        getIt<TokensDataProvider>().storeTokensInCache(tokensEntity as TokensModel);
        AuthInfo.accessTokens = tokensEntity;
      },
    );

    return response;
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
