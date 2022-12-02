import 'package:equatable/equatable.dart';

class AttendanceState {}

class AttendanceInitialState extends AttendanceState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class GetStudentAbsencesLoadingState extends AttendanceState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class GetStudentAbsencesSucceededState extends AttendanceState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class GetStudentAbsencesFailedState extends AttendanceState with EquatableMixin {
  final String msg;

  GetStudentAbsencesFailedState({required this.msg});

  @override
  List<Object?> get props => [msg];
}