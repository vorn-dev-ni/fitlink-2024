import 'package:demo/data/service/utils/notification_service.dart';
import 'package:demo/utils/exception/app_exception.dart';
import 'package:demo/utils/flavor/config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

Future<void> initializeFirebaseApp(
    FirebaseOptions DefaultFirebaseOptions) async {
  try {
    await Firebase.initializeApp(
        name: AppConfig.appConfig.flavor.value,
        options: DefaultFirebaseOptions);
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await Future.delayed(const Duration(milliseconds: 200));
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity,
      appleProvider: AppleProvider.appAttest,
    );
  } catch (e) {
    debugPrint('Error initializing Firebase: $e');
  }
}

AppException handleFirebaseErrorResponse(FirebaseException exception) {
  var title;
  var message;

  switch (exception.code) {
    case 'weak-password':
      title = 'Weak Password';
      message = 'The password provided is too weak.';
      break;
    case 'email-already-in-use':
      title = 'Email Already in Use';
      message = 'The account already exists for that email.';
      break;
    case 'invalid-email':
      title = 'Invalid Email';
      message = 'The email address is not valid.';
      break;
    case 'user-not-found':
      title = 'User Not Found';
      message = 'No user found for the provided email.';
      break;
    case 'wrong-password':
      title = 'Wrong Password';
      message = 'The password is incorrect.';
      break;
    case 'too-many-requests':
      title = 'Too Many Requests';
      message =
          'Access to this account has been temporarily disabled due to too many failed login attempts.';
      break;
    case 'network-request-failed':
      title = 'Network Error';
      message = 'A network error occurred. Please check your connection.';
      break;
    default:
      title = 'Authentication Error';
      message = 'An unknown error occurred. Please try again.';

      break;
  }
  debugPrint('Error is ${title} ${message}');

  return FirebaseCredentialException(title: title, message: message);
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint(
      "---------------------On Background Message when app is killed or in background mode --------------------");
  debugPrint("Message data: ${message.data}");
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  } // You can access message.notification, message.data, etc.
  if (message.notification != null) {
    debugPrint('Notification Title: ${message.notification!.title}');
    debugPrint('Notification Body: ${message.notification!.body}');
    String title = message.notification!.title!;
    String body = message.notification!.body!;

    await NotificationService()
        .showNotification(id: 100, title: title, body: body);
  }
}
