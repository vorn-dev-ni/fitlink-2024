import 'package:demo/common/model/user_model.dart';
import 'package:demo/data/repository/firebase/profile_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firebase/storage_service.dart';
import 'package:demo/data/service/firestore/firestore_service.dart';
import 'package:demo/data/service/firestore/profiles/profile_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'single_user_controller.g.dart';

@Riverpod(keepAlive: true)
class SingleUserController extends _$SingleUserController {
  late FirestoreService firestoreService;
  late StorageService storageService;
  late ProfileRepository profileRepository;
  @override
  Future<AuthModel?> build(String uid) async {
    storageService = StorageService();
    profileRepository = ProfileRepository(
        baseService:
            ProfileService(firebaseAuthService: FirebaseAuthService()));
    firestoreService =
        FirestoreService(firebaseAuthService: FirebaseAuthService());

    return await getData(uid);
  }

  FutureOr<AuthModel?> getData(String? userId) async {
    debugPrint("Geting single user with ${userId}");
    if (FirebaseAuth.instance.currentUser == null) {
      return AuthModel();
    } else {
      AuthModel? authModel = await firestoreService.getEmail(userId);
      debugPrint("Geting result with ${authModel.toString()}");
      return authModel;
    }
  }
}
