import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:demo/core/riverpod/app_setting.dart';
import 'package:demo/core/riverpod/connectivity_state.dart';
import 'package:demo/data/service/firebase_remote_config.dart';
import 'package:demo/l10n/I10n.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/flavor/config.dart';
import 'package:demo/utils/global_config.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/local_storage/local_storage_utils.dart';
import 'package:demo/utils/theme/schema.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// import 'package:flutter_config/flutter_config.dart';
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
  late StreamSubscription<dynamic> _streamSubscription;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    HelpersUtils.removeSplashScreen();
    _streamSubscription = ref
        .read(connectivityStateProvider.notifier)
        .onConnectivityChange()
        .listen(
      (event) {
        if (kDebugMode) {
          print("Connection state is ${event.toString()}");
        }
        _handleCheckConnection(event);
      },
    );
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  void _handleCheckConnection(List<ConnectivityResult> event) {
    if (event.contains(ConnectivityResult.none)) {
      if (kDebugMode) {
        print("No Internet !! ");
      }
      navigatorKey.currentState?.pushNamed(
        AppPage.NO_INTERNET,
      );
    } else {
      print(" Internet is back !! ");
      if (navigatorKey.currentState?.canPop() == true) {
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
        initialRoute: AppPage.FIRST,
        // home: const WelcomeScreen(),
      );
    });
  }
}
