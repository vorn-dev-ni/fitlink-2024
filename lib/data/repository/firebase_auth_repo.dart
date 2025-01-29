import 'package:demo/features/authentication/model/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class FirebaseAuthRepository<T> {
  Future loginUserWithFacebook();
  Future sendPhoneOtp(
    String phoneNumber, {
    required Function(PhoneAuthCredential) verificationCompleted,
    required Function(FirebaseAuthException) verificationFailed,
    required Function(String, int?) codeSent,
    required Function(String) codeAutoRetrievalTimeout,
  });
  Future sendForgetPassword(String email);

  Future loginPhoneNumber(
      {required Function onSuccessOtp,
      required String verificationId,
      required String smsCode});
  Future loginUserWithIOSAndroidGoogle();
  Future loginUserEmailPassword(AuthUser auth);
  Future registerUserWithEmailPassword(AuthUser auth);
  Future logoutUser();
  Future resendEmail();
}
