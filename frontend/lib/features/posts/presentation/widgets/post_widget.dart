import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/features/posts/presentation/bloc/posts_cubit/posts_cubit.dart';
import 'package:frontend/features/posts/presentation/bloc/posts_cubit/posts_states.dart';
import 'package:readmore/readmore.dart';

import '../../domain/entities/posts_entity.dart';
import 'package:timeago/timeago.dart' as timeago;

class Post extends StatelessWidget {
  final PostsEntity post;
  bool isLiked = false;
  Post({Key? key, required this.post}) : super(key: key) {
    isLiked = post.liked;
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


        if (newState is UnLikePostFailedState || newState is LikePostLoadingState) {
          isLiked = true;
          return true;
        }

        if (newState is LikePostFailedState || newState is UnLikePostLoadingState) {
          isLiked = false;
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
                  leading: SizedBox(
                    width: 62.w,
                    height: 64.h,
                    child: Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xFFCCC1F0)),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: post.byImageUrl == null || post.byImageUrl == ""
                          ? Image.asset(
                        "assets/default_profile.png",
                        width: 62.w,
                        height: 64.h,
                        fit: BoxFit.contain,
                      )
                          : CachedNetworkImage(
                        imageUrl: post.byImageUrl!,
                        width: 62.w,
                        height: 64.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  title: Text(
                    post.byName,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                        fontSize: 24.sp),
                  ),
                  subtitle: Text(
                    timeago.format(post.date),
                    style: TextStyle(
                        color: const Color(0xFFB9B9B9),
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: ReadMoreText(
                    post.content,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Poppins"),
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
                      CachedNetworkImage(
                        imageUrl: post.imageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 402,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                    ],
                  ),
                IconButton(
                  onPressed: isLiked
                      ? () => unLikePost(context)
                      : () => likePost(context),
                  icon: Icon(
                    isLiked
                        ? FontAwesomeIcons.solidHeart
                        : FontAwesomeIcons.heart,
                    color: const Color(0xFFFF269B),
                    size: 30,
                  ),
                  splashRadius: 10,
                )
              ]),
            ));
      },
    );
  }
}
