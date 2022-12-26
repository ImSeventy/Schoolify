import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';

abstract class OnBoardingRepository {
  Future<Either<Failure, void>> markShown();
  Future<Either<Failure, bool>> getOnBoardingStatus();
}