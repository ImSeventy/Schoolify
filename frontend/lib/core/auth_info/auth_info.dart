import 'package:frontend/features/authentication/domain/entities/student_entity.dart';
import 'package:frontend/features/authentication/domain/entities/tokens_entity.dart';

class AuthInfo {
  static StudentEntity? currentStudent;
  static TokensEntity? accessTokens;

  static void clear() {
    currentStudent = null;
    accessTokens = null;
  }
}