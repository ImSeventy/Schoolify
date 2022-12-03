import 'dart:convert';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/features/authentication/data/models/tokens_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TokensDataProvider  {
  TokensModel? getCachedTokens();

  void storeTokensInCache(TokensModel tokensModel);

  void removeTokensStoredInCache();
}


class TokensDataProviderImpl implements TokensDataProvider {
  final SharedPreferences sharedPreferences;

  TokensDataProviderImpl({required this.sharedPreferences});

  @override
  TokensModel? getCachedTokens() {
    String? tokensData = sharedPreferences.getString(tokensInCacheKey);

    if (tokensData != null) {
      return TokensModel.fromJson(jsonDecode(tokensData));
    }
    return null;
  }

  @override
  void removeTokensStoredInCache() async {
    await sharedPreferences.remove(tokensInCacheKey);
  }

  @override
  void storeTokensInCache(TokensModel tokensModel) async {
    await sharedPreferences.setString(tokensInCacheKey, jsonEncode(tokensModel.toJson()));
  }

}