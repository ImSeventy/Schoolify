import 'package:dartz/dartz.dart';
import 'package:frontend/core/errors/failures.dart';
import 'package:frontend/core/use_cases/use_case.dart';
import 'package:frontend/features/posts/domain/repository/posts_repository.dart';

class LikePostUseCase extends UseCase<void, LikePostParams> {
  final PostsRepository postsRepository;

  LikePostUseCase({required this.postsRepository});

  @override
  Future<Either<Failure, void>> call(LikePostParams params) {
    return postsRepository.likePost(postId: params.postId);
  }

}


class LikePostParams {
  final int postId;

  LikePostParams({required this.postId});
}