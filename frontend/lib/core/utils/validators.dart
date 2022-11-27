import 'package:frontend/core/constants/constants.dart';

String? emailValidator(String? email) {
  if (email == null || email.isEmpty) return "Please enter your E-mail";

  if (!emailRegex.hasMatch(email)) return "E-mail isn't valid";

  return null;
}

String? passwordValidator(String? password) {
  if (password == null || password.isEmpty) return "Please enter your password";

  return null;
}