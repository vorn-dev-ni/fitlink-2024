import 'package:demo/common/model/route_app.dart';
import 'package:demo/common/model/screen_app.dart';
import 'package:demo/common/widget/video_preview.dart';
import 'package:demo/features/authentication/auth.dart';
import 'package:demo/features/authentication/views/forget_password/forget_password.dart';
import 'package:demo/features/authentication/views/forget_password/forget_password_success.dart';
import 'package:demo/features/authentication/views/login/email_verify.dart';
import 'package:demo/features/authentication/views/login/phone_verify.dart';
import 'package:demo/features/authentication/views/register/register.dart';
import 'package:demo/features/dummy/main_dummy.dart';
import 'package:demo/features/home/my_home.dart';
import 'package:demo/features/home/views/chat_detail/chat_detail_screen.dart';
import 'package:demo/features/home/views/chat_search/chat_search.dart';
import 'package:demo/features/home/views/daily_workout/main_workout.dart';
import 'package:demo/features/home/views/daily_workout/views/excercise_activities_form.dart';
import 'package:demo/features/home/views/daily_workout/views/excercise_detail.dart';
import 'package:demo/features/home/views/daily_workout/views/excercise_overview.dart';
import 'package:demo/features/home/views/daily_workout/views/excercise_success.dart';
import 'package:demo/features/home/views/main/comments/comment_edit.dart';
import 'package:demo/features/home/views/main/comments/comment_main.dart';
import 'package:demo/features/home/views/main/event/event_detail/event_detail.dart';
import 'package:demo/features/home/views/main/event/event_post/event_post.dart';
import 'package:demo/features/home/views/main/event/event_submission/event_form_submit.dart';
import 'package:demo/features/home/views/main/event/event_submission/event_success.dart';
import 'package:demo/features/home/views/main/my_home/feeling_list.dart';
import 'package:demo/features/home/views/main/my_home/upload_media.dart';
import 'package:demo/features/home/views/profile/preview/preview_image.dart';
import 'package:demo/features/home/views/profile/edit_profile/edit_profile.dart';
import 'package:demo/features/home/views/single_profile/views/single_profile.dart';
import 'package:demo/features/home/views/single_video/main_single_video.dart';
import 'package:demo/features/home/views/upload/upload_tab.dart';
import 'package:demo/features/notifications/notification_main.dart';
import 'package:demo/features/on_boarding/on_boarding.dart';
import 'package:demo/features/other/no_internet.dart';
import 'package:demo/features/video_search/search_main.dart';
import 'package:demo/features/video_search/search_result.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  AppRoutes._();

  static final List<RoutesApp> mainStacks = [
    RoutesApp(
        routeName: AppPage.previewVideo,
        builder: (context) => const VideoPreview()),
    RoutesApp(
        routeName: AppPage.singleVideoTiktok,
        builder: (context) => const MainSingleVideo()),
    RoutesApp(
        routeName: AppPage.searchResult,
        builder: (context) => const SearchResultScreen()),
    RoutesApp(
        routeName: AppPage.searchTikTok,
        builder: (context) => const SearchScreen()),
    RoutesApp(
        routeName: AppPage.ChatSearching,
        builder: (context) => const ChatSearchScreen()),
    RoutesApp(
        routeName: AppPage.ChatDetails,
        builder: (context) => const ChatDetailScreen()),
    RoutesApp(
        routeName: AppPage.viewProfile, builder: (context) => SingleProfile()),
    RoutesApp(
        routeName: AppPage.NotificationPath,
        builder: (context) => const DummyScreenTest()),
    RoutesApp(
        routeName: AppPage.commentEditing,
        builder: (context) => const CommentEdit()),
    RoutesApp(
        routeName: AppPage.feelingListing,
        builder: (context) => const FeelingListScreen()),
    RoutesApp(
        routeName: AppPage.createPost,
        builder: (context) => const UploadMediaPost()),
    RoutesApp(
        routeName: AppPage.commentListings,
        builder: (context) => const CommentMain()),
    RoutesApp(
        routeName: AppPage.notificationListing,
        builder: (context) => const NotificationMain()),
    RoutesApp(
        routeName: AppPage.uploadingTab,
        builder: (context) => const UploadTab()),
    RoutesApp(
        routeName: AppPage.exerciseSuccess,
        builder: (context) => const ExcerciseSuccess()),
    RoutesApp(
        routeName: AppPage.excerciseActivitiesForm,
        builder: (context) => const ExcerciseActivitiesForm()),
    RoutesApp(
        routeName: AppPage.excerciseDetail,
        builder: (context) => const ExcerciseDetail()),
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
