import 'package:bloc/bloc.dart';
import 'package:frontend/core/use_cases/use_case.dart';
import 'package:frontend/features/posts/data/models/posts_model.dart';
import 'package:frontend/features/posts/domain/use_cases/like_post.dart';
import 'package:frontend/features/posts/presentation/bloc/posts_cubit/posts_states.dart';

import '../../../domain/entities/posts_entity.dart';
import '../../../domain/use_cases/get_all_posts.dart';
import '../../../domain/use_cases/unlike_post.dart';

class PostsCubit extends Cubit<PostsState> {
  final GetAllPostsUseCase getAllPostsUseCase;
  final LikePostUseCase likePostUseCase;
  final UnLikePostUseCase unLikePostUseCase;

  List<PostsEntity> posts = [];

  PostsCubit({
    required this.getAllPostsUseCase,
    required this.likePostUseCase,
    required this.unLikePostUseCase
  }) : super(PostsInitialState());

  Future<void> getAllPosts() async {
    emit(GetAllPostsLoadingState());

    final response = await getAllPostsUseCase.call(NoParams());

    response.fold(
      (failure) => emit(GetAllPostsFailedState(message: failure.message)),
      (posts) {
        this.posts = posts;
        emit(GetAllPostsSucceededState());
      },
    );
  }

  Future<void> likePost({required int postId}) async {
    _setPostLikedState(postId: postId, state: true);
    emit(LikePostLoadingState(postId: postId));

    final response = await likePostUseCase.call(
      LikePostParams(postId: postId),
    );

    response.fold(
      (failure) {
        _setPostLikedState(postId: postId, state: false);
        emit(LikePostFailedState(message: failure.message, postId: postId));
      },
      (_) => emit(LikePostSucceededState(postId: postId)),
    );
  }

  Future<void> unLikePost({required int postId}) async {
    _setPostLikedState(postId: postId, state: false);
    emit(UnLikePostLoadingState(postId: postId));

    final response = await unLikePostUseCase.call(
      UnLikePostParams(postId: postId),
    );

    response.fold(
      (failure) {
        _setPostLikedState(postId: postId, state: true);
        emit(UnLikePostFailedState(message: failure.message, postId: postId));
      },
      (_) => emit(UnLikePostSucceededState(postId: postId)),
    );
  }

  void _setPostLikedState({required int postId, required bool state}) {
    int index = posts.indexWhere((post) => post.id == postId);
    posts[index] = (posts[index] as PostsModel).copyWith(liked: state);
  }
}
