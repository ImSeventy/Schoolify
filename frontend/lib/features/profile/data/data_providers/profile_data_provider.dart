import 'package:dio/dio.dart';
import 'package:frontend/core/auth_info/auth_info.dart';
import 'package:frontend/core/errors/exceptions.dart';

import '../../../../core/constants/end_points.dart';
import '../../../../core/network/interceptors.dart';

abstract class ProfileDataProvider {
  Future<void> updateStudent({required String email});
}

class ProfileDataProviderImpl implements ProfileDataProvider {
  late final Dio _dio;

  ProfileDataProviderImpl() {
    _dio = Dio(BaseOptions(
      baseUrl: EndPoints.studentEndPoint,
      connectTimeout: 2000,
      receiveTimeout: 10000,
      sendTimeout: 10000,
      validateStatus: (status) {
        return status != null && status < 500;
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(onRequest: onRequestInterceptor));
  }

  @override
  Future<void> updateStudent({required String email}) async {
    try {
      Response response = await _dio.put(
        "/",
        data: {
          "email": email,
        },
        options: Options(headers: {
          "Authorization": "Bearer ${AuthInfo.accessTokens!.accessToken}"
        }),
      );

      if (response.statusCode == 401) {
        throw InvalidAccessTokenException();
      }
    } on DioError {
      throw ServerException();
    }
  }
}
