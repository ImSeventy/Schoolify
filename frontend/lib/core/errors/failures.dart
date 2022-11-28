import 'package:equatable/equatable.dart';

class Failure {
  final String message;

  Failure(this.message);
}


class ServerFailure extends Failure with EquatableMixin {

  ServerFailure() : super("Error on the server side try again later !!");

  @override
  List<Object?> get props => [message];
}


class WrongEmailOrPasswordFailure extends Failure with EquatableMixin {

  WrongEmailOrPasswordFailure() : super("Wrong E-mail or Password");

  @override
  List<Object?> get props => [message];
}


class NetworkFailure extends Failure with EquatableMixin {

  NetworkFailure() : super("There is no internet connection");

  @override
  List<Object?> get props => [message];
}


class InvalidAccessTokenFailure extends Failure with EquatableMixin {

  InvalidAccessTokenFailure() : super("Invalid access token");

  @override
  List<Object?> get props => [message];
}