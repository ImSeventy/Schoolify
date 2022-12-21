import 'dart:io';

import 'package:dio/dio.dart';
import 'package:frontend/core/auth_info/auth_info.dart';
import 'package:frontend/core/errors/exceptions.dart';
import 'package:http_parser/http_parser.dart';

import '../../../../core/constants/end_points.dart';
import '../../../../core/network/interceptors.dart';

abstract class ProfileDataProvider {
  Future<void> updateStudent({required String email});
  Future<String> updateStudentProfileImage({required File image});
  Future<void> updateStudentPassword({
    required String currentPassword,
    required String newPassword,
  });
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

  @override
  Future<String> updateStudentProfileImage({required File image}) async {
    try {
      Response response = await _dio.patch(
        "/set_image",
        data: FormData.fromMap({
          "image": await MultipartFile.fromFile(
            image.path,
            contentType: MediaType(
              "image",
              "png",
            ),
          ),
        }),
        options: Options(headers: {
          "Authorization": "Bearer ${AuthInfo.accessTokens!.accessToken}"
        }),
      );

      if (response.statusCode == 401) {
        throw InvalidAccessTokenException();
      }

      if (response.statusCode == 400) {
        throw InvalidImageFormatException();
      }

      return response.data["image_url"];
    } on DioError {
      throw ServerException();
    }
  }

  @override
  Future<void> updateStudentPassword({required String currentPassword, required String newPassword}) async {
    try {
      Response response = await _dio.patch(
        "/reset_password",
        data: {
          "old_password": currentPassword,
          "new_password": newPassword
        },
        options: Options(headers: {
          "Authorization": "Bearer ${AuthInfo.accessTokens!.accessToken}"
        }),
      );

      if (response.statusCode == 401) {
        throw InvalidAccessTokenException();
      }

      if (response.statusCode == 400) {
        throw WrongPasswordException();
      }
    } on DioError {
      throw ServerException();
    }
  }
}
