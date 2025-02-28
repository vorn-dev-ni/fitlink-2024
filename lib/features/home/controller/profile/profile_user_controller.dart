import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/common/model/user_model.dart';
import 'package:demo/data/repository/firebase/profile_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firebase/storage_service.dart';
import 'package:demo/data/service/firestore/firestore_service.dart';
import 'package:demo/data/service/firestore/profiles/profile_service.dart';
import 'package:demo/features/authentication/model/profile_request.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'profile_user_controller.g.dart';

@Riverpod(keepAlive: true)
class ProfileUserController extends _$ProfileUserController {
  late FirestoreService firestoreService;
  late StorageService storageService;
  late ProfileRepository profileRepository;
  @override
  Future<AuthModel?> build() async {
    storageService = StorageService();
    profileRepository = ProfileRepository(
        baseService:
            ProfileService(firebaseAuthService: FirebaseAuthService()));
    firestoreService =
        FirestoreService(firebaseAuthService: FirebaseAuthService());

    return await getData(FirebaseAuth.instance.currentUser?.uid);
  }

  FutureOr<AuthModel?> getData(String? userId) async {
    if (FirebaseAuth.instance.currentUser == null) {
      return AuthModel();
    } else {
      AuthModel? authModel = await firestoreService.getEmail(userId);

      return authModel;
    }
  }

  Future getDownloadUrl(File imageFile) async {
    String extensionWithoutFileExtension =
        HelpersUtils.getLastFileName(imageFile.path);
    final result = await storageService.uploadFile(
        file: imageFile, fileName: extensionWithoutFileExtension);
    return result!['downloadUrl'];
  }

  Future updateUserProfile(
    ProfileRequester profileRequester,
  ) async {
    try {
      await profileRepository.updateProfile(profileRequester.toJson());
      debugPrint("User profile has been updated");
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

  Future updateCoverPicture(File imageFile, String? oldImage) async {
    try {
      if (oldImage != null && oldImage != "") {
        debugPrint("atemp to delete");
        final storageReference = FirebaseStorage.instance.refFromURL(oldImage!);
        await storageReference.delete();
      }

      debugPrint("Run here");
      final downloadUrl = await getDownloadUrl(imageFile);
      await profileRepository.updateCoverImage(
          {'cover_feature': downloadUrl, 'updatedAt': Timestamp.now()});
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
