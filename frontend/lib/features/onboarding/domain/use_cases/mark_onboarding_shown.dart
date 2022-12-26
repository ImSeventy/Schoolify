import 'package:dartz/dartz.dart';
import 'package:frontend/core/errors/failures.dart';
import 'package:frontend/core/use_cases/use_case.dart';

import '../repository/onboarding_repository.dart';

class MarkOnBoardingShownUseCase extends UseCase<void, NoParams> {
  final OnBoardingRepository onBoardingRepository;

  MarkOnBoardingShownUseCase({required this.onBoardingRepository});
  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return onBoardingRepository.markShown();
  }

}