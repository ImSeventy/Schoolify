import 'package:dartz/dartz.dart';
import 'package:frontend/core/errors/failures.dart';
import 'package:frontend/core/use_cases/use_case.dart';
import 'package:frontend/features/onboarding/domain/repository/onboarding_repository.dart';

class GetOnBoardingStatus {
  final OnBoardingRepository onBoardingRepository;

  GetOnBoardingStatus({required this.onBoardingRepository});

  Either<Failure, bool> call(NoParams params) {
    return onBoardingRepository.getOnBoardingStatus();
  }
}
