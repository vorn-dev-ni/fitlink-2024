import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:demo/common/model/user_model.dart';
import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/core/riverpod/app_setting.dart';
import 'package:demo/core/riverpod/connectivity_state.dart';
import 'package:demo/data/service/firebase/firebase_remote_config.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/firestore_service.dart';
import 'package:demo/features/home/controller/comment/comment_controller.dart';
import 'package:demo/features/home/controller/navbar_controller.dart';
import 'package:demo/features/home/controller/posts/social_post_controller.dart';
import 'package:demo/features/home/controller/posts/user_like_controller.dart';
import 'package:demo/features/home/controller/profile/profile_user_controller.dart';
import 'package:demo/l10n/I10n.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/enums.dart';
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
  runApp(const ProviderScope(child: MyApp()));
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
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  StreamSubscription<User?>? streamAuthState;
  StreamSubscription<AuthModel?>? streamUserFirestore;

  late FirebaseAuthService _firebaseAuthService;
  bool isNavigating = false;
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
    firestoreService =
        FirestoreService(firebaseAuthService: _firebaseAuthService);
    HelpersUtils.removeSplashScreen();

    streamAuthState = _firebaseAuthService.authStateChanges.listen(
      (user) async {
        if (user == null &&
            LocalStorageUtils().getKey('email') != null &&
            LocalStorageUtils().getKey('email')!.isNotEmpty) {
          FirebaseAuth.instance.signOut();
          await user?.reload();
          LocalStorageUtils().setKeyString('email', '');
        }

        String? provider = user?.providerData[0].providerId;
        if (user != null && user.emailVerified ||
            provider == 'facebook.com' ||
            user?.phoneNumber != null && user?.phoneNumber != "") {
          if (mounted && !isNavigating) {
            isNavigating = true;
            await LocalStorageUtils().setKeyString('email',
                user?.email != null ? user!.email! : user?.phoneNumber ?? "");
            if (user != null) {
              streamUserFirestore = firestoreService
                  .getUserStream(user.uid)
                  .listen((userDoc) async {
                if (userDoc != null) {
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
      AuthModel? authModel = await firestoreService.getEmail(uid);
      if (mounted) {
        debugPrint("Sync user again tt hz");
        ref.invalidate(socialPostControllerProvider);
        ref.invalidate(userLikeControllerProvider);
        ref.invalidate(commentControllerProvider);
        ref
            .read(navbarControllerProvider.notifier)
            .updateProfileTab(authModel.avatar ?? "");

        ref.invalidate(profileUserControllerProvider);
        ref.read(appLoadingStateProvider.notifier).setState(false);
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
