import 'package:equatable/equatable.dart';

class ProfileState {}

class ProfileInitialState extends ProfileState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class ProfileLoadingState extends ProfileState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class ProfileFailedState extends ProfileState with EquatableMixin {
  final String message;

  ProfileFailedState({required this.message});

  @override
  List<Object?> get props => [];
}

class UpdateStudentProfileLoadingState extends ProfileLoadingState {}

class UpdateStudentProfileFailedState extends ProfileFailedState {
  UpdateStudentProfileFailedState({required super.message});
}

class UpdateStudentProfileSucceededState extends ProfileState {}

class UpdateStudentProfileImageLoadingState extends ProfileLoadingState {}

class UpdateStudentProfileImageFailedState extends ProfileFailedState {
  UpdateStudentProfileImageFailedState({required super.message});
}

class UpdateStudentProfileImageSucceededState extends ProfileState {}

class UpdateStudentPasswordLoadingState extends ProfileLoadingState {}

class UpdateStudentPasswordFailedState extends ProfileFailedState {
  UpdateStudentPasswordFailedState({required super.message});
}

class UpdateStudentPasswordSucceededState extends ProfileState {}