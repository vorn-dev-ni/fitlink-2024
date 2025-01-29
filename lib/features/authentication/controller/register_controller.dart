import 'package:demo/features/authentication/model/auth_user.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/validation/login_validation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'register_controller.g.dart';

@riverpod
class RegisterController extends _$RegisterController {
  @override
  AuthUser build() {
    return AuthUser();
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  void updateFullName(String fullName) {
    state = state.copyWith(fullname: fullName);
  }

  bool checkRegisterState() {
    debugPrint(
        "Check register recevived ${state.email} ${state.password} ${state.fullname}");

    if (state.email == null ||
        state.password == null ||
        state.fullname == null) {
      Fluttertoast.showToast(
          msg: 'Email or password and fullname must not be empty !!!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: AppColors.errorColor,
          textColor: Colors.white,
          fontSize: 16.0);

      return false;
    }
    bool isvalid = ValidationUtils.isPasswordEmptyOrLessThen(
            password: state.password ?? "", length: 12) &&
        ValidationUtils.isValidEmail(state.email!);
    if (!isvalid) {
      Fluttertoast.showToast(
          msg: 'Password and Email must be a valid one',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: AppColors.errorColor,
          textColor: Colors.white,
          fontSize: 16.0);
      return false;
    }
    return true;
  }
}
