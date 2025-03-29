import 'dart:io';
import 'package:demo/core/riverpod/upload_progress.dart';
import 'package:demo/utils/constant/storage_message.dart';
import 'package:demo/utils/exception/app_exception.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      final uploadRef = _storage.ref().child(path);
      await uploadRef.putFile(file);
      debugPrint('Upload file successfully');

      return {
        'downloadUrl': await uploadRef.getDownloadURL(),
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

  Future<Map<String, dynamic>?> uploadVideo({
    required File file,
    required String fileName,
    String? rootDir = 'images',
    required WidgetRef ref,
  }) async {
    try {
      final path =
          '${rootDir}/${DateTime.now().millisecondsSinceEpoch}-${fileName.substring(0, 1)}';
      final uploadRef = _storage.ref().child(path);
      final uploadTask = uploadRef.putFile(file);

      uploadTask.snapshotEvents.listen((event) {
        final progress = (event.bytesTransferred / event.totalBytes) * 100;

        ref
            .read(uploadProgressControllerProvider.notifier)
            .startUpload(file, progress);
        if (progress >= 100) {
          ref.read(uploadProgressControllerProvider.notifier).completeUpload();
        }
        debugPrint('Upload progress: $progress%');
      });

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      debugPrint('Upload file successfully');

      return {
        'downloadUrl': downloadUrl,
        'path': path,
      };
    } catch (e) {
      String errorMessage = e.toString();
      debugPrint('Error uploading file: $e');
      ref.read(uploadProgressControllerProvider.notifier).completeUpload();

      if (e is FirebaseException) {
        FirebaseStorageErrorHandler.getErrorMessage(e.code);
        debugPrint('Error uploading file: $errorMessage');
      }

      throw AppException(title: 'Oop !!!', message: errorMessage);
    } finally {}
  }

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
