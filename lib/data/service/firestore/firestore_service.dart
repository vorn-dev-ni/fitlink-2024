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
  FirebaseFirestore get firestore => _firestore;

  Stream<AuthModel?> getUserStream(String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        final data = AuthModel.fromFirestore(snapshot);
        return data;
      } else {
        return null;
      }
    });
  }

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
          'role': 'normal',
          'bio': '',
          'cover_feature': '',
          'createdAt': Timestamp.now(),
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

  Future checkUserRole() async {
    final FirebaseAuth? auth = firebaseAuthService.getAuth;

    if (auth?.currentUser == null) {
      return null;
    }
    final snapshot =
        await _firestore.collection('users').doc(auth!.currentUser!.uid).get();
    if (snapshot.exists) {
      final result = snapshot.data() as Map<String, dynamic>;
      return result['role'] ?? "normal";
    }
    return null;
  }

  Future<AuthModel> getEmail(String? uid) async {
    // final User? currentUser = FirebaseAuth.instance.currentUser;

    if (uid != null) {
      try {
        DocumentSnapshot snapshot =
            await _firestore.collection('users').doc(uid).get();

        if (snapshot.data() == null) {
          return AuthModel();
        }
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        if (data.isNotEmpty) {
          String email = data['email'] ?? "";
          String fullname = data['fullName'] ?? "";
          String avatar = data['avatar'] ?? "";
          String role = data['role'] ?? "";
          String bio = data['bio'] ?? "";
          String cover_image = data['cover_feature'] ?? '';

          return AuthModel(
              fullname: fullname,
              email: email,
              avatar: avatar,
              bio: bio,
              cover_feature: cover_image,
              userRoles: role.isEmpty
                  ? UserRoles.GUEST
                  : role == 'admin'
                      ? UserRoles.ADMIN
                      : role == 'normal'
                          ? UserRoles.NORMAL
                          : UserRoles.GYM_OWNER);
        } else {
          // throw Exception("User not found in Firestore.");
          return AuthModel();
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

  Future<AuthModel> getAvatar(String uid) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(uid).get();
      if (!snapshot.exists) {
        return AuthModel();
      }
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      if (data.isNotEmpty) {
        String avatar = snapshot.get('avatar') ?? '';

        return AuthModel(avatar: avatar);
      } else {
        // throw Exception("User not found in Firestore.");
        return AuthModel();
      }
    } on FirebaseException catch (e) {
      // Handle Firestore specific errors
      throw handleFirebaseErrorResponse(e);
    }
  }
}
