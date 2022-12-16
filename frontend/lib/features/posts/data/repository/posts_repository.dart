import 'package:dartz/dartz.dart';
import 'package:frontend/core/auth_info/auth_info.dart';
import 'package:frontend/core/errors/failures.dart';
import 'package:frontend/core/network/network_info.dart';
import 'package:frontend/features/posts/data/data_providers/posts_data_provider.dart';
import 'package:frontend/features/posts/data/models/posts_model.dart';
import 'package:frontend/features/posts/domain/entities/posts_entity.dart';
import 'package:frontend/features/posts/domain/repository/posts_repository.dart';

import '../../../../core/errors/exceptions.dart';

class PostsRepositoryImpl implements PostsRepository {
  final NetworkInfo networkInfo;
  final PostsDataProvider postsDataProvider;

  PostsRepositoryImpl({
    required this.networkInfo,
    required this.postsDataProvider,
  });
  @override
  Future<Either<Failure, List<PostsEntity>>> getAllPosts() async {
    if (!await networkInfo.isConnected()) {
      return Left(NetworkFailure());
    }

    if (AuthInfo.accessTokens == null) {
      return Left(InvalidAccessTokenFailure());
    }

    try {
      List<PostsModel> posts = await postsDataProvider.getAllPosts();

      return Right(posts);
    } on ServerException {
      return Left(ServerFailure());
    } on InvalidAccessTokenException {
      return Left(InvalidAccessTokenFailure());
    } on InvalidRefreshTokenException {
      return Left(InvalidRefreshTokenFailure());
    }
  }

  @override
  Future<Either<Failure, void>> likePost({required int postId}) async {
    if (!await networkInfo.isConnected()) {
    return Left(NetworkFailure());
    }

    if (AuthInfo.accessTokens == null) {
    return Left(InvalidAccessTokenFailure());
    }

    try {
    await postsDataProvider.likePost(postId: postId);

    return const Right(null);
    } on ServerException {
    return Left(ServerFailure());
    } on InvalidAccessTokenException {
    return Left(InvalidAccessTokenFailure());
    } on InvalidRefreshTokenException {
    return Left(InvalidRefreshTokenFailure());
    } on PostNotFoundException {
      return Left(StudentAlreadyLikedThePostFailure());
    } on StudentAlreadyLikedThePostException {
      return Left(PostNotFoundFailure());
    }
  }

  @override
  Future<Either<Failure, void>> unlikePost({required int postId}) async {
    if (!await networkInfo.isConnected()) {
    return Left(NetworkFailure());
    }

    if (AuthInfo.accessTokens == null) {
    return Left(InvalidAccessTokenFailure());
    }

    try {
    await postsDataProvider.unlikePost(postId: postId);

    return const Right(null);
    } on ServerException {
    return Left(ServerFailure());
    } on InvalidAccessTokenException {
    return Left(InvalidAccessTokenFailure());
    } on InvalidRefreshTokenException {
    return Left(InvalidRefreshTokenFailure());
    } on PostNotFoundException {
      return Left(PostIsNotLikedByStudentFailure());
    } on PostIsNotLikedByStudentException {
      return Left(PostNotFoundFailure());
    }
  }
}
