import 'package:demo/common/model/user_model.dart';
import 'package:demo/data/repository/firebase/notification_repo.dart';
import 'package:demo/data/repository/firebase/profile_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firebase/storage_service.dart';
import 'package:demo/data/service/firestore/firestore_service.dart';
import 'package:demo/data/service/firestore/notification/notification_service.dart';
import 'package:demo/data/service/firestore/profiles/profile_service.dart';
import 'package:demo/features/home/views/single_profile/controller/media_tag_conroller.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'single_user_controller.g.dart';

@Riverpod(keepAlive: true)
class SingleUserController extends _$SingleUserController {
  late FirestoreService firestoreService;
  late NotificationRepo notificationRepo;
  late StorageService storageService;
  late ProfileRepository profileRepository;
  late FirebaseAuthService firebaseAuthService;
  @override
  Future<AuthModel?> build(String uid) async {
    firebaseAuthService = FirebaseAuthService();
    storageService = StorageService();

    profileRepository = ProfileRepository(
        baseService: ProfileService(firebaseAuthService: firebaseAuthService));
    firestoreService =
        FirestoreService(firebaseAuthService: firebaseAuthService);
    notificationRepo = NotificationRepo(
        notificationBaseService: NotificationRemoteService(
            firebaseAuthService: firebaseAuthService));

    return await getData(uid);
  }

  FutureOr<AuthModel?> getData(String? userId) async {
    if (FirebaseAuth.instance.currentUser == null) {
      return AuthModel();
    } else {
      AuthModel? authModel = await firestoreService.getEmail(userId);
      return authModel;
    }
  }

  Future<bool> checkIfuserFollowing(String targetUserId) async {
    try {
      return await profileRepository.checkIsFollowing(targetUserId) ?? false;
    } catch (e) {
      rethrow;
    }
  }

  Future unfollowingUser(String senderId, String receiverID) async {
    try {
      if (FirebaseAuth.instance.currentUser?.uid != null) {
        await profileRepository.unfollowingUser(receiverID);
        ref.invalidate(mediaTagConrollerProvider);
        // await notificationRepo.sentFollowingNotification(
        //     senderID: senderId, receiverID: receiverID, userId: senderId);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: AppColors.errorColor,
          textColor: Colors.white,
          fontSize: 16.0);
      rethrow;
    }
  }

  Future followingUser(String senderId, String receiverID) async {
    try {
      if (FirebaseAuth.instance.currentUser?.uid != null) {
        await profileRepository.followingUser(receiverID);
        ref.invalidate(mediaTagConrollerProvider);
        await notificationRepo.sentFollowingNotification(
            senderID: senderId, receiverID: receiverID, userId: senderId);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: AppColors.errorColor,
          textColor: Colors.white,
          fontSize: 16.0);
      rethrow;
    }
  }
}
