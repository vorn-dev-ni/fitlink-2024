import 'package:flutter/material.dart';

class ValidationUtils {
  ValidationUtils._();
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    return emailRegex.hasMatch(email.trim()); // Trim to remove spaces
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

  static bool isValidPassword(
      {required String password, required double length}) {
    if (password.isNotEmpty && password.length < length) {
      return true;
    }
    return false;
  }

  static String? validateEmail(String? value, int maxLength, int minLength) {
    if (value == "" || value == null) {
      return 'Your email address must not be empty';
    }

    if (value.length < minLength) {
      return 'Your email address must be more then ${minLength - 1} characters';
    }
    if (value.length > maxLength - 1) {
      return 'Your email address must be less then ${maxLength} characters';
    }

    if (!isValidEmail(value)) {
      return 'Please provide valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value, int maxLength, int minLength) {
    if (value == "" || value == null) {
      return 'Your password must not be empty';
    }

    if (value.length < minLength) {
      return 'Your password must be more then ${minLength - 1} characters';
    }
    if (value.length > maxLength - 1) {
      return 'Your password must be less then ${maxLength} characters';
    }

    return null;
  }

  static String? validateFirstName(
      String? value, int maxLength, int minLength) {
    if (value == "" || value == null) {
      return 'Your first name must not be empty';
    }

    if (value.length < minLength) {
      return 'Your first name must be more then ${minLength - 1} characters';
    }
    if (value.length > maxLength - 1) {
      return 'Your first name must be less then ${maxLength} characters';
    }

    return null;
  }

  static String? validatelastName(String? value, int maxLength, int minLength) {
    if (value == "" || value == null) {
      return 'Your last name must not be empty';
    }

    if (value.length < minLength) {
      return 'Your last name must be more then ${minLength - 1} characters';
    }
    if (value.length > maxLength - 1) {
      return 'Your last name must be less then ${maxLength} characters';
    }

    return null;
  }

  static String? validateCustomFieldText(
      {String? value,
      required int maxLength,
      required int minLength,
      required String fieldName}) {
    if (value == "" || value == null) {
      return 'Your $fieldName must not be empty';
    }

    if (value.length < minLength) {
      return 'Your $fieldName must be more then ${minLength - 1} characters';
    }
    if (value.length > maxLength - 1) {
      return 'Your $fieldName must be less then $maxLength characters';
    }

    return null;
  }
}
