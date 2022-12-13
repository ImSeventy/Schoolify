import 'package:dartz/dartz.dart';
import 'package:frontend/core/errors/failures.dart';
import 'package:frontend/core/use_cases/use_case.dart';
import 'package:frontend/features/posts/domain/entities/posts_entity.dart';
import 'package:frontend/features/posts/domain/repository/posts_repository.dart';

class GetAllPostsUseCase extends UseCase<List<PostsEntity>, NoParams> {
  final PostsRepository postsRepository;

  GetAllPostsUseCase({required this.postsRepository});
  @override
  Future<Either<Failure, List<PostsEntity>>> call(NoParams params) {
    return postsRepository.getAllPosts();
  }

}