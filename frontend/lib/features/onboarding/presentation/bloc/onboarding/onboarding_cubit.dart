import 'package:bloc/bloc.dart';
import 'package:frontend/features/onboarding/presentation/bloc/onboarding/onboarding_states.dart';

import '../../../../../core/use_cases/use_case.dart';
import '../../../domain/use_cases/mark_onboarding_shown.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  final MarkOnBoardingShownUseCase markOnBoardingShownUseCase;
  OnBoardingCubit({required this.markOnBoardingShownUseCase}) : super(OnBoardingInitialState());

  void markShown() async {
    emit(OnBoardingMarkShownLoadingState());

    final response = await markOnBoardingShownUseCase(NoParams());

    response.fold(
      (failure) => emit(OnBoardingMarkShownFailureState(message: failure.message)),
      (success) => emit(OnBoardingMarkShownSuccessState())
    );
  }
}