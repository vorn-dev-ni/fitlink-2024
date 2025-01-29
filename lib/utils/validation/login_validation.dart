import 'package:flutter/material.dart';

class ValidationUtils {
  ValidationUtils._();
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r".+@.+",
    );
    return emailRegex.hasMatch(email);
  }

  static bool isPhoneNumberValidRegex(String? phoneNumber) {
    debugPrint(phoneNumber);
    final phoneRegex = RegExp(r'^\d{7,11}$');
    if (phoneNumber == null) {
      return false;
    }
    return phoneRegex.hasMatch(phoneNumber!);
  }

  static bool isPasswordEmptyOrLessThen(
      {required String password, required double length}) {
    if (password.isNotEmpty && password.length < length) {
      return true;
    }
    return false;
  }
}
