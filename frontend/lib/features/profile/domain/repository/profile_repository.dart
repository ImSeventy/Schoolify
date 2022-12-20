import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';

abstract class ProfileRepository {
  Future<Either<Failure, void>> updateStudent({required String email});
}