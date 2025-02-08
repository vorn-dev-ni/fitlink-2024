import 'package:flutter/material.dart';

class FirebaseAuthMessage {
  FirebaseAuthMessage._();
  static String getMessage(errorCode) {
    debugPrint("FirebaseAuthMessage code ${errorCode}");
    switch (errorCode) {
      case 'invalid-credential':
        return "Please check your email and password, and try again.";
      case 'user-not-found':
        return "No user found with this email.";
      case 'invalid-email':
        return "An Email is either badly format or wrong";
      case 'wrong-password':
        return "Incorrect password. Please try again.";
      case 'too-many-requests':
        return "Too many attempts. Try again later.";
      case 'account-exists-with-different-credential':
        return "An account already exists with the same email address but different sign-in credentials";
      default:
        return errorCode.toString();
    }
  }
}
