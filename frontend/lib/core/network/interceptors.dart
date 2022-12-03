import 'package:dio/dio.dart';
import '../../dependency_container.dart';
import '../../features/authentication/domain/use_cases/refresh_access_token.dart';
import '../errors/exceptions.dart';
import '../errors/failures.dart';
import '../use_cases/use_case.dart';
import '../utils/checks.dart';

void onRequestInterceptor(
    RequestOptions options, RequestInterceptorHandler handler) async {
  String? accessToken = options.headers["Authorization"];
  if (accessToken == null) {
    return handler.next(options);
  }

  if (checkTokenIntegrity(accessToken)) {
    return handler.next(options);
  }

  if (options.path == "/refresh") {
    throw InvalidRefreshTokenException();
  }

  final tokensOrFailure =
      await getIt<RefreshAccessTokenUseCase>().call(NoParams());

  return tokensOrFailure.fold((failure) {
    if (failure is ServerFailure) {
      return handler.reject(DioError(requestOptions: options));
    }

    if (failure is InvalidRefreshTokenFailure) {
      throw InvalidRefreshTokenException();
    }
  }, (tokensEntity) {
    options.headers["Authorization"] = "Bearer ${tokensEntity.accessToken}";
    return handler.next(options);
  });
}
