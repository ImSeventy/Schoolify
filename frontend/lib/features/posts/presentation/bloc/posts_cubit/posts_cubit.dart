import 'package:bloc/bloc.dart';
import 'package:frontend/core/use_cases/use_case.dart';
import 'package:frontend/features/posts/presentation/bloc/posts_cubit/posts_states.dart';

import '../../../domain/entities/posts_entity.dart';
import '../../../domain/use_cases/get_all_posts.dart';

class PostsCubit extends Cubit<PostsState> {
  final GetAllPostsUseCase getAllPostsUseCase;

  List<PostsEntity> posts = [];

  PostsCubit({required this.getAllPostsUseCase}) : super(PostsInitialState());

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
}
