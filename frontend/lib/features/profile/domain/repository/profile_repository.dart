import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';

abstract class ProfileRepository {
  Future<Either<Failure, void>> updateStudent({required String email});
  Future<Either<Failure, String>> updateStudentProfileImage(
      {required File image});
  Future<Either<Failure, void>> updateStudentPassword({
    required String currentPassword,
    required String newPassword,
  });
}
