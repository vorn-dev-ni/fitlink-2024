import 'package:demo/data/service/remote/delete_acc_service.dart';
import 'package:demo/network/dio/api_client.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_deletion_controller.g.dart';

/// Provide a single instance of ApiClient

@Riverpod(keepAlive: true)
class UserDeletionController extends _$UserDeletionController {
  late final DeleteAccService userService;

  @override
  void build() {
    userService = DeleteAccService();
  }

  Future<void> deleteUser({
    required String userId,
  }) async {
    try {
      await userService.deleteAccount(userId: userId);
      debugPrint('User deleted: $userId');
      Fluttertoast.showToast(
          msg: "Your account has been successfully deleted.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.secondaryColor,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      debugPrint('Error deleting user: $e');
      // Fluttertoast.showToast(
      //     msg: e.toString(),
      //     toastLength: Toast.LENGTH_LONG,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: AppColors.errorColor,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
    }
  }
}
