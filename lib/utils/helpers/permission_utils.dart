import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  PermissionUtils._();

  /// Check and request notification permission
  static Future<void> checkNotificationPermission(BuildContext context) async {
    PermissionStatus status = await Permission.notification.status;
    debugPrint('Status is ${status}');
    if (status == PermissionStatus.denied ||
        status == PermissionStatus.permanentlyDenied) {
      _handlePermissionStatus(
          context,
          status,
          "Enable Notifications",
          "This app needs notification permission to send alerts. Please enable it in settings.",
          true);
    }
  }

  /// Check and request location permission
  static Future<void> checkLocationPermission(BuildContext context) async {
    PermissionStatus status = await Permission.location.request();
    _handlePermissionStatus(
        context,
        status,
        "Enable Location",
        "This app needs access to your location. Please enable it in settings.",
        false);
  }

  /// Check and request camera permission
  static Future<void> checkCameraPermission(BuildContext context) async {
    PermissionStatus status = await Permission.camera.request();
    _handlePermissionStatus(
        context,
        status,
        "Enable Camera",
        "This app needs access to your camera. Please enable it in settings.",
        false);
  }

  /// Check and request gallery (photos) permission
  static Future<void> checkGalleryPermission(BuildContext context) async {
    PermissionStatus status = await Permission.photos.request();
    _handlePermissionStatus(
        context,
        status,
        "Enable Gallery Access",
        "This app needs access to your photos. Please enable it in settings.",
        false);
  }

  /// Check and request file storage permission
  static Future<void> checkStoragePermission(BuildContext context) async {
    PermissionStatus status = await Permission.storage.request();
    _handlePermissionStatus(
        context,
        status,
        "Enable File Storage",
        "This app needs access to your files. Please enable it in settings.",
        false);
  }

  /// Handles permission response and shows dialog if needed
  static void _handlePermissionStatus(BuildContext context,
      PermissionStatus status, String title, String message, bool canPop) {
    if (status.isDenied || status.isPermanentlyDenied) {
      if (context.mounted) {
        showPermissionDialog(context, title, message, canPop);
      }
    }
  }

  /// Show permission dialog
  static Future showPermissionDialog(
      BuildContext context, String title, String message, bool canPop) {
    return showDialog(
      context: context,
      barrierDismissible: canPop,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              if (canPop == false) {
                Navigator.pop(context);
                Navigator.pop(context);
              } else {
                Navigator.pop(context);
              }
            },
            child: Text(
              "Cancel",
              style: AppTextTheme.lightTextTheme.bodyMedium,
            ),
          ),
          TextButton(
            onPressed: () {
              openAppSettings(); // Open app settings
              Navigator.pop(context);
            },
            child: Text(
              "Open Settings",
              style: AppTextTheme.lightTextTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
