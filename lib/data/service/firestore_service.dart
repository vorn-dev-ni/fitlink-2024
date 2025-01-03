// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/common/model/user_model.dart';
import 'package:demo/data/service/firebase_service.dart';
import 'package:demo/utils/exception/app_exception.dart';
import 'package:demo/utils/firebase/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late FirebaseAuthService firebaseAuthService;
  FirestoreService({
    required this.firebaseAuthService,
  });
  Future<AuthModel?> addUserToFirestore(String fullName, String email) async {
    final FirebaseAuth? auth = firebaseAuthService?.getAuth;
    if (auth != null) {
      try {
        String userId = auth.currentUser!.uid;

        await _firestore.collection('users').doc(userId).set({
          'fullName': fullName,
          'email': email,
        }, SetOptions(merge: true));
        return AuthModel(fullname: fullName, email: email);
      } on FirebaseException catch (e) {
        throw handleFirebaseErrorResponse(e);
      }
    } else {
      print('FirebaseAuth is not initialized.');
      throw UnknownException(
          message: "OOps", title: "'FirebaseAuth is not initialized.");
    }
  }

  Future<AuthModel> getEmail(String uid) async {
    final FirebaseAuth? auth = firebaseAuthService?.getAuth;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    if (auth != null) {
      try {
        String userId = auth.currentUser!.uid;

        DocumentSnapshot snapshot =
            await _firestore.collection('users').doc(uid).get();

        if (snapshot.exists) {
          String email = snapshot['email'];
          String fullname = snapshot['fullName'];

          print('User email: $email, Fullname: $fullname');

          return AuthModel(fullname: fullname, email: email);
        } else {
          throw Exception("User not found in Firestore.");
        }
      } on FirebaseException catch (e) {
        // Handle Firestore specific errors
        throw handleFirebaseErrorResponse(e);
      }
    } else {
      print('FirebaseAuth is not initialized.');
      throw UnknownException(
          message: "Oops", title: "'FirebaseAuth is not initialized.");
    }
  }
}
