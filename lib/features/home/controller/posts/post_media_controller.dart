import 'dart:io';

import 'package:demo/data/repository/firebase/post_social_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firebase/storage_service.dart';
import 'package:demo/data/service/firestore/posts/social_post_service.dart';
import 'package:demo/features/home/model/post.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'post_media_controller.g.dart';

@Riverpod(keepAlive: false)
class PostMediaController extends _$PostMediaController {
  late PostSocialRepo postSocialRepo;
  late StorageService storageService;

  @override
  Post build() {
    storageService = StorageService();
    postSocialRepo = PostSocialRepo(
        baseSocialMediaService:
            SocialPostService(firebaseAuthService: FirebaseAuthService()));
    return Post(tag: null);
  }

  void updateFeeling({String? feelings, String? emoji}) {
    state = state.copyWith(feeling: feelings, emoji: emoji);
  }

  void updateImageUrl(String? imageUrl) {
    state = state.copyWith(imageUrl: imageUrl);
  }

  void updateText(String? text) {
    state = state.copyWith(caption: text);
  }

  void updateTag(String? tag) {
    state = state.copyWith(tag: tag);
  }

  Future getDownloadUrl(File imageFile) async {
    String extensionWithoutFileExtension =
        HelpersUtils.getLastFileName(imageFile.path);
    final result = await storageService.uploadFile(
        file: imageFile, fileName: extensionWithoutFileExtension);
    return result!['downloadUrl'];
  }

  Future handlePost(File? imageFile) async {
    try {
      if (state.imageUrl != "") {
        if (imageFile != null) {
          final downloadUrl = await getDownloadUrl(imageFile);
          if (state.imageUrl != null &&
              state.imageUrl != "" &&
              state.imageUrl!.contains('https://firebasestorage')) {
            final storageReference =
                FirebaseStorage.instance.refFromURL(state.imageUrl!);
            await storageReference.delete();
            state = state.copyWith(imageUrl: downloadUrl);
            debugPrint("File has been delete");
          } else {
            state = state.copyWith(imageUrl: downloadUrl);
          }
        }
      } else {
        if (imageFile != null) {
          String extensionWithoutFileExtension =
              HelpersUtils.getLastFileName(imageFile!.path);
          final result = await storageService.uploadFile(
              file: imageFile, fileName: extensionWithoutFileExtension);
          state = state.copyWith(imageUrl: result!['downloadUrl']);
        }
      }

      if (state.feeling != null) {
        state = state.copyWith(type: 'feeling');
      }
      debugPrint("post is ${state.toJson()}");
      await postSocialRepo.addPost(state);
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 4,
          backgroundColor: AppColors.errorColor,
          textColor: Colors.white,
          fontSize: 16.0);
      rethrow;
    }
  }
}
