import 'dart:io';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class DeviceUtils {
  DeviceUtils._();

  static bool isIOS() {
    return Platform.isIOS;
  }

  static bool isAndroid() {
    return Platform.isAndroid;
  }

  static Future<void> setStatusBar(Color color) async {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: color,
    ));
  }

  static bool isKeyboardVisible(BuildContext context) {
    final padding = MediaQuery.of(context).viewInsets.bottom;
    return padding > 0;
  }

  static Future getDeviceName() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (isAndroid()) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      return '${androidInfo.model}';
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

      return '${iosInfo.name}';
    }
  }

  static Future<void> setToPortraitModeOnly() async {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  static Future<PackageInfo> getAppInfoPackage() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName; // App name
    String packageName = packageInfo.packageName; // Package name
    String version = packageInfo.version; // Version name (e.g., "1.0.0")
    String buildNumber = packageInfo.buildNumber; // Build number
    print('App Name: $appName');
    print('Package Name: $packageName');
    print('Version: $version');
    print('Build Number: $buildNumber');
    return packageInfo;
  }

  static Future<void> setToLandscapeMode() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  static void openKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static double getDeviceWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double getDeviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static Future<void> openMap(double latitude, double longitude) async {
    final googleMapsUrl = Uri.parse(
        'https://www.google.com/maps?saddr=&daddr=$latitude,$longitude&zoom=14');

    final appleMapsUrl =
        Uri.parse('https://maps.apple.com/?q=$latitude,$longitude&zoom=14');

    if (DeviceUtils.isAndroid()) {
      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl);
      } else {
        throw 'Could not open the map';
      }
    } else {
      if (await canLaunchUrl(appleMapsUrl)) {
        await launchUrl(appleMapsUrl);
      } else {
        throw 'Could not open the apple map';
      }
    }
  }

  static Future<void> shareMedia({
    String? title,
    String? desc,
    String? feature, // Assuming feature is the URL of the image
  }) async {
    final String shareContent =
        'Check out this: $title\n\nDescription: $desc\n\nImage URL: $feature';

    try {
      if (feature != null && feature.isNotEmpty) {
        final result = await Share.share(shareContent);

        if (result.status == ShareResultStatus.success) {
          debugPrint('Success!');
          _showToast('Thank you for sharing!', Colors.green);
        } else {
          // _showToast('Something went wrong.', Colors.red);
        }
      } else {
        final result = await Share.share(shareContent);

        if (result.status == ShareResultStatus.success) {
          debugPrint('Success!');
          _showToast('Thank you for sharing!', Colors.green);
        } else {
          // _showToast('Failed to share.', Colors.red);
        }
      }
    } catch (e) {
      _showToast('An error occurred while sharing.', Colors.red);
    }
  }

  static void _showToast(String message, Color backgroundColor) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
  // static Future shareMedia({
  //   String? title,
  //   String? desc,
  //   String? feature,
  // }) async {
  //   final String shareContent =
  //       'Check out this: $title\n\nDescription: $desc\n\nImage: $feature';
  //   final result = await Share.share(shareContent);

  //   if (result.status == ShareResultStatus.success) {
  //     debugPrint('Success!');
  //     Fluttertoast.showToast(
  //         msg: 'Thank you for sharing !!!!',
  //         toastLength: Toast.LENGTH_LONG,
  //         gravity: ToastGravity.BOTTOM,
  //         timeInSecForIosWeb: 5,
  //         backgroundColor: AppColors.secondaryColor,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //   }
  // }
}
