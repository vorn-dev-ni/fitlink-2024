// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/base_service.dart';
import 'package:flutter/material.dart';

class ProfileService implements BaseUserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late FirebaseAuthService firebaseAuthService;
  ProfileService({
    required this.firebaseAuthService,
  });

  @override
  Future updateCoverImage(Map<String, dynamic> data) async {
    try {
      final docId = _firestore
          .collection('users')
          .doc(firebaseAuthService.currentUser!.uid);
      await docId.set(data, SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future updateProfile(Map<String, dynamic> data) async {
    try {
      final docId = _firestore
          .collection('users')
          .doc(firebaseAuthService.currentUser!.uid);
      await docId.update(data);
    } catch (e) {
      rethrow;
    }
  }
}
