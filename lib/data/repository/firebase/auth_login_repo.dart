// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:demo/common/model/user_model.dart';
import 'package:demo/data/repository/firebase_auth_repo.dart';
import 'package:demo/data/service/firestore/notification/notification_service.dart';
import 'package:demo/data/service/social/facebook_service.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/firestore_service.dart';
import 'package:demo/data/service/social/google_service.dart';
import 'package:demo/features/authentication/model/auth_user.dart';
import 'package:demo/utils/exception/app_exception.dart';
import 'package:demo/utils/local_storage/local_storage_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthLoginRepository extends FirebaseAuthRepository {
  late final FirebaseAuthService firebaseAuthService;
  late final FirestoreService firestoreService;
  late final GoogleService googleService;
  late final FacebookService facebookService;
  late final NotificationRemoteService notificationRemoteService;
  AuthLoginRepository({
    required this.firebaseAuthService,
  }) {
    firestoreService =
        FirestoreService(firebaseAuthService: firebaseAuthService);
    googleService = GoogleService();
    facebookService = FacebookService();
    notificationRemoteService =
        NotificationRemoteService(firebaseAuthService: firebaseAuthService);
  }

  @override
  Future<AuthModel?> loginUserEmailPassword(AuthUser auth) async {
    try {
      User? user = await firebaseAuthService.signInWithEmailAndPassword(
          email: auth.email!, password: auth.password!);
      if (user != null && user.emailVerified) {
        await firebaseAuthService.reloadUser();

        debugPrint("Calling email ${FirebaseAuth.instance.currentUser!.uid}");
        final authModel = await firestoreService
            .getEmail(FirebaseAuth.instance.currentUser!.uid);
        Fluttertoast.showToast(
            msg: 'Welcome back ${authModel.fullname ?? ""} 😘',
            timeInSecForIosWeb: 4,
            toastLength: Toast.LENGTH_LONG);
        await LocalStorageUtils().setKeyString('email', user.email!);
        return authModel;
      } else {
        throw AppException(
            title: 'Unauthorized',
            message: 'Invalid credential user login !!!');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future loginUserWithFacebook() async {
    try {
      final facebookResult = await facebookService.loginFacebook();

      if (facebookResult.accessToken?.token != null) {
        final OAuthCredential facebookCrediential =
            FacebookAuthProvider.credential(facebookResult.accessToken!.token);
        // debugPrint("facebookCrediential ${facebookCrediential}");
        UserCredential? userCredential = await firebaseAuthService.getAuth
            ?.signInWithCredential(facebookCrediential);
        await firebaseAuthService.reloadUser();
        if (userCredential != null) {
          AuthModel? userDoc =
              await firestoreService.getEmail(userCredential.user!.uid);
          if (userDoc.fullname == null || userDoc.fullname == "") {
            Fluttertoast.showToast(
                msg: 'Welcome back ${userCredential.user!.displayName} 😘',
                timeInSecForIosWeb: 4,
                toastLength: Toast.LENGTH_LONG);
            await firebaseAuthService.currentUser!
                .updateDisplayName(userCredential.user!.displayName);
            await firestoreService.addUserToFirestore(
                userCredential.user!.displayName!, userCredential.user!.email!,
                authprovider: 'facebook',
                socialAvatar: userCredential.user!.photoURL ?? "");
          } else {
            Fluttertoast.showToast(
                msg: 'Welcome back ${userDoc.fullname} 😘',
                timeInSecForIosWeb: 4,
                toastLength: Toast.LENGTH_LONG);
            await firebaseAuthService.currentUser!
                .updateDisplayName(userDoc.fullname);
          }

          return userDoc;
        } else {
          throw FirebaseCredentialException(
              title: 'Oops', message: 'Facebook invalid crediential !!!');
        }
      } else {
        // User cancel
        return null;
      }
    } catch (e) {
      debugPrint("Error is  ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future sendPhoneOtp(
    String phoneNumber, {
    required Function(PhoneAuthCredential) verificationCompleted,
    required Function(FirebaseAuthException) verificationFailed,
    required Function(String, int?) codeSent,
    required Function(String) codeAutoRetrievalTimeout,
  }) async {
    await firebaseAuthService.signInWithPhone(phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  @override
  Future logoutUser() async {
    if (firebaseAuthService.currentUser != null) {
      await notificationRemoteService
          .removeFcmToken(firebaseAuthService.currentUser!.uid);
    }
    await firebaseAuthService.signOut();
    await firebaseAuthService.currentUser?.reload();
    await googleService.logout();
    await facebookService.logoutFacebook();
  }

  @override
  Future registerUserWithEmailPassword(AuthUser auth) async {
    try {
      UserCredential? user = await firebaseAuthService.createUser(
          email: auth.email!, password: auth.password!);
      await firebaseAuthService.reloadUser();
      if (user != null) {
        await firebaseAuthService.currentUser!.sendEmailVerification();
        await firestoreService.addUserToFirestore(
            "${auth.firstName!} ${auth.lastname!}", auth.email!);
        await firebaseAuthService.currentUser!.updateDisplayName(auth.fullname);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future resendEmail() async {
    // await firebaseAuthService.currentUser?.reload();

    debugPrint("Curr user is ${firebaseAuthService.currentUser}");
    if (firebaseAuthService.currentUser?.emailVerified == false &&
        firebaseAuthService.currentUser != null) {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
    } else {
      debugPrint(
          "Resend email failed ${firebaseAuthService.currentUser?.email}");
    }
  }

  @override
  Future loginUserWithIOSAndroidGoogle() async {
    try {
      GoogleSignInAccount? googleSignInAccount =
          await googleService.signIngoogleIos(); // For popup google native

      if (googleSignInAccount == null) {
        debugPrint("User has cancelled");
        return null;
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);

      UserCredential? userCredential =
          await firebaseAuthService.getAuth!.signInWithCredential(credential);
      await firebaseAuthService.reloadUser();

      AuthModel? userDoc =
          await firestoreService.getEmail(userCredential.user!.uid);

      if (userDoc.fullname == null || userDoc.fullname == "") {
        Fluttertoast.showToast(
            msg:
                'Welcome back ${userCredential.user?.displayName ?? "Annouymouse User"} 😘',
            timeInSecForIosWeb: 4,
            toastLength: Toast.LENGTH_LONG);
        await firebaseAuthService.currentUser!.updateDisplayName(
            userCredential.user?.displayName ?? "Annouymouse User");
        await firestoreService.addUserToFirestore(
          userCredential.user?.displayName ?? "Annouymouse User",
          userCredential.user!.email!,
          authprovider: 'google',
          socialAvatar: userCredential.user?.photoURL ?? "",
        );
      } else {
        debugPrint("User already exists in Firestore.");
        Fluttertoast.showToast(
            msg: 'Welcome back ${userDoc.fullname} 😘',
            timeInSecForIosWeb: 4,
            toastLength: Toast.LENGTH_LONG);
        await firebaseAuthService.currentUser!
            .updateDisplayName(userDoc.fullname ?? "Annouymouse User");
      }

      // Update display name if necessary
      if (userCredential.user == null) {
        throw FirebaseCredentialException(
            title: 'Oops', message: 'Invalid credential !!!');
      }
      return userDoc;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  @override
  Future loginPhoneNumber(
      {required Function onSuccessOtp,
      required String verificationId,
      required String smsCode}) async {
    try {
      await firebaseAuthService.signInWithPhoneNumber(
          onSuccessOtp: onSuccessOtp, verificationId, smsCode);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future sendForgetPassword(String email) async {
    try {
      debugPrint("Forget password has sent to email ${email}");
      await firebaseAuthService.getAuth?.sendPasswordResetEmail(email: email);
    } catch (err) {
      // throw Exception(err.toString());
      rethrow;
    }
  }
}
