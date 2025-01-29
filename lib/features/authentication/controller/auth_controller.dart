import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/core/riverpod/navigation_state.dart';
import 'package:demo/data/repository/firebase/auth_login_repo.dart';
import 'package:demo/data/repository/firebase_auth_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/features/authentication/controller/login_controller.dart';
import 'package:demo/features/authentication/controller/register_controller.dart';
import 'package:demo/features/authentication/model/auth_user.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/firebase_auth_message.dart';
import 'package:demo/utils/exception/app_exception.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthController {
  late FirebaseAuthRepository _authLoginRepository;
  late WidgetRef ref;
  AuthController({
    required this.ref,
  }) {
    _authLoginRepository =
        AuthLoginRepository(firebaseAuthService: FirebaseAuthService());
  }

  Future<void> loginUserWithFacebook() async {
    try {
      await _authLoginRepository.loginUserWithFacebook();
      // debugPrint("Login with facebook successfully");
    } catch (e) {
      String message = e.toString();
      debugPrint("Facebook error is ${e.runtimeType}");
      if (e is FirebaseException) {
        message = FirebaseAuthMessage.getMessage(e.code);
      }
      if (e is FirebaseAuthException) {
        debugPrint("Facebook code is ${e.code}");
        message = FirebaseAuthMessage.getMessage(e.code);
      }
      if (e is AppException) {
        message = e.message;
      }
      throw AppException(title: 'Oops!', message: message);
    }
  }

  Future sendEmailforgetPassword(String email) async {
    try {
      await _authLoginRepository.sendForgetPassword(email);
      debugPrint("Forget password has sent successfully");
    } catch (e) {
      String message = e.toString();
      debugPrint("Forget password error is ${e.runtimeType}");
      if (e is FirebaseException) {
        message = FirebaseAuthMessage.getMessage(e.code);
      }
      if (e is FirebaseAuthException) {
        debugPrint("Forget password e is ${e.code}");
        message = FirebaseAuthMessage.getMessage(e.code);
      }
      if (e is AppException) {
        message = e.message;
      }
      throw AppException(title: 'Oops!', message: message);
    }
  }

  bool checkValidation() {
    return ref.read(registerControllerProvider.notifier).checkRegisterState();
  }

  bool checkLoginValidationEmail() {
    return ref.read(loginControllerProvider.notifier).checkLoginEmailState();
  }

  Future resendEmail() async {
    await _authLoginRepository.resendEmail();
  }

  Future<void> loginUser(AuthUser auth) async {
    try {
      if (!checkLoginValidationEmail()) {
        ref.read(appLoadingStateProvider.notifier).setState(false);

        return;
      }
      await _authLoginRepository.loginUserEmailPassword(auth);
    } catch (e) {
      String message = e.toString();
      if (e is FirebaseException) {
        message = FirebaseAuthMessage.getMessage(e.code);
      }
      if (e is AppException) {
        message = e.message;
      }
      throw AppException(title: 'Oops!', message: message);
    }
  }

  Future<void> logout() async {
    await _authLoginRepository.logoutUser();
    ref.invalidate(navigationStateProvider);
    // await FirebaseFirestore.instance.clearPersistence(); //Will use later
  }

  Future<void> loginWithGoogle() async {
    try {
      await _authLoginRepository.loginUserWithIOSAndroidGoogle();
    } catch (e) {
      String message = e.toString();
      if (e is FirebaseException) {
        message = FirebaseAuthMessage.getMessage(e.code);
      }

      if (e is AppException) {
        message = e.message;
      }
      throw AppException(title: 'Oops!', message: message);
    }
  }

  Future<void> createAccount(AuthUser authUser) async {
    try {
      if (!checkValidation()) {
        return;
      }
      await _authLoginRepository.registerUserWithEmailPassword(authUser);
      HelpersUtils.navigatorState(ref.context).pushNamedAndRemoveUntil(
        AppPage.emailSuccess,
        (route) => false,
      );
    } catch (e) {
      String message = e.toString();
      if (e is FirebaseException) {
        message = FirebaseAuthMessage.getMessage(e.code);
      }
      throw AppException(title: 'Oops!', message: message);
    }
  }
}
