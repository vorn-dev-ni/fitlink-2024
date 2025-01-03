import 'package:demo/common/model/route_app.dart';
import 'package:demo/common/model/screen_app.dart';
import 'package:demo/common/routes/routes.dart';
import 'package:demo/data/service/firebase_service.dart';
import 'package:demo/features/other/not_found.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/firebase/firebase.dart';
import 'package:demo/utils/firebase/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class GlobalConfig {
  static final GlobalConfig instance = GlobalConfig._internal();
  GlobalConfig._internal(); //Private Constructor
  factory GlobalConfig() {
    return instance;
  }
  Future<void> init() async {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    await dotenv.load(fileName: ".env.dev");

    await initializeFirebaseApp(DefaultFirebaseOptions.currentPlatform);
  }

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    // print('App Routes ${AppRoutes.mainStacks.toString()}');
    final User? currentUser = FirebaseAuthService().currentUser;

    if (kDebugMode) {
      print(
          '>>> On initial route call ${currentUser?.email} setting ${settings.name}');
    }

    final matchingRoute = AppRoutes.mainStacks.firstWhere(
      (route) => route.routeName == settings.name,
      orElse: () => RoutesApp(
          routeName: AppPage.NOTFOUND,
          builder: (context) => const NotFoundScreen()),
    );

    final navigationRoute = AppRoutes.navigationStacks.firstWhere(
      (route) => route.routeName == settings.name,
      orElse: () => ScreenApp(
          routeName: AppPage.NOTFOUND,
          arguments: null,
          builder: (context) => const NotFoundScreen()),
    );

    if (navigationRoute.routeName == AppPage.NOTFOUND &&
        matchingRoute.routeName == AppPage.NOTFOUND) {
      // Screen does not exist
      return MaterialPageRoute(
        builder: (context) => const NotFoundScreen(),
        settings: settings,
      );
    }

    return MaterialPageRoute(
      builder: (context) => matchingRoute.builder(context),
      settings: settings,
    );
  }
}
