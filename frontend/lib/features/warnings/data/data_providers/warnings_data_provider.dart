import 'package:dio/dio.dart';
import 'package:frontend/core/auth_info/auth_info.dart';
import 'package:frontend/core/errors/exceptions.dart';

import '../../../../core/constants/end_points.dart';
import '../../../../core/network/interceptors.dart';
import '../models/warning_model.dart';

abstract class WarningsDataProvider {
  Future<List<WarningModel>> getStudentWarning();
}

class WarningsDataProviderImpl implements WarningsDataProvider {
  late Dio _dio;

  WarningsDataProviderImpl() {
    _dio = Dio(BaseOptions(
      baseUrl: EndPoints.warningsEndPoint,
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
  Future<List<WarningModel>> getStudentWarning() async {
    try {
      Response response = await _dio.get(
        "/me",
        options: Options(
          headers: {
            "Authorization": "Bearer ${AuthInfo.accessTokens!.accessToken}"
          },
        ),
      );

      if (response.statusCode == 401) {
        throw InvalidAccessTokenException();
      }

      List<Map<String, dynamic>> data = (response.data as List).cast<Map<String, dynamic>>();

      return data.map(WarningModel.fromJson).toList();
    } on DioError {
      throw ServerException();
    }
  }
}
