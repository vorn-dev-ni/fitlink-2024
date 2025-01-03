import 'package:demo/utils/exception/app_exception.dart';
import 'package:demo/utils/flavor/config.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> initializeFirebaseApp(
    FirebaseOptions DefaultFirebaseOptions) async {
  try {
    await Firebase.initializeApp(
        name: AppConfig.appConfig.flavor.value,
        options: DefaultFirebaseOptions);
  } catch (e) {
    print('Error initializing Firebase: $e');
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
  print('Error is ${title} ${message}');

  return FirebaseCredentialException(title: title, message: message);
}
