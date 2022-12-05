import 'package:equatable/equatable.dart';

class CertificationsState {}


class CertificationsInitialState extends CertificationsState with EquatableMixin {
  @override
  List<Object?> get props => [];
}


class GetStudentCertificationsLoadingState extends CertificationsState with EquatableMixin {
  @override
  List<Object?> get props => [];
}


class GetStudentCertificationsFailedState extends CertificationsState with EquatableMixin {
  final String msg;

  GetStudentCertificationsFailedState({required this.msg});

  @override
  List<Object?> get props => [msg];
}


class GetStudentCertificationsSucceededState extends CertificationsState with EquatableMixin {
  @override
  List<Object?> get props => [];
}


