import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/device/device_utils.dart';
import 'package:demo/utils/local_storage/local_storage_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:location/location.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/exception/app_exception.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';

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

  static Future<Map<String, dynamic>?> generateThumbnail(
      String videoPath) async {
    try {
      // Get the thumbnail data from the video
      final Uint8List? thumbnailData = await VideoThumbnail.thumbnailData(
        video: videoPath,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 128, // Set the max width for the thumbnail
        quality: 25,
      );

      if (thumbnailData == null) {
        Fluttertoast.showToast(msg: 'Failed to generate thumbnail');
        return null;
      }

      // Return the thumbnail data directly without saving to a file
      return {'data': thumbnailData};
    } catch (e) {
      // debugPrint('Error generating thumbnail: $e');
      // Fluttertoast.showToast(msg: 'Error generating thumbnail: $e');
      rethrow;
    }
  }
//   static Future<void> generateAndUploadThumbnail(String videoPath) async {
//     try {
//       // Get the thumbnail data from the video
//       final Uint8List? thumbnailData = await VideoThumbnail.thumbnailData(
//         video: videoPath,
//         imageFormat: ImageFormat.JPEG,
//         maxWidth: 128, // Set the max width for the thumbnail
//         quality: 25,   // Set the quality of the thumbnail (0-100)
//       );

//       if (thumbnailData == null) {
//         Fluttertoast.showToast(msg: 'Failed to generate thumbnail');
//         return;
//       }

//       // Save the thumbnail data as a file
//       final directory = await getTemporaryDirectory();
//       final thumbnailFile = File('${directory.path}/thumbnail_${DateTime.now().millisecondsSinceEpoch}.jpg');

//       // Write the thumbnail data to a file
//       await thumbnailFile.writeAsBytes(thumbnailData);

//       // Upload the file to Firebase Storage
//       final storageRef = FirebaseStorage.instance.ref().child('thumbnails/${DateTime.now().millisecondsSinceEpoch}.jpg');

//       // Upload the file
//       await storageRef.putFile(thumbnailFile);
//       Fluttertoast.showToast(msg: 'Thumbnail uploaded successfully!');
//     } catch (e) {
//       debugPrint('Error generating or uploading thumbnail: $e');
//       Fluttertoast.showToast(msg: 'Error: $e');
//     }
//   }
// }

  static Future<BitmapDescriptor> getBitmapAssets(String assetPath) async {
    final asset = await rootBundle.load(assetPath);
    final icon = BitmapDescriptor.fromBytes(asset.buffer.asUint8List());
    return icon;
  }

  static bool isAuthenticated(BuildContext context) {
    final email = LocalStorageUtils().getKey('email');
    if (email == "" || email == null) {
      HelpersUtils.navigatorState(context).pushNamed(AppPage.auth);
      return false;
    }
    return true;
  }

  static Future<LocationData> getCurrentLocation() async {
    Location location = Location();

    // Check if location services are enabled
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }
    }

    // Request location permission
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return Future.error(
            'Location permissions are denied. Please enable them in settings.');
      }
    }

    // If permission is permanently denied, ask user to enable manually
    if (permissionGranted == PermissionStatus.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied. Please enable them in settings.');
    }

    // Get current location
    try {
      LocationData locationData = await location.getLocation();

      return locationData;
    } catch (e) {
      return Future.error('Failed to get location: $e');
    }
  }

  static Future<String?> getDeviceToken() async {
    try {
      String? token = DeviceUtils.isAndroid()
          ? await FirebaseMessaging.instance.getToken()
          : await FirebaseMessaging.instance.getAPNSToken();

      if (token != null) {
        debugPrint("Device FCM Token: $token");

        return token;
      } else {
        debugPrint("Failed to retrieve FCM token");
      }
    } catch (e) {
      debugPrint("Error retrieving FCM token: $e");
    }
  }

  static String generateRandomUsername() {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    Random random = Random();
    String firstPart = List.generate(
        4, (index) => characters[random.nextInt(characters.length)]).join();
    String secondPart = List.generate(
        3, (index) => characters[random.nextInt(characters.length)]).join();
    return '$firstPart $secondPart';
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

  static Future<File?> pickImage(ImageSource source) async {
    final XFile? pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  static String getLastExtension(String filePath) {
    int lastDotIndex = filePath.lastIndexOf('.');
    if (lastDotIndex != -1) {
      return filePath.substring(lastDotIndex + 1);
    }
    return ''; // Return empty string if no extension found
  }

  static String getLastFileName(String filePath) {
    int lastSlashIndex = filePath.lastIndexOf('/');
    if (lastSlashIndex != -1) {
      return filePath.substring(lastSlashIndex);
    }
    return filePath;
  }

  static String getDownloadedFile(String url) {
    Uri uri = Uri.parse(url);

    String fileName = uri.path.replaceAll("/o/", "*");
    fileName = fileName.replaceAll("?", "*");
    fileName = fileName.split("*")[1];
    return fileName;
  }

  static String getFileExtension(String filePath) {
    int lastDotIndex = filePath.lastIndexOf('.');
    if (lastDotIndex != -1) {
      return filePath.substring(lastDotIndex + 1);
    }
    return '';
  }

  static Future<File?> cropAndCompressImage(String sourcePath) async {
    final croppedImage = await ImageCropper().cropImage(
      sourcePath: sourcePath,
      compressQuality: 60,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'FitLink Crop Image',
          toolbarColor: AppColors.secondaryColor,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: AppColors.secondaryColor,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'FitLink Crop Image',
        ),
      ],
    );
    if (croppedImage == null) {
      return null;
    }

    return File(croppedImage.path);
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
              title,
              textAlign: TextAlign.center,
              style: AppTextTheme.lightTextTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: status == StatusSnackbar.success
                      ? AppColors.backgroundLight
                      : AppColors.backgroundLight),
            ),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: status == StatusSnackbar.success
                      ? AppColors.backgroundLight
                      : AppColors.backgroundLight),
            ),
          ],
        ),
        backgroundColor: status == StatusSnackbar.success
            ? AppColors.secondaryColor
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
