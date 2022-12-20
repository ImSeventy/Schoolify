import 'package:equatable/equatable.dart';

class AttendanceState {}

class AttendanceInitialState extends AttendanceState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class AttendanceFailedState extends AttendanceState with EquatableMixin {
  String message;

  AttendanceFailedState({required this.message});

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

class GetStudentAbsencesFailedState extends AttendanceFailedState {

  GetStudentAbsencesFailedState({required super.message});

}