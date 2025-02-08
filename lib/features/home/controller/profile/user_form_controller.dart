import 'dart:io';
import 'package:demo/data/service/firebase/storage_service.dart';
import 'package:demo/features/authentication/model/profile_request.dart';
import 'package:demo/features/home/controller/navbar_controller.dart';
import 'package:demo/features/home/controller/profile/profile_user_controller.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user_form_controller.g.dart';

@Riverpod(keepAlive: true)
class UserFormController extends _$UserFormController {
  late StorageService storageService;

  @override
  ProfileRequester build() {
    storageService = StorageService();

    return ProfileRequester();
  }

  void updateFirstName({String? firstName}) {
    state = state.copyWith(firstName: firstName);
  }

  void updateLastName({String? lastName}) {
    state = state.copyWith(lastName: lastName);
  }

  void updateBio({String? bio}) {
    state = state.copyWith(bio: bio);
  }

  void updateAvatar({String? avatar}) {
    state = state.copyWith(avatar: avatar);
  }

  Future getDownloadUrl(File imageFile) async {
    String extensionWithoutFileExtension =
        HelpersUtils.getLastFileName(imageFile.path);
    final result = await storageService.uploadFile(
        file: imageFile, fileName: extensionWithoutFileExtension);
    return result!['downloadUrl'];
  }

  Future updateUserProfile(
    File? imageFile,
  ) async {
    try {
      if (imageFile != null) {
        final downloadUrl = await getDownloadUrl(imageFile);
        if (state.avatar != null &&
            state.avatar != "" &&
            state.avatar!.contains('https://firebasestorage')) {
          final storageReference =
              FirebaseStorage.instance.refFromURL(state.avatar!);
          debugPrint("File has been delete ${storageReference}");
          await storageReference.delete();
          state = state.copyWith(avatar: downloadUrl);
          debugPrint("File has been delete");

          // return;
        } else {
          state = state.copyWith(avatar: downloadUrl);
        }
      }
      ref.invalidate(navbarControllerProvider);
      ref
          .read(navbarControllerProvider.notifier)
          .updateProfileTab(state.avatar ?? "");

      await ref
          .read(profileUserControllerProvider.notifier)
          .updateUserProfile(state);
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.errorColor,
          textColor: Colors.white,
          fontSize: 16.0);

      rethrow;
    }
  }
}
