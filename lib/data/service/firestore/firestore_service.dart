// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/common/model/user_model.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/exception/app_exception.dart';
import 'package:demo/utils/firebase/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late FirebaseAuthService firebaseAuthService;
  FirestoreService({
    required this.firebaseAuthService,
  });
  Future<AuthModel?> addUserToFirestore(String fullName, String email,
      {String? authprovider = 'password', String? socialAvatar = ""}) async {
    final FirebaseAuth? auth = firebaseAuthService.getAuth;
    if (auth != null) {
      try {
        String userId = auth.currentUser!.uid;

        await _firestore.collection('users').doc(userId).set({
          'fullName': fullName,
          'provider': authprovider,
          'email': email,
          'avatar': socialAvatar
        }, SetOptions(merge: true));
        return AuthModel(
            fullname: fullName, email: email, avatar: socialAvatar ?? "");
      } on FirebaseException catch (e) {
        throw handleFirebaseErrorResponse(e);
      }
    } else {
      debugPrint('FirebaseAuth is not initialized.');
      throw UnknownException(
          message: "OOps", title: "'FirebaseAuth is not initialized.");
    }
  }

  Stream<Map<String, dynamic>?> getUserRoleRealTime() {
    final FirebaseAuth? auth = firebaseAuthService.getAuth;
    final snapshot =
        _firestore.collection('users').doc(auth!.currentUser!.uid).snapshots();

    return snapshot.map(
      (docSnapShot) {
        return docSnapShot.data();
      },
    );
  }

  Future<AuthModel> getEmail(String uid) async {
    final FirebaseAuth? auth = firebaseAuthService.getAuth;
    if (auth != null) {
      try {
        DocumentSnapshot snapshot =
            await _firestore.collection('users').doc(uid).get();

        if (snapshot.exists) {
          String email = snapshot['email'];
          String fullname = snapshot['fullName'];
          String avatar = snapshot['avatar'];
          String role = snapshot['role'];

          return AuthModel(
              fullname: fullname,
              email: email,
              avatar: avatar,
              userRoles: role.isEmpty
                  ? UserRoles.GUEST
                  : role == 'admin'
                      ? UserRoles.ADMIN
                      : role == 'normal'
                          ? UserRoles.NORMAL
                          : UserRoles.GYM_OWNER);
        } else {
          throw Exception("User not found in Firestore.");
        }
      } on FirebaseException catch (e) {
        // Handle Firestore specific errors
        throw handleFirebaseErrorResponse(e);
      }
    } else {
      debugPrint('FirebaseAuth is not initialized.');
      throw UnknownException(
          message: "Oops", title: "'FirebaseAuth is not initialized.");
    }
  }
}
