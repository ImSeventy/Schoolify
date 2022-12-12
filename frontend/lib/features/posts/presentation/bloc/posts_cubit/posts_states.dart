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