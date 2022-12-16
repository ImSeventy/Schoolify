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

class InvalidRefreshTokenFailure extends Failure with EquatableMixin {

  InvalidRefreshTokenFailure() : super("Invalid refresh token");

  @override
  List<Object?> get props => [message];
}


class NoCachedAccessTokensFailure extends Failure with EquatableMixin {

  NoCachedAccessTokensFailure() : super("There is not cached access tokens");

  @override
  List<Object?> get props => [message];
}


class StudentNotFoundFailure extends Failure with EquatableMixin {

  StudentNotFoundFailure() : super("There is not student with the provided rfid");

  @override
  List<Object?> get props => [message];
}


class StudentAlreadyLikedThePostFailure extends Failure with EquatableMixin {

  StudentAlreadyLikedThePostFailure() : super("You've already liked this post");

  @override
  List<Object?> get props => [message];
}


class PostNotFoundFailure extends Failure with EquatableMixin {

  PostNotFoundFailure() : super("The post doesn't exist");

  @override
  List<Object?> get props => [message];
}


class PostIsNotLikedByStudentFailure extends Failure with EquatableMixin {

  PostIsNotLikedByStudentFailure() : super("The post is not liked by the student");

  @override
  List<Object?> get props => [message];
}