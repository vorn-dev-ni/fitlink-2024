import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/data/repository/firebase/auth_login_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/features/authentication/controller/otp_controller.dart';
import 'package:demo/features/authentication/model/auth_user.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/validation/login_validation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'login_controller.g.dart';

@Riverpod(keepAlive: true)
class LoginController extends _$LoginController {
  @override
  AuthUser build() {
    return AuthUser();
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updatePassword(String email) {
    state = state.copyWith(password: email);
  }

  void updatePhoneNumber(String phoneNumber) {
    debugPrint(phoneNumber);
    state = state.copyWith(phoneNumber: phoneNumber);
  }

  bool checkLoginPhoneState() {
    debugPrint('Phone number ${state.phoneNumber}');
    if (state.phoneNumber == null) {
      return false;
    }
    bool isEmailPhoneValid =
        ValidationUtils.isPhoneNumberValidRegex(state.phoneNumber);
    if (!isEmailPhoneValid) {
      return isEmailPhoneValid;
    }
    return true;
  }

  Future sendCodeSignInPhone({
    required Function onSuccessOtp,
    required String verificationId,
  }) async {
    try {
      final smsCode = ref.watch(otpControlelrProvider);

      debugPrint('Sms code is ${smsCode}');
      final authRepository =
          AuthLoginRepository(firebaseAuthService: FirebaseAuthService());
      await authRepository.loginPhoneNumber(
          onSuccessOtp: onSuccessOtp,
          verificationId: verificationId,
          smsCode: smsCode);
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: AppColors.errorColor,
          textColor: Colors.white,
          fontSize: 16.0);
      rethrow;
    }
  }

  Future sendPhoneOtp(
      {required void Function(String verificationId, int? resendToken)
          onSuccessVerification}) async {
    try {
      // await _authLoginRepository.loginUserWithPhoneNumber(state.);
      debugPrint('sendPhoneOtp completed:');

      final authRepository =
          AuthLoginRepository(firebaseAuthService: FirebaseAuthService());
      authRepository.sendPhoneOtp(
        state.phoneNumber!,
        verificationCompleted: (PhoneAuthCredential credential) {
          debugPrint('Verification completed: $credential');
        },
        verificationFailed: (FirebaseAuthException e) {
          String message = e.message ?? "";
          debugPrint('Verification failed: ${e.code}');
          if (e.code == 'invalid-phone-number') {
            debugPrint('The provided phone number is not valid.');
            message = "The provided phone number is not valid.";
          }
          if (e.code == 'web-context-cancelled') {
            message = 'User has cancelled';
          }
          if (e.code == 'too-many-requests') {
            message =
                'Please one more time !!! please wait 1 minutes before you can retry again';
          }
          debugPrint('Error code is completed: ${e.toString()}');
          Fluttertoast.showToast(
              msg: message.toString(),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 5,
              backgroundColor: AppColors.errorColor,
              textColor: Colors.white,
              fontSize: 16.0);
          ref.read(appLoadingStateProvider.notifier).setState(false);
        },
        codeSent: (String verificationId, int? resendToken) {
          debugPrint('Code sent: $verificationId');
          onSuccessVerification(verificationId, resendToken);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          debugPrint('Code auto-retrieval timeout: $verificationId');
        },
      );
      debugPrint("sendPhoneOtp  successfully");
    } catch (e) {
      rethrow;
    }
  }

  bool checkLoginEmailState() {
    debugPrint('Email ${state.email} Password ${state.password}');
    if (state.email == null || state.password == null) {
      Fluttertoast.showToast(
          msg: 'Email or password  must not be empty !!!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: AppColors.errorColor,
          textColor: Colors.white,
          fontSize: 16.0);

      return false;
    }

    bool isEmailPasswordValid = ValidationUtils.isPasswordEmptyOrLessThen(
            password: state.password ?? "", length: 12) &&
        ValidationUtils.isValidEmail(state.email!);
    if (!isEmailPasswordValid) {
      Fluttertoast.showToast(
          msg: 'Email or password  must not be empty !!!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: AppColors.errorColor,
          textColor: Colors.white,
          fontSize: 16.0);
      return isEmailPasswordValid;
    }
    return true;
  }
}
