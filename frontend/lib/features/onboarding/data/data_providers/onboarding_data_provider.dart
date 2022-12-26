import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/constants.dart';

abstract class OnBoardingDataProvider {
  Future<void> markShown();
  bool getOnBoardingStatus();
}


class OnBoardingDataProviderImpl implements OnBoardingDataProvider {
  final SharedPreferences sharedPreferences;

  OnBoardingDataProviderImpl({required this.sharedPreferences});

  @override
  bool getOnBoardingStatus() {
    return sharedPreferences.getBool(onBoardingShownKey) ?? false;
  }

  @override
  Future<void> markShown() async {
    await sharedPreferences.setBool(onBoardingShownKey, true);
  }
}