import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/features/posts/presentation/bloc/posts_cubit/posts_cubit.dart';
import 'package:frontend/features/posts/presentation/bloc/posts_cubit/posts_states.dart';
import 'package:readmore/readmore.dart';

import '../../../../core/widgets/avatar_image.dart';
import '../../../../core/widgets/zoomable_cached_image.dart';
import '../../domain/entities/posts_entity.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'animated_heart.dart';

class PostWidget extends StatelessWidget {
  final PostsEntity post;
  bool isLiked = false;
  int likeCount = 0;
  PostWidget({Key? key, required this.post}) : super(key: key) {
    isLiked = post.liked;
    likeCount = post.likeCount;
  }

  void likePost(BuildContext context) {
    PostsCubit postsCubit = context.read<PostsCubit>();
    postsCubit.likePost(postId: post.id);
  }

  void unLikePost(BuildContext context) {
    PostsCubit postsCubit = context.read<PostsCubit>();
    postsCubit.unLikePost(postId: post.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostsCubit, PostsState>(
      listenWhen: (oldState, newState) {
        if (newState == oldState) {
          return false;
        }

        if (newState is! LikeState && newState is! UnLikeState) {
          return false;
        }

        if (newState is LikeState && newState.postId != post.id) {
          return false;
        }

        if (newState is UnLikeState && newState.postId != post.id) {
          return false;
        }

        return true;
      },
      buildWhen: (oldState, newState) {
        if (newState == oldState) {
          return false;
        }

        if (newState is! LikeState && newState is! UnLikeState) {
          return false;
        }

        if (newState is LikeState && newState.postId != post.id) {
          return false;
        }

        if (newState is UnLikeState && newState.postId != post.id) {
          return false;
        }

        if (newState is UnLikePostFailedState ||
            newState is LikePostLoadingState) {
          isLiked = true;
          likeCount++;
          return true;
        }

        if (newState is LikePostFailedState ||
            newState is UnLikePostLoadingState) {
          isLiked = false;
          likeCount--;
          return true;
        }

        return false;
      },
      listener: (context, state) {
        if (state is LikePostFailedState) {
          showToastMessage(state.message, Colors.red, context);
        }

        if (state is UnLikePostFailedState) {
          showToastMessage(state.message, Colors.red, context);
        }
      },
      builder: (context, state) {
        return Container(
            margin: EdgeInsets.only(bottom: 28.h),
            decoration: BoxDecoration(
              color: const Color(0xB4130B51),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.5.w, vertical: 8.h),
              child: Column(children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: AvatarImage(
                    imageUrl: post.byImageUrl,
                    width: 70.w,
                    height: 70.h,
                  ),
                  title: Text(
                    post.byName,
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      fontSize: 20.sp,
                    ),
                  ),
                  subtitle: Text(
                    timeago.format(post.date),
                    style: Theme.of(context).textTheme.headline4?.copyWith(
                      color: const Color(0xFFB9B9B9),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: ReadMoreText(
                    post.content,
                    style: Theme.of(context).textTheme.headline3?.copyWith(
                      color: Colors.white
                    ),
                    moreStyle: const TextStyle(color: Color(0xFFBDBDBD)),
                    lessStyle: const TextStyle(color: Color(0xFFBDBDBD)),
                    trimExpandedText: " Read less",
                    trimCollapsedText: "Read more",
                    delimiter: ".....",
                    trimMode: TrimMode.Line,
                    trimLines: 2,
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                if (post.imageUrl != null || post.imageUrl != "")
                  Column(
                    children: [
                      ZoomableCachedImage(
                        imageUrl: post.imageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 350.h,
                        placeHolderAssetPath: 'assets/image_placeholder.png',
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                    ],
                  ),
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Text(
                    "$likeCount likes",
                    style: TextStyle(
                        color: Colors.grey,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp),
                  ),
                ),
                IconButton(
                  onPressed: isLiked
                      ? () => unLikePost(context)
                      : () => likePost(context),
                  icon: AnimatedHeart(
                    isLiked: isLiked,
                  ),
                  splashRadius: 10,
                )
              ]),
            ));
      },
    );
  }
}
