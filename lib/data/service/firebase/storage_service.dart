import 'dart:io';
import 'package:demo/utils/constant/storage_message.dart';
import 'package:demo/utils/exception/app_exception.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<Map<String, dynamic>?> uploadFile(
      {required File file,
      required String fileName,
      String? rootDir = 'images'}) async {
    try {
      final path =
          '${rootDir}/${DateTime.now().millisecond}-${fileName.substring(1)}';
      debugPrint('file path is ${path}');
      final ref = _storage.ref().child(path);
      await ref.putFile(file);
      debugPrint('Upload file successfully');

      return {
        'downloadUrl': await ref.getDownloadURL(),
        'path': path,
      };
    } catch (e) {
      String errorMessage = e.toString();
      debugPrint('Error uploading file: $e');

      if (e is FirebaseException) {
        FirebaseStorageErrorHandler.getErrorMessage(e.code);
        debugPrint('Error uploading file: $errorMessage');
      }
      throw AppException(title: 'Oop !!!', message: errorMessage);
    }
  }
  // Future<Map<String, dynamic>?> uploadFile({
  //   required File file,
  //   required String fileName,
  //   String? rootDir = 'images',
  // }) async {
  //   try {
  //     final path =
  //         '${rootDir}/${DateTime.now().millisecondsSinceEpoch}-$fileName';
  //     debugPrint('File path: $path');

  //     final ref = _storage.ref().child(path);
  //     await ref.putFile(file);
  //     debugPrint('File uploaded successfully');
  //     return {
  //       'downloadUrl': await ref.getDownloadURL(),
  //       'path': path,
  //     };
  //   } catch (e) {
  //     String errorMessage = e.toString();
  //     debugPrint('Error uploading file: $errorMessage');
  //     if (e is FirebaseException) {
  //       String firebaseErrorMessage =
  //           FirebaseStorageErrorHandler.getErrorMessage(e.code);
  //       debugPrint('Firebase Error: $firebaseErrorMessage');
  //     }
  //     throw AppException(title: 'Oops!!!', message: errorMessage);
  //   }
  // }

  Future<bool> deleteFile(String path) async {
    try {
      final ref = _storage.ref().child(path);
      await ref.delete();
      debugPrint('File has been delete successfully');

      return true;
    } catch (e) {
      debugPrint('Error deleting file: $e');
      return false;
    }
  }

  Future<String?> getDownloadUrl(String path) async {
    try {
      final ref = _storage.ref().child(path);
      return await ref.getDownloadURL();
    } catch (e) {
      debugPrint('Error fetching download URL: $e');
      return null;
    }
  }
}
