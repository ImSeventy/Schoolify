import 'package:dio/dio.dart';
import 'package:frontend/core/errors/exceptions.dart';
import 'package:frontend/features/attendance/data/models/absence_model.dart';

import '../../../../core/auth_info/auth_info.dart';
import '../../../../core/constants/end_points.dart';
import '../../../../core/network/interceptors.dart';

abstract class AttendanceDataProvider {
  Future<List<AbsenceModel>> getStudentAbsences();
}

class AttendanceDataProviderImpl implements AttendanceDataProvider {
  late final Dio _dio;

  AttendanceDataProviderImpl() {
    _dio = Dio(BaseOptions(
        baseUrl: EndPoints.absenceEndPoint,
        connectTimeout: 2000,
        receiveTimeout: 10000,
        sendTimeout: 10000,
        validateStatus: (status) {
          return status != null && status < 500;
        }));

    _dio.interceptors.add(InterceptorsWrapper(
        onRequest: onRequestInterceptor
    ));
  }

  @override
  Future<List<AbsenceModel>> getStudentAbsences() async {
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
      return data.map(AbsenceModel.fromJson).toList();
    } on DioError {
      throw ServerException();
    }
  }
}
