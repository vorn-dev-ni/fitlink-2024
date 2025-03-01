import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/data/repository/firebase/auth_login_repo.dart';
import 'package:demo/data/repository/firebase_auth_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/features/authentication/controller/login_controller.dart';
import 'package:demo/features/authentication/controller/register_controller.dart';
import 'package:demo/features/authentication/model/auth_user.dart';
import 'package:demo/features/home/controller/navbar_controller.dart';
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

  Future loginUserWithFacebook() async {
    try {
      return await _authLoginRepository.loginUserWithFacebook();
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
    debugPrint("Cjeck");
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
      final user = await _authLoginRepository.loginUserEmailPassword(auth);
      // ref.invalidate(profileUserControllerProvider(FirebaseA));
      ref
          .read(navbarControllerProvider.notifier)
          .updateProfileTab(user.avatar ?? "");
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
    try {
      await _authLoginRepository.logoutUser();
    } catch (e) {
      rethrow;
    }
    // await FirebaseFirestore.instance.clearPersistence();
  }

  Future loginWithGoogle() async {
    try {
      return await _authLoginRepository.loginUserWithIOSAndroidGoogle();
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
      final isValid = checkValidation();
      if (isValid == false) {
        return;
      }
      await _authLoginRepository.registerUserWithEmailPassword(authUser);
      ref.invalidate(navbarControllerProvider);

      HelpersUtils.navigatorState(ref.context).pushNamed(
        AppPage.emailSuccess,
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
