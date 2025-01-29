import 'package:demo/common/model/route_app.dart';
import 'package:demo/common/routes/routes.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/features/home/my_home.dart';
import 'package:demo/features/on_boarding/on_boarding.dart';
import 'package:demo/features/other/not_found.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/firebase/firebase.dart';
import 'package:demo/utils/firebase/firebase_options.dart';
import 'package:demo/utils/local_storage/local_storage_utils.dart';
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
    final matchingRoute = AppRoutes.mainStacks.firstWhere(
      (route) => route.routeName == settings.name,
      orElse: () => RoutesApp(
          routeName: AppPage.NOTFOUND,
          builder: (context) => const NotFoundScreen()),
    );

    final isFirstime = LocalStorageUtils().getboolKey('firstTime') ?? true;
    if (settings.name == AppPage.START && isFirstime == true) {
      return MaterialPageRoute(
        builder: (context) => const OnBoardingScreen(),
        settings: settings,
      );
    }
    if (settings.name == AppPage.START && isFirstime == false) {
      return MaterialPageRoute(
        builder: (context) => const MyHomeScreen(),
        settings: settings,
      );
    }

    return MaterialPageRoute(
      builder: (context) => matchingRoute.builder(context),
      settings: settings,
    );
  }
}
