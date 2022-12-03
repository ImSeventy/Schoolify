import 'package:frontend/core/utils/extensions.dart';
import 'package:jwt_decode/jwt_decode.dart';


bool checkTokenIntegrity(String token) {
  Map<String, dynamic> payload = Jwt.parseJwt(token);
  return !_checkIfTokenIsExpired(payload);
}

bool _checkIfTokenIsExpired(Map<String, dynamic> payload) {
  return payload["exp"] - 60 < getCurrentTimeStamp();
}

double getCurrentTimeStamp() {
  return DateTime.now().toUtc().timeStamp;
}