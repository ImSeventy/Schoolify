import 'package:dartz/dartz.dart';
import 'package:frontend/core/errors/failures.dart';
import 'package:frontend/features/onboarding/domain/repository/onboarding_repository.dart';

import '../data_providers/onboarding_data_provider.dart';

class OnBoardingRepositoryImpl implements OnBoardingRepository {
  OnBoardingDataProvider onBoardingDataProvider;

  OnBoardingRepositoryImpl({required this.onBoardingDataProvider});

  @override
  Either<Failure, bool> getOnBoardingStatus() {
    bool status = onBoardingDataProvider.getOnBoardingStatus();
    return Right(status);
  }

  @override
  Future<Either<Failure, void>> markShown() async {
    await onBoardingDataProvider.markShown();
    return const Right(null);
  }

}