import 'package:equatable/equatable.dart';

class WarningsState {}

class WarningsInitialState extends WarningsState with EquatableMixin{
  @override
  List<Object?> get props => [];
}

class GetStudentWarningsSucceededState extends WarningsState with EquatableMixin{
  @override
  List<Object?> get props => [];
}

class GetStudentWarningsLoadingState extends WarningsState with EquatableMixin{
  @override
  List<Object?> get props => [];
}

class GetStudentWarningsFailedState extends WarningsState with EquatableMixin{
  final String msg;

  GetStudentWarningsFailedState({required this.msg});
  @override
  List<Object?> get props => [msg];
}