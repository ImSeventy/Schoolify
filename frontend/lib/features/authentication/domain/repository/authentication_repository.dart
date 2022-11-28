import 'package:dartz/dartz.dart';
import 'package:frontend/core/errors/failures.dart';
import 'package:frontend/features/authentication/domain/entities/student_entity.dart';

import '../entities/tokens_entity.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, TokensEntity>> login({required String email, required String password});

  Future<Either<Failure, StudentEntity>> getCurrentStudent();
}