import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/data/service/firestore/firestore_service.dart';
import 'package:demo/utils/firebase/firebase.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/local_storage/local_storage_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  FirebaseAuth? get getAuth => _auth;
  Stream<User?> get authStateChanges => _auth.userChanges();

  Future<User?> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } catch (e) {
      debugPrint('Failed with error code: ${e.toString()}');
      rethrow; // Handle specific exceptions in your UI layer
    }
  }

  Future syncUsertoFirestore(String fullName, String email,
      {String? authprovider}) async {
    FirestoreService firestoreService =
        FirestoreService(firebaseAuthService: this);
    firestoreService.addUserToFirestore(fullName, email,
        authprovider: authprovider);
  }

  Future reloadUser() async {
    await _auth.currentUser?.reload();
  }

  Future<void> signInWithPhone(
    String phoneNumber, {
    required Function(PhoneAuthCredential) verificationCompleted,
    required Function(FirebaseAuthException) verificationFailed,
    required Function(String, int?) codeSent,
    required Function(String) codeAutoRetrievalTimeout,
  }) async {
    try {
      debugPrint("iphone is ${phoneNumber}");
      await _auth.verifyPhoneNumber(
        phoneNumber: '+$phoneNumber',
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        timeout: const Duration(seconds: 60),
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } catch (e) {
      debugPrint('Error verifying phone number: $e');
      rethrow;
    }
  }

  Future<void> signInWithPhoneNumber(String verificationId, String smsCode,
      {required Function onSuccessOtp}) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      debugPrint('userCredential.user ${userCredential.user}');
      debugPrint("Login successful");

      if (userCredential.user != null) {
        await LocalStorageUtils()
            .setKeyString('email', userCredential.user!.phoneNumber!);

        String phoneNumber = userCredential.user!.phoneNumber!;
        String uid = userCredential.user!.uid;
        // Check if the user already exists in Firestore
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();

        if (!userDoc.exists) {
          String randomName = "Anonymous Unnamed";
          await syncUsertoFirestore(randomName, phoneNumber,
              authprovider: 'phone');
          debugPrint("User has been registered and synced to Firestore");
        } else {
          debugPrint("User already exists, skipping Firestore sync");
        }

        onSuccessOtp();
      }
    } catch (e) {
      debugPrint('Error signing in with phone number: $e');
      rethrow;
    }
  }

  Future<UserCredential?> createUser({String? email, String? password}) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email ?? "", password: password ?? "");
      if (credential.user != null && password != null) {
        syncUsertoFirestore(credential.user!.email!, password);
      }
      return credential;
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');

      throw handleFirebaseErrorResponse(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    LocalStorageUtils().setKeyString('email', '');
    await _auth.signOut();
    await _auth.currentUser?.reload();
  }
}
