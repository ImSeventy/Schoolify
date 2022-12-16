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


class LikePostLoadingState extends PostsState with EquatableMixin{
  @override
  List<Object?> get props => [];
}


class LikePostSucceededState extends PostsState with EquatableMixin{
  @override
  List<Object?> get props => [];
}


class LikePostFailedState extends PostsState with EquatableMixin{
  final String message;

  LikePostFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}


class UnLikePostLoadingState extends PostsState with EquatableMixin{
  @override
  List<Object?> get props => [];
}


class UnLikePostSucceededState extends PostsState with EquatableMixin{
  @override
  List<Object?> get props => [];
}


class UnLikePostFailedState extends PostsState with EquatableMixin{
  final String message;

  UnLikePostFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}
