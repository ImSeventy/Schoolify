import 'package:frontend/features/authentication/domain/entities/tokens_entity.dart';

class TokensModel extends TokensEntity {
  TokensModel({
    required super.accessToken,
    required super.refreshToken,
  });

  factory TokensModel.fromJson(Map<String, dynamic> json) {
    return TokensModel(
      accessToken: json["access_token"],
      refreshToken: json["refresh_token"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "access_token": accessToken,
      "refresh_token": refreshToken
    };
  }
}
