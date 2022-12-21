import 'package:equatable/equatable.dart';

import '../constants/error_messages.dart';

class Failure {
  final String message;

  Failure(this.message);
}


class ServerFailure extends Failure with EquatableMixin {

  ServerFailure() : super(ErrorMessages.serverFailure);

  @override
  List<Object?> get props => [message];
}


class WrongEmailOrPasswordFailure extends Failure with EquatableMixin {

  WrongEmailOrPasswordFailure() : super(ErrorMessages.wrongEmailOrPasswordFailure);

  @override
  List<Object?> get props => [message];
}


class NetworkFailure extends Failure with EquatableMixin {

  NetworkFailure() : super(ErrorMessages.networkFailure);

  @override
  List<Object?> get props => [message];
}


class InvalidAccessTokenFailure extends Failure with EquatableMixin {

  InvalidAccessTokenFailure() : super(ErrorMessages.invalidAccessTokenFailure);

  @override
  List<Object?> get props => [message];
}

class InvalidRefreshTokenFailure extends Failure with EquatableMixin {

  InvalidRefreshTokenFailure() : super(ErrorMessages.invalidRefreshTokenFailure);

  @override
  List<Object?> get props => [message];
}


class NoCachedAccessTokensFailure extends Failure with EquatableMixin {

  NoCachedAccessTokensFailure() : super(ErrorMessages.noCachedAccessTokensFailure);

  @override
  List<Object?> get props => [message];
}


class StudentNotFoundFailure extends Failure with EquatableMixin {

  StudentNotFoundFailure() : super(ErrorMessages.studentNotFoundFailure);

  @override
  List<Object?> get props => [message];
}


class StudentAlreadyLikedThePostFailure extends Failure with EquatableMixin {

  StudentAlreadyLikedThePostFailure() : super(ErrorMessages.studentAlreadyLikedThePostFailure);

  @override
  List<Object?> get props => [message];
}


class PostNotFoundFailure extends Failure with EquatableMixin {

  PostNotFoundFailure() : super(ErrorMessages.postNotFoundFailure);

  @override
  List<Object?> get props => [message];
}


class PostIsNotLikedByStudentFailure extends Failure with EquatableMixin {

  PostIsNotLikedByStudentFailure() : super(ErrorMessages.postIsNotLikedByStudentFailure);

  @override
  List<Object?> get props => [message];
}


class InvalidImageFormatFailure extends Failure with EquatableMixin {

  InvalidImageFormatFailure() : super(ErrorMessages.invalidImageFormat);

  @override
  List<Object?> get props => [message];
}


class WrongPasswordFailure extends Failure with EquatableMixin {

  WrongPasswordFailure() : super(ErrorMessages.wrongPassword);

  @override
  List<Object?> get props => [message];
}