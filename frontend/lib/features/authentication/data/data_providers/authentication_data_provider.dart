import 'package:dio/dio.dart';
import 'package:frontend/core/errors/exceptions.dart';
import 'package:frontend/core/constants/end_points.dart';
import 'package:frontend/features/authentication/data/models/tokens_model.dart';


abstract class AuthenticationDataProvider {
  Future<TokensModel> login({required email, required password});
}

class AuthenticationDataProviderImpl implements AuthenticationDataProvider {
  late final Dio _dio;

  AuthenticationDataProviderImpl() {
    _dio = Dio(BaseOptions(
        baseUrl: EndPoints.studentEndPoint,
        connectTimeout: 2000,
        receiveTimeout: 10000,
        sendTimeout: 10000,
        validateStatus: (status) {
          return status != null && status < 500;
        }));
  }

  @override
  Future<TokensModel> login({required email, required password}) async {
    try {
      final Response response = await _dio.post(
        "/login",
        data: FormData.fromMap(
          {
            "username": email,
            "password": password,
          },
        ),
      );

      if (response.statusCode == 401) {
        throw WrongEmailOrPasswordException();
      }

      return TokensModel.fromJson(response.data);
    } on DioError {
      throw ServerException();
    }
  }
}
