import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DeleteAccService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> deleteAccount({required String userId}) async {
    try {
      final docRef = _firebaseFirestore.collection('users').doc(userId);
      final docSnap = await docRef.get();
      if (!docSnap.exists) {
        debugPrint('User not found in Firestore: $userId');
      } else {
        await docRef.delete();
        debugPrint('User document deleted from Firestore: $userId');
      }
      final currentUser = _auth.currentUser;
      if (currentUser != null && currentUser.uid == userId) {
        await currentUser.delete();
        debugPrint('User deleted from Firebase Auth: $userId');
      } else {
        debugPrint(
            'Cannot delete user from Auth: not signed in or mismatched UID');
      }
    } catch (e) {
      debugPrint('Error deleting user: $e');
      rethrow;
    }
  }
}
