import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:frontend/core/errors/exceptions.dart';

import 'package:frontend/core/errors/failures.dart';
import 'package:frontend/core/network/network_info.dart';

import '../../../../core/auth_info/auth_info.dart';
import '../../domain/repository/profile_repository.dart';
import '../data_providers/profile_data_provider.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final NetworkInfo networkInfo;
  final ProfileDataProvider profileDataProvider;
  ProfileRepositoryImpl({
    required this.networkInfo,
    required this.profileDataProvider,
  });

  @override
  Future<Either<Failure, void>> updateStudent({required String email}) async {
    if (!await networkInfo.isConnected()) {
      return Left(NetworkFailure());
    }

    if (AuthInfo.accessTokens == null) {
      return Left(InvalidAccessTokenFailure());
    }

    try {
      await profileDataProvider.updateStudent(email: email);
      return const Right(null);
    } on InvalidAccessTokenException {
      return Left(InvalidAccessTokenFailure());
    } on InvalidRefreshTokenException {
      return Left(InvalidRefreshTokenFailure());
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> updateStudentProfileImage(
      {required File image}) async {
    if (!await networkInfo.isConnected()) {
      return Left(NetworkFailure());
    }

    if (AuthInfo.accessTokens == null) {
      return Left(InvalidAccessTokenFailure());
    }

    try {
      String imageUrl =
          await profileDataProvider.updateStudentProfileImage(image: image);
      return Right(imageUrl);
    } on InvalidAccessTokenException {
      return Left(InvalidAccessTokenFailure());
    } on InvalidRefreshTokenException {
      return Left(InvalidRefreshTokenFailure());
    } on ServerException {
      return Left(ServerFailure());
    } on InvalidImageFormatException {
      return Left(InvalidImageFormatFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateStudentPassword(
      {required String currentPassword, required String newPassword}) async {
    if (!await networkInfo.isConnected()) {
      return Left(NetworkFailure());
    }

    if (AuthInfo.accessTokens == null) {
      return Left(InvalidAccessTokenFailure());
    }

    try {
      await profileDataProvider.updateStudentPassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return const Right(null);
    } on InvalidAccessTokenException {
      return Left(InvalidAccessTokenFailure());
    } on InvalidRefreshTokenException {
      return Left(InvalidRefreshTokenFailure());
    } on ServerException {
      return Left(ServerFailure());
    } on WrongPasswordException {
      return Left(WrongPasswordFailure());
    }
  }
}
