import 'package:dartz/dartz.dart';
import 'package:frontend/features/posts/domain/entities/posts_entity.dart';

import '../../../../core/errors/failures.dart';

abstract class PostsRepository {
  Future<Either<Failure, List<PostsEntity>>> getAllPosts();

  Future<Either<Failure, void>> likePost({required int postId});

  Future<Either<Failure, void>> unlikePost({required int postId});
}