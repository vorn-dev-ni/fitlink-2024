import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class ReauthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Reauthenticate the current user
  Future<void> reauthenticateUser() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user signed in');

    for (var info in user.providerData) {
      switch (info.providerId) {
        case 'password':
          // Ask user to enter their password
          await _reauthWithEmailPassword(user.email!);
          break;
        case 'google.com':
          await _reauthWithGoogle();
          break;
        case 'facebook.com':
          await _reauthWithFacebook();
          break;
        case 'apple.com':
          await _reauthWithApple();
          break;
      }
    }
  }

  Future<void> _reauthWithEmailPassword(String email) async {
    // TODO: get password from the user securely via a dialog
    final password = await _getPasswordFromUser();
    final credential =
        EmailAuthProvider.credential(email: email, password: password);
    await _auth.currentUser!.reauthenticateWithCredential(credential);
  }

  Future<void> _reauthWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) throw Exception('Google sign-in canceled');
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _auth.currentUser!.reauthenticateWithCredential(credential);
  }

  Future<void> _reauthWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status != LoginStatus.success)
      throw Exception('Facebook login failed');
    final credential =
        FacebookAuthProvider.credential(result.accessToken!.token);
    await _auth.currentUser!.reauthenticateWithCredential(credential);
  }

  Future<void> _reauthWithApple() async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName
      ],
    );
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );
    await _auth.currentUser!.reauthenticateWithCredential(oauthCredential);
  }

  Future<String> _getPasswordFromUser() async {
    // Implement a dialog to ask the user for their password
    // Example:
    return 'user_password_here';
  }
}
