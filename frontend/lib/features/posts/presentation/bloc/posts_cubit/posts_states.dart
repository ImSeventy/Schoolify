import 'package:equatable/equatable.dart';

class PostsState {}


class PostsInitialState extends PostsState with EquatableMixin{
  @override
  List<Object?> get props => [];
}


class GetAllPostsLoadingState extends PostsState with EquatableMixin{
  @override
  List<Object?> get props => [];
}


class GetAllPostsSucceededState extends PostsState with EquatableMixin{
  @override
  List<Object?> get props => [];
}


class GetAllPostsFailedState extends PostsState with EquatableMixin{
  final String message;

  GetAllPostsFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}

class LikeState extends PostsState {
  final int postId;

  LikeState({required this.postId});
}

class LikePostLoadingState extends LikeState with EquatableMixin{
  LikePostLoadingState({required super.postId});
  @override
  List<Object?> get props => [];
}


class LikePostSucceededState extends LikeState with EquatableMixin{
  LikePostSucceededState({required super.postId});
  @override
  List<Object?> get props => [];
}


class LikePostFailedState extends LikeState with EquatableMixin{
  final String message;

  LikePostFailedState({required this.message, required super.postId});

  @override
  List<Object?> get props => [message];
}

class UnLikeState extends PostsState {
  final int postId;

  UnLikeState({required this.postId});
}


class UnLikePostLoadingState extends UnLikeState with EquatableMixin{

  UnLikePostLoadingState({required super.postId});

  @override
  List<Object?> get props => [];
}


class UnLikePostSucceededState extends UnLikeState with EquatableMixin{

  UnLikePostSucceededState({required super.postId});

  @override
  List<Object?> get props => [];
}


class UnLikePostFailedState extends UnLikeState with EquatableMixin{
  final String message;

  UnLikePostFailedState({required this.message, required super.postId});

  @override
  List<Object?> get props => [message];
}
