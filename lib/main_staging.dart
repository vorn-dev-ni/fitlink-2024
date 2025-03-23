import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:demo/app_cycle.dart';
import 'package:demo/common/model/user_model.dart';
import 'package:demo/common/widget/video/progress_uploading.dart';
import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/core/riverpod/app_setting.dart';
import 'package:demo/core/riverpod/connectivity_state.dart';
import 'package:demo/data/service/firebase/firebase_remote_config.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/firestore_service.dart';
import 'package:demo/data/service/firestore/notification/notification_service.dart';
import 'package:demo/features/home/controller/chat/following_friend_controller.dart';
import 'package:demo/features/home/controller/chat/user_status_controller.dart';
import 'package:demo/features/home/controller/comment/comment_controller.dart';
import 'package:demo/features/home/controller/navbar_controller.dart';
import 'package:demo/features/home/controller/posts/social_post_controller.dart';
import 'package:demo/features/home/controller/profile/profile_post_controller.dart';
import 'package:demo/features/home/controller/profile/profile_user_controller.dart';
import 'package:demo/features/home/controller/video/tiktok_video_controller.dart';
import 'package:demo/features/home/controller/workouts/activities_controller.dart';
import 'package:demo/features/home/views/single_profile/controller/notification_badge.dart';
import 'package:demo/l10n/I10n.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/global_key.dart';
import 'package:demo/utils/flavor/config.dart';
import 'package:demo/utils/global_config.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/local_storage/local_storage_utils.dart';
import 'package:demo/utils/theme/schema.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  // await FlutterConfig.loadEnvVariables();

  AppConfig.create(flavor: Flavor.staging);
  await GlobalConfig().init();
  await LocalStorageUtils().init();
  await FirebaseRemoteConfigService().init();
  //Detech Flutter platform crash
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  //Detech Native Platform crash
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  runApp(const ProviderScope(child: AppLifecycleObserver(child: MyApp())));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late String titleBar;
  bool showSnackbar = false;
  late StreamSubscription<dynamic> _streamSubscription;
  late NotificationRemoteService notificationRemoteService;
  StreamSubscription<User?>? streamAuthState;
  StreamSubscription<AuthModel?>? streamUserFirestore;

  late FirebaseAuthService _firebaseAuthService;
  bool isNavigating = false;
  bool hasStore = false;
  late FirestoreService firestoreService;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark, // For iOS
    ));
    _firebaseAuthService = FirebaseAuthService();
    notificationRemoteService =
        NotificationRemoteService(firebaseAuthService: _firebaseAuthService);
    _firebaseAuthService = FirebaseAuthService();
    firestoreService =
        FirestoreService(firebaseAuthService: _firebaseAuthService);
    HelpersUtils.removeSplashScreen();

    streamAuthState = _firebaseAuthService.authStateChanges.listen(
      (user) async {
        if (user == null &&
            LocalStorageUtils().getKey('email') != null &&
            LocalStorageUtils().getKey('email')!.isNotEmpty) {
          FirebaseAuth.instance.signOut();
          Fluttertoast.showToast(msg: 'Auth state changes');
          LocalStorageUtils().setKeyString('email', '');
          await user?.reload();
        }

        String? provider = user?.providerData[0].providerId;
        if (user != null && user.emailVerified ||
            provider == 'facebook.com' ||
            user?.phoneNumber != null && user?.phoneNumber != "") {
          ref.read(userStatusControllerProvider.notifier).setUserOnline();

          if (mounted && !isNavigating) {
            isNavigating = true;
            await LocalStorageUtils().setKeyString('uid', user?.uid ?? "");
            await LocalStorageUtils().setKeyString('email',
                user?.email != null ? user!.email! : user?.phoneNumber ?? "");
            if (user != null) {
              streamUserFirestore = firestoreService
                  .getUserStream(user.uid)
                  .listen((userDoc) async {
                final isUserEmailExist = LocalStorageUtils().getKey('email');

                if (userDoc != null &&
                    isUserEmailExist != null &&
                    isUserEmailExist != "") {
                  await syncUser(user.uid);
                }
              });
            }
            await Future.delayed(const Duration(milliseconds: 1000));
            if (navigatorKey.currentState?.canPop() == true) {
              navigatorKey.currentState!
                  .popUntil((route) => route.settings.name == AppPage.auth);
              navigatorKey.currentState!.pop();
            }
          }
        } else {
          isNavigating = false;
          await user?.reload();
        }
      },
    );

    _streamSubscription = ref
        .read(connectivityStateProvider.notifier)
        .onConnectivityChange()
        .listen(
      (event) {
        debugPrint("Connection state is ${event.toString()}");
        _handleCheckConnection(event);
      },
    );
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    streamAuthState?.cancel();
    streamUserFirestore?.cancel();
    super.dispose();
  }

  Future syncUser(String uid) async {
    try {
      // debugPrint("User is ${FirebaseAuth.instance.currentUser?.uid}");
      if (FirebaseAuth.instance.currentUser?.uid != null) {
        ref.invalidate(followingFriendControllerProvider(userId: uid));

        AuthModel? authModel = await firestoreService.getEmail(uid);
        final fmcToken = await HelpersUtils.getDeviceToken();
        if (fmcToken != null) {
          notificationRemoteService.storeFcmToken(uid, fmcToken);
        }
        if (mounted) {
          // ref.invalidate(navbarControllerProvider);
          ref.invalidate(socialInteractonVideoControllerProvider);
          ref.invalidate(userNotificationControllerProvider);
          // ref.invalidate(tiktokVideoControllerProvider);
          ref
              .read(navbarControllerProvider.notifier)
              .updateProfileTab(authModel.avatar ?? "");
          // ref.invalidate(navbarControllerProvider);
          ref.invalidate(socialPostControllerProvider);
          ref.invalidate(commentControllerProvider);
          ref.invalidate(profilePostControllerProvider);
          ref.invalidate(activitiesControllerProvider);
          ref.invalidate(profileUserControllerProvider);
          ref.read(appLoadingStateProvider.notifier).setState(false);
        }
      }
    } catch (e) {
      if (mounted) {
        HelpersUtils.showErrorSnackbar(
            duration: 2000,
            context,
            'Oop!',
            e.toString(),
            StatusSnackbar.failed);
      }
    }
  }

  void _handleCheckConnection(List<ConnectivityResult> event) {
    if (event.contains(ConnectivityResult.none)) {
      Fluttertoast.showToast(
          msg: "Disconnected Internet",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.errorColor,
          textColor: Colors.white,
          fontSize: 16.0);
      navigatorKey.currentState?.pushNamed(
        AppPage.NO_INTERNET,
      );
    } else {
      if (navigatorKey.currentState?.canPop() == true) {
        Fluttertoast.showToast(
            msg: "Internet Connection is back",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.successColor,
            textColor: Colors.white,
            fontSize: 16.0);
        navigatorKey.currentState?.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appSettingState = ref.watch(appSettingsControllerProvider);
    final themMode = appSettingState.appTheme == AppTheme.light
        ? ThemeMode.light
        : ThemeMode.dark;
    return Sizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        title: 'Flutter Staging',

        builder: FToastBuilder(),
        debugShowCheckedModeBanner: false,
        locale: Locale(appSettingState.localization),
        supportedLocales: L10n.all,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        // routes: AppRoutes.getAppRoutes(),
        navigatorKey: navigatorKey,
        onGenerateRoute: (settings) =>
            GlobalConfig.instance.onGenerateRoute(settings),

        themeMode: themMode,
        theme: SchemaData.lightThemeData(locale: appSettingState.localization),
        darkTheme:
            SchemaData.darkThemeData(locale: appSettingState.localization),
        initialRoute: AppPage.START,
        // home: const WelcomeScreen(),
      );
    });
  }
}
