import 'package:demo/data/service/firestore_service.dart';
import 'package:demo/utils/firebase/firebase.dart';
import 'package:demo/utils/local_storage/local_storage_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  FirebaseAuth? get getAuth => _auth;
  Stream<User?> get authStateChanges => _auth.userChanges();

  Future<User?> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      // print("Email is ${email} password ${password}");
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print('Failed with error code: ${e}');

      rethrow; // Handle specific exceptions in your UI layer
    }
  }

  Future syncUsertoFirestore(String fullName, String email) async {
    FirestoreService firestoreService =
        FirestoreService(firebaseAuthService: this);
    firestoreService.addUserToFirestore(fullName, email);

    LocalStorageUtils().setKeyString("fullname", fullName);
    LocalStorageUtils().setKeyString("email", email);
  }

  Future reloadUser() async {
    await _auth.currentUser?.reload();
  }

  Future<UserCredential?> createUser({String? email, String? password}) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email ?? "", password: password ?? "");
      if (credential.user != null && password != null) {
        syncUsertoFirestore(credential!.user!.email!, password);
      }
      return credential;
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');

      throw handleFirebaseErrorResponse(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Register a new user
  // Future<User?> registerWithEmailAndPassword(
  //     {required String email, required String password}) async {
  //   try {
  //     UserCredential userCredential = await _auth
  //         .createUserWithEmailAndPassword(email: email, password: password);
  //     return userCredential.user;
  //   } catch (e) {
  //     rethrow; // Handle specific exceptions in your UI layer
  //   }
  // }

  // // Reset Password (for forgot password scenario)
  // Future<void> resetPassword({required String email}) async {
  //   try {
  //     await _auth.sendPasswordResetEmail(email: email);
  //   } catch (e) {
  //     rethrow; // Handle specific exceptions in your UI layer
  //   }
  // }
}
