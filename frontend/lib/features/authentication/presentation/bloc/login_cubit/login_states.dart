import 'package:equatable/equatable.dart';

class LoginState {}

class LoginInitialState extends LoginState with EquatableMixin{

  @override
  List<Object?> get props => [];
}

class LoginLoadingState extends LoginState with EquatableMixin{
  @override
  List<Object?> get props => [];
}

class LoginSucceededState extends LoginState with EquatableMixin{
  @override
  List<Object?> get props => [];
}

class LoginFailedState extends LoginState with EquatableMixin{
  final String message;

  LoginFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}