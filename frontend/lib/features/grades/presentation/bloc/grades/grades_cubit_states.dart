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

class GetStudentGradesFailedState extends GradesState with EquatableMixin{
  final String msg;

  GetStudentGradesFailedState(this.msg);

  @override
  List<Object?> get props => [msg];
}