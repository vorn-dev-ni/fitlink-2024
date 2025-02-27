import 'package:demo/features/home/views/upload/upload_tab.dart';

class AppPage {
  AppPage._();
  // ignore: constant_identifier_names
  static const START = '/';

  static const SECOND = 'About';
  static const DEMO = 'Demo';
  static const RESULT = "Result";

  //Onboarding

  static const onBoarding = 'first';

  // Navigation Bar
  static const NAV_WELCOME_HOME = 'NAV_HOME';
  static const NAV_SCAN = "Scan";
  static const NAV_ACCOUNT = "Account";

  //STARTING
  static const auth = 'auth';
  static const LOGIN = 'login';
  static const register = 'register';
  static const forgetpassword = 'ForgetPassword';
  static const emailSuccess = 'EmailVerify';
  static const forgetpasswordSuccess = 'PasswordResetSUccess';

  static const otpVerify = 'OTPVerify';

  //Utils
  static const NOTFOUND = 'NotFound';
  static const NO_INTERNET = 'No internet';

  //HOME
  static const home = 'Welcome';

  //Events

  static const eventDetail = 'EventDetail';
  static const eventCreate = 'EventCreate';
  static const eventRequestGymTrainer = 'EventRequest';
  static const eventSuccess = 'FormSuccess';

  //WorkoutTab
  static const workout = 'WorkoutMain';
  static const excercise = 'ExcerciseOverview';
  static const excerciseDetail = 'ExcerciseDetail';
  static const excerciseActivitiesForm = 'ActivitiesForm';
  static const exerciseSuccess = 'ExcerciseSuccess';

  //Utils

  static const previewImage = 'PreviewImage';

  //User
  static const viewProfile = 'ViewProfile';

  static const editProfile = 'EditProfile';

  //Notification
  static const notificationListing = 'NotificationMain';

  //Upload tab
  static const uploadingTab = 'Upload';

  //Post
  static const createPost = 'PostCreate';
  static const feelingListing = 'FeelingListing';

  //Comment
  static const commentEditing = 'CommentEditing';
  static const commentListings = 'Comments';

  static const NotificationPath = 'NotificationTesting';
}
