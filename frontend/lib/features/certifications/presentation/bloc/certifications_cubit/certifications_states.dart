import 'package:equatable/equatable.dart';

class CertificationsState {}


class CertificationsInitialState extends CertificationsState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class CertificationsFailedState extends CertificationsState with EquatableMixin {
  String message;

  CertificationsFailedState({required this.message});

  @override
  List<Object?> get props => [];
}


class GetStudentCertificationsLoadingState extends CertificationsState with EquatableMixin {
  @override
  List<Object?> get props => [];
}


class GetStudentCertificationsFailedState extends CertificationsFailedState {

  GetStudentCertificationsFailedState({required super.message});

}


class GetStudentCertificationsSucceededState extends CertificationsState with EquatableMixin {
  @override
  List<Object?> get props => [];
}


