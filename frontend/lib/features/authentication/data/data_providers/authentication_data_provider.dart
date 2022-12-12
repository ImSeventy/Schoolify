import 'package:dio/dio.dart';
import 'package:frontend/core/auth_info/auth_info.dart';
import 'package:frontend/core/errors/exceptions.dart';
import 'package:frontend/core/constants/end_points.dart';
import 'package:frontend/features/authentication/data/models/student_model.dart';
import 'package:frontend/features/authentication/data/models/tokens_model.dart';
import 'package:frontend/features/authentication/domain/entities/student_entity.dart';

import '../../../../core/network/interceptors.dart';
import '../models/sutdent_rfid_model.dart';


abstract class AuthenticationDataProvider {
  Future<TokensModel> login({required email, required password});

  Future<StudentEntity> getCurrentStudent();

  Future<TokensModel> refreshAccessToken();
  
  Future<StudentRfidModel> getStudentFromRfid({required rfid});
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

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: onRequestInterceptor
    ));
  }

  @override
  Future<TokensModel> login({required email, required password}) async {
    try {
      Response response = await _dio.post(
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
    } on DioError{
      throw ServerException();
    }
  }

  @override
  Future<StudentEntity> getCurrentStudent() async {
    try {
      Response response = await _dio.get(
        "/me",
        options: Options(
          headers: {
            "Authorization": "Bearer ${AuthInfo.accessTokens?.accessToken}"
          }
        )
      );

      if (response.statusCode == 401) {
        throw InvalidAccessTokenException();
      }

      return StudentModel.fromJson(response.data);
    } on DioError{
      throw ServerException();
    }
  }

  @override
  Future<TokensModel> refreshAccessToken() async {
    try {
      Response response = await _dio.post(
          "/refresh",
          options: Options(
              headers: {
                "Authorization": "Bearer ${AuthInfo.accessTokens?.refreshToken}"
              }
          )
      );

      if (response.statusCode == 401) {
        throw InvalidRefreshTokenException();
      }

      return TokensModel.fromJson(response.data);
    } on DioError{
      throw ServerException();
    }
  }

  @override
  Future<StudentRfidModel> getStudentFromRfid({required rfid}) async {
    try {
      Response response = await _dio.get("/rfid/$rfid");

      if (response.statusCode == 404) {
        throw StudentNotFoundException();
      }

      return StudentRfidModel.fromJson(response.data);
    }on DioError {
      throw ServerException();
    }
  }
}
