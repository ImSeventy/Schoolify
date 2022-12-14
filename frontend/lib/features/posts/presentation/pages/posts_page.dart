import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/features/posts/presentation/bloc/posts_cubit/posts_cubit.dart';
import 'package:frontend/features/posts/presentation/bloc/posts_cubit/posts_states.dart';

import '../../../../dependency_container.dart';
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
        buildWhen: (oldState, newState) => oldState != newState,
        listenWhen: (oldState, newState) => oldState != newState,
        listener: (context, state) {},
        builder: (context, state) {
          PostsCubit postsCubit = context.read<PostsCubit>();
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: RefreshIndicator(
              onRefresh: () async {
                await postsCubit.getAllPosts();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 17.w),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  child: Column(
                    children: [
                      SizedBox(height: 100.h,),
                      ...postsCubit.posts.map((post) => Post(post: post,),).toList()
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

