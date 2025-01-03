import 'dart:convert';

import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/exception/app_exception.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpersUtils {
  HelpersUtils._();
  static T? jsonToObject<T>(
      String jsonString, T Function(Map<String, dynamic>) fromJson) {
    try {
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      return fromJson(jsonData);
    } catch (e) {
      print("Error converting JSON to object: $e");
      return null;
    }
  }

  static DateTime getToday() {
    return DateTime.now();
  }

  static showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
        'File uploaded successfully!',
        style: AppTextTheme.lightTextTheme.bodySmall,
      )),
    );
  }

  static NavigatorState navigatorState(BuildContext context) {
    return Navigator.of(context);
  }

  static Future<void> removeSplashScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    FlutterNativeSplash.remove();
  }

  static Future delay(int miliseconds, Function exce) async {
    await Future.delayed(Duration(milliseconds: miliseconds), () {
      exce();
    });
  }

  static void showErrorSnackbar(
      BuildContext context, String title, String message, StatusSnackbar status,
      {int? duration = 500}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: duration ?? 500),
        content: Column(
          children: [
            Text(
              '${title}',
              textAlign: TextAlign.center,
              style: AppTextTheme.lightTextTheme.bodyLarge?.copyWith(
                  color: status == StatusSnackbar.success
                      ? AppColors.textColor
                      : AppColors.backgroundLight),
            ),
            Text(
              '${message}',
              textAlign: TextAlign.center,
              style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                  color: status == StatusSnackbar.success
                      ? AppColors.textColor
                      : AppColors.backgroundLight),
            ),
          ],
        ),
        backgroundColor: status == StatusSnackbar.success
            ? AppColors.successLight
            : AppColors.errorColor,
      ),
    );
  }

  static Response validateResponse(Response response) {
    final statusCode = response.statusCode;

    if (statusCode != null) {
      if (statusCode >= 200 && statusCode < 300) {
        return response; // Return the response if status is in the 2xx range
      } else {
        // Handle specific status codes
        switch (statusCode) {
          case 400:
            throw BadRequestException(
                message: "${response.statusMessage}", title: "Bad Request");
          case 401:
            throw ForbiddenException(
                message: '${response.statusMessage}', title: 'Unauthorize');
          case 403:
            throw ForbiddenException(
                message: '${response.statusMessage}', title: 'Unauthorize');
          case 404:
            throw NotFoundException(
                message: '${response.statusMessage}', title: 'Not Found');
          case 500:
            throw InternalServerException(
                message: '${response.statusMessage}', title: 'Server is Down');
          default:
            throw UnknownException(
                message: '${response.statusMessage}', title: 'Oops');
        }
      }
    } else {
      throw UnknownException(
          title: "Oops", message: "Response does not contain a status code");
    }
  }

  static Future<void> deepLinkLauncher(String url) async {
    Uri uri = Uri.parse(url);
    if (!await launchUrl(
      uri,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  static Response? handleApiResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        return response;
      case 304:
        // Throw error ehre
        break;
      case 400:
        // Throw error ehre
        break;
      case 401:
        // Throw error ehre
        break;
      case 403:
        // Throw error ehre
        break;
      case 404:
        // Throw error ehre
        break;
      case 500:
        // Throw error ehre
        break;
      default:
        break;
    }
    return null;
  }
}
