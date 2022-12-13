import 'package:equatable/equatable.dart';
import 'package:frontend/features/authentication/domain/entities/sutdent_rfid_entity.dart';

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

class GetStudentByRfidLoadingState extends LoginState with EquatableMixin{
  GetStudentByRfidLoadingState();

  @override
  List<Object?> get props => [];
}

class GetStudentByRfidSucceededState extends LoginState with EquatableMixin{
  final StudentRfidEntity student;

  GetStudentByRfidSucceededState({required this.student});

  @override
  List<Object?> get props => [student];
}

class GetStudentByRfidFailedState extends LoginState with EquatableMixin{
  final String message;

  GetStudentByRfidFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}