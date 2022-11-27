import 'package:equatable/equatable.dart';

class Failure {
  final String message = "";
}


class ServerFailure extends Failure with EquatableMixin {
  final String message = "Error on the server side try again later !!";

  @override
  List<Object?> get props => [message];
}


class WrongEmailOrPasswordFailure extends Failure with EquatableMixin {
  final String message = "Wrong E-mail or Password";

  @override
  List<Object?> get props => [message];
}