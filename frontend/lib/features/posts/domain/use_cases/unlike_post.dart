import 'package:dartz/dartz.dart';
import 'package:frontend/core/errors/failures.dart';
import 'package:frontend/core/use_cases/use_case.dart';
import 'package:frontend/features/posts/domain/repository/posts_repository.dart';

class UnLikePostUseCase extends UseCase<void, UnLikePostParams> {
  final PostsRepository postsRepository;

  UnLikePostUseCase({required this.postsRepository});

  @override
  Future<Either<Failure, void>> call(UnLikePostParams params) {
    return postsRepository.unlikePost(postId: params.postId);
  }

}


class UnLikePostParams {
  final int postId;

  UnLikePostParams({required this.postId});
}