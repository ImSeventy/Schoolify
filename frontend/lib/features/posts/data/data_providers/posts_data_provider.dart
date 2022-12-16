import 'package:dio/dio.dart';
import 'package:frontend/core/auth_info/auth_info.dart';
import 'package:frontend/core/errors/exceptions.dart';

import '../../../../core/constants/end_points.dart';
import '../models/posts_model.dart';

abstract class PostsDataProvider {
  Future<List<PostsModel>> getAllPosts();

  Future<void> likePost({required int postId});

  Future<void> unlikePost({required int postId});
}

class PostsDataProviderImpl implements PostsDataProvider {
  late Dio _dio;

  PostsDataProviderImpl() {
    _dio = Dio(
      BaseOptions(
        baseUrl: EndPoints.postsEndPoint,
        connectTimeout: 2000,
        receiveTimeout: 10000,
        sendTimeout: 10000,
        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    );
  }

  @override
  Future<List<PostsModel>> getAllPosts() async {
    try {
      Response response = await _dio.get(
        "/feed",
        options: Options(
          headers: {
            "Authorization": "Bearer ${AuthInfo.accessTokens!.accessToken}"
          },
        ),
      );

      if (response.statusCode == 401) {
        throw InvalidAccessTokenException();
      }

      List<Map<String, dynamic>> data =
          (response.data as List).cast<Map<String, dynamic>>();

      return data.map(PostsModel.fromJson).toList();
    } on DioError {
      throw ServerException();
    }
  }

  @override
  Future<void> likePost({required int postId}) async {
    try {
      Response response = await _dio.post(
        "/like?post_id=$postId",
        options: Options(
          headers: {
            "Authorization": "Bearer ${AuthInfo.accessTokens!.accessToken}"
          },
        ),
      );

      if (response.statusCode == 401) {
        throw InvalidAccessTokenException();
      }

      if (response.statusCode == 404) {
        throw PostNotFoundException();
      }

      if (response.statusCode == 409) {
        throw StudentAlreadyLikedThePostException();
      }
    } on DioError {
      throw ServerException();
    }
  }

  @override
  Future<void> unlikePost({required int postId}) async {
    try {
      Response response = await _dio.delete(
        "/like?post_id=$postId",
        options: Options(headers: {
          "Authorization": "Bearer ${AuthInfo.accessTokens!.accessToken}",
        }),
      );

      if (response.statusCode == 401) {
        throw InvalidAccessTokenException();
      }

      if (response.statusCode == 404) {
        throw PostNotFoundException();
      }

      if (response.statusCode == 409) {
        throw PostIsNotLikedByStudentException();
      }

    } on DioError {
      throw ServerException();
    }
  }
}
