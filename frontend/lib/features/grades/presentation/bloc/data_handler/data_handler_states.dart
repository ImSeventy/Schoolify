import 'package:equatable/equatable.dart';

class DataHandlerState {}

class DataHandlerInitialState extends DataHandlerState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class DataHandlerSetNewGradesState extends DataHandlerState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class DataHandlerChangedYearModeState extends DataHandlerState with EquatableMixin {
  final String yearMode;

  DataHandlerChangedYearModeState(this.yearMode);
  @override
  List<Object?> get props => [yearMode];
}

class DataHandlerChangedSemesterModeState extends DataHandlerState with EquatableMixin {
  final String semesterMode;

  DataHandlerChangedSemesterModeState(this.semesterMode);
  @override
  List<Object?> get props => [semesterMode];
}