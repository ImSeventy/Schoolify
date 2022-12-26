class OnBoardingState {}

class OnBoardingInitialState extends OnBoardingState {}

class OnBoardingMarkShownLoadingState extends OnBoardingState {}

class OnBoardingMarkShownSuccessState extends OnBoardingState {}

class OnBoardingMarkShownFailureState extends OnBoardingState {
  final String message;

  OnBoardingMarkShownFailureState({required this.message});
}