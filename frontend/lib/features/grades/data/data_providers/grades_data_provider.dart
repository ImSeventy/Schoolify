import 'package:dio/dio.dart';
import 'package:frontend/core/auth_info/auth_info.dart';
import 'package:frontend/core/constants/end_points.dart';
import 'package:frontend/core/errors/exceptions.dart';
import 'package:frontend/features/grades/data/models/grade.py.dart';

abstract class GradesDataProvider {
  Future<List<GradeModel>> getStudentGrades();
}

class GradesDataProviderImpl extends GradesDataProvider {
  late final Dio _dio;

  GradesDataProviderImpl() {
    _dio = Dio(BaseOptions(
      baseUrl: EndPoints.gradesEndPoint,
      connectTimeout: 2000,
      receiveTimeout: 10000,
      sendTimeout: 10000,
      validateStatus: (status) {
        return status != null && status < 500;
      },
    ));
  }

  @override
  Future<List<GradeModel>> getStudentGrades() async {
    try {
      Response response = await _dio.get(
        "/me",
        options: Options(headers: {
          "Authorization": "Bearer ${AuthInfo.accessTokens!.accessToken}"
        }),
      );

      if (response.statusCode == 401) {
        throw InvalidAccessTokenException();
      }

      List<Map<String, dynamic>> data = (response.data as List).cast<Map<String, dynamic>>();

      return data.map(GradeModel.fromJson).toList();
    } on DioError {
      throw ServerException();
    }

  }
}
