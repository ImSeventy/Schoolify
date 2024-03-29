import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/core/utils/extensions.dart';
import 'package:frontend/core/widgets/refresh_page_handler.dart';
import 'package:frontend/features/posts/presentation/bloc/posts_cubit/posts_cubit.dart';
import 'package:frontend/features/posts/presentation/bloc/posts_cubit/posts_states.dart';

import '../../../../core/constants/error_messages.dart';
import '../../../../core/use_cases/use_case.dart';
import '../../../../core/utils/utils.dart';
import '../../../../dependency_container.dart';
import '../../../../router/routes.dart';
import '../../../authentication/domain/use_cases/logout_use_case.dart';
import '../widgets/post_widget.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostsCubit>(
      create: (_) {
        PostsCubit postsCubit = getIt<PostsCubit>();
        postsCubit.getAllPosts();

        return postsCubit;
      },
      child: BlocConsumer<PostsCubit, PostsState>(
        buildWhen: (oldState, newState) =>
            oldState != newState &&
            (newState is! LikeState && newState is! UnLikeState),
        listenWhen: (oldState, newState) => oldState != newState &&
            (newState is! LikeState || newState is! UnLikeState),
        listener: (context, state) {
          if (state is GetAllPostsFailedState) {
            showToastMessage(state.message, context.colorScheme.error, context);

            if (state.message == ErrorMessages.invalidAccessTokenFailure || state.message == ErrorMessages.invalidRefreshTokenFailure) {
              getIt<LogOutUseCase>().call(NoParams());
              context.pushNamedAndRemove(Routes.login);
            }
          }
        },
        builder: (context, state) {
          PostsCubit postsCubit = context.read<PostsCubit>();
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: RefreshPageHandler(
              onRefresh: () async {
                await postsCubit.getAllPosts();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 17.w),
                child: ListView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  children: [
                    SizedBox(
                      height: 100.h,
                    ),
                    ...postsCubit.posts
                        .map(
                          (post) => PostWidget(
                            post: post,
                          ),
                        )
                        .toList()
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
