import 'package:equatable/equatable.dart';

class GradesState {}

class GradesInitialState extends GradesState with EquatableMixin{
  @override
  List<Object?> get props => [];
}

class GetStudentGradesLoadingState extends GradesState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class GetStudentGradeSucceededState extends GradesState  with EquatableMixin{
  @override
  List<Object?> get props => [];
}

class GradesFailedState extends GradesState with EquatableMixin {
  final String message;

  GradesFailedState(this.message);

  @override
  List<Object?> get props => [message];
}

class GetStudentGradesFailedState extends GradesFailedState{

  GetStudentGradesFailedState(super.message);

  @override
  List<Object?> get props => [message];
}