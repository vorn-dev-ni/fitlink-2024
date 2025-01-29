import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleService {
  late final GoogleSignIn _googleIOS;
  List<String> scopes = <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ];

  GoogleService() {
    _googleIOS = GoogleSignIn();
  }
  Future<GoogleSignInAccount?> signIngoogleIos({List<String>? scopes}) async {
    final GoogleSignInAccount? googleSignIn = await _googleIOS.signIn();
    return googleSignIn;
  }

  Future logout() async {
    try {
      await _googleIOS.signOut();
      debugPrint("IOS Google has sign out successfully");
    } catch (e) {
      rethrow;
    }
  }

  Future signInGoogleAndroid({List<String>? scopes}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    return googleSignIn;
  }
}
