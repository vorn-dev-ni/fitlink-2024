import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/core/riverpod/app_setting.dart';
import 'package:demo/core/riverpod/connectivity_state.dart';
import 'package:demo/data/service/firebase/firebase_remote_config.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
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
import 'package:firebase_app_check/firebase_app_check.dart';

// import 'package:flutter_config/flutter_config.dart';
void main() async {
  // await FlutterConfig.loadEnvVariables();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.black,
    statusBarIconBrightness: Brightness.light,
  ));
  AppConfig.create(flavor: Flavor.dev);
  await GlobalConfig().init();
  await LocalStorageUtils().init();
  await FirebaseRemoteConfigService().init();
  //Detech Flutter platform crash
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  await FirebaseAppCheck.instance.activate(
    appleProvider: AppleProvider.appAttestWithDeviceCheckFallback,
    androidProvider: AndroidProvider.playIntegrity,
  );

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
  late FirebaseAuthService _firebaseAuthService;
  bool isNavigating = false;

  @override
  void initState() {
    super.initState();

    _firebaseAuthService = FirebaseAuthService();
    HelpersUtils.removeSplashScreen();

    streamAuthState = _firebaseAuthService.authStateChanges.listen(
      (user) async {
        String? provider = user?.providerData[0].providerId;
        if (user != null && user.emailVerified || provider == 'facebook.com') {
          if (mounted && !isNavigating) {
            isNavigating = true;
            await LocalStorageUtils().setKeyString('email', user!.email!);
            ref.read(appLoadingStateProvider.notifier).setState(false);
            navigatorKey.currentState?.pushNamedAndRemoveUntil(
              AppPage.home,
              (route) => false,
            );
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
    super.dispose();
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
        title: 'Flutter Dev',
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
