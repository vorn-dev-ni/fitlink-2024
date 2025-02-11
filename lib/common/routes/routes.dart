import 'package:demo/common/model/route_app.dart';
import 'package:demo/common/model/screen_app.dart';
import 'package:demo/features/authentication/auth.dart';
import 'package:demo/features/authentication/views/forget_password/forget_password.dart';
import 'package:demo/features/authentication/views/forget_password/forget_password_success.dart';
import 'package:demo/features/authentication/views/login/email_verify.dart';
import 'package:demo/features/authentication/views/login/phone_verify.dart';
import 'package:demo/features/authentication/views/register/register.dart';
import 'package:demo/features/home/my_home.dart';
import 'package:demo/features/home/views/daily_workout/main_workout.dart';
import 'package:demo/features/home/views/daily_workout/views/excercise_activities_form.dart';
import 'package:demo/features/home/views/daily_workout/views/excercise_detail.dart';
import 'package:demo/features/home/views/daily_workout/views/excercise_overview.dart';
import 'package:demo/features/home/views/main/event/event_detail/event_detail.dart';
import 'package:demo/features/home/views/main/event/event_post/event_post.dart';
import 'package:demo/features/home/views/main/event/event_submission/event_form_submit.dart';
import 'package:demo/features/home/views/main/event/event_submission/event_success.dart';
import 'package:demo/features/home/views/profile/preview/preview_image.dart';
import 'package:demo/features/home/views/profile/edit_profile/edit_profile.dart';
import 'package:demo/features/on_boarding/on_boarding.dart';
import 'package:demo/features/other/no_internet.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  AppRoutes._();

  static final List<RoutesApp> mainStacks = [
    RoutesApp(
        routeName: AppPage.excerciseActivitiesForm,
        builder: (context) => ExcerciseActivitiesForm()),
    RoutesApp(
        routeName: AppPage.excerciseDetail,
        builder: (context) => ExcerciseDetail()),
    RoutesApp(
        routeName: AppPage.excercise,
        builder: (context) => ExcerciseOverviewScreen()),
    RoutesApp(
        routeName: AppPage.workout,
        builder: (context) => const MainWorkoutScreen()),
    RoutesApp(
        routeName: AppPage.eventSuccess,
        builder: (context) => const EventSubmissSuccess()),
    RoutesApp(
        routeName: AppPage.editProfile,
        builder: (context) => const EditProfile()),
    RoutesApp(
        routeName: AppPage.previewImage,
        builder: (context) => const PreviewImage()),
    RoutesApp(
        routeName: AppPage.eventRequestGymTrainer,
        builder: (context) => const EventFormSubmission()),
    RoutesApp(
        routeName: AppPage.eventCreate,
        builder: (context) => const EventPosting()),
    RoutesApp(
        routeName: AppPage.eventDetail,
        builder: (context) => const EventDetail()),
    RoutesApp(
        routeName: AppPage.forgetpasswordSuccess,
        builder: (context) => const ForgetPasswordSuccess()),
    RoutesApp(
        routeName: AppPage.otpVerify,
        builder: (context) => const PhoneOtpVerify()),
    RoutesApp(
        routeName: AppPage.emailSuccess,
        builder: (context) => const EmailVerifyConfimration()),
    RoutesApp(
        routeName: AppPage.forgetpassword,
        builder: (context) => const ForgetPassword()),
    RoutesApp(
        routeName: AppPage.auth, builder: (context) => const AuthScreen()),
    RoutesApp(
        routeName: AppPage.register,
        builder: (context) => const RegisterScreen()),
    RoutesApp(
        routeName: AppPage.onBoarding,
        builder: (context) => const OnBoardingScreen()),
    RoutesApp(
        routeName: AppPage.home, builder: (context) => const MyHomeScreen()),
    RoutesApp(
        routeName: AppPage.NO_INTERNET,
        builder: (context) => const NoInternet()),
  ];
  static final List<ScreenApp> navigationStacks = [];

  static Map<String, WidgetBuilder> getAppRoutes() {
    Map<String, WidgetBuilder> routeMap = Map.fromEntries(
      AppRoutes.mainStacks.map((e) => MapEntry(e.routeName, e.builder)),
    );

    return routeMap;
  }
}
