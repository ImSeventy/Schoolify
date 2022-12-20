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

class WarningsFailedState extends WarningsState with EquatableMixin{
  String message;

  WarningsFailedState({required this.message});

  @override
  List<Object?> get props => [];
}

class GetStudentWarningsFailedState extends WarningsFailedState{

  GetStudentWarningsFailedState({required super.message});

}