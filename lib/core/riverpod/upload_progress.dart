import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/data/service/firebase/storage_service.dart';
import 'package:demo/utils/constant/storage_message.dart';
import 'package:demo/utils/exception/app_exception.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'upload_progress.g.dart';

@Riverpod(keepAlive: true)
class UploadProgressController extends _$UploadProgressController {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  StorageService storageService = StorageService();

  @override
  UploadProgressState build() {
    return UploadProgressState(
        progress: 0.0, thumbnailUrl: null, isUploading: false);
  }

  Future<void> uploadVideo({
    required File videoFile,
    required File thumbnailFile,
    required String caption,
    List<String>? tags,
    WidgetRef? widgetRef,
  }) async {
    try {
      ref
          .read(uploadProgressControllerProvider.notifier)
          .prepareUpload(thumbnailFile, 0.0);
      // Upload thumbnail first
      navigatingBackHome(widgetRef);
      Fluttertoast.showToast(msg: 'Your upload is in process...');

      Future.delayed(Duration.zero, () async {
        try {
          final thumbnailUploadResult = await storageService.uploadFile(
            file: thumbnailFile,
            fileName: '${DateTime.now().millisecondsSinceEpoch}_thumbnail.png',
            rootDir: 'thumbnails',
          );
          final thumbnailUrl = thumbnailUploadResult?['downloadUrl'] as String?;
          final videoStorageRef = _storage.ref().child(
              'videos/${DateTime.now().millisecondsSinceEpoch}_video.mp4');
          final uploadTask = videoStorageRef.putFile(
            videoFile,
            SettableMetadata(
              contentType: 'video/mp4',
              customMetadata: {'source': 'flutter'},
            ),
          );

          uploadTask.snapshotEvents.listen((event) {
            final progress = (event.bytesTransferred / event.totalBytes) * 100;
            ref
                .read(uploadProgressControllerProvider.notifier)
                .startUpload(thumbnailFile, progress);

            debugPrint(
                'Video Upload Progress: ${progress.toStringAsFixed(2)}%');
            if (progress >= 100) {
              debugPrint('Video Upload Completed!');
            }
          });

          final videoUploadResult = await uploadTask;
          final videoUrl = await videoUploadResult.ref.getDownloadURL();
          final videoData = {
            'caption': caption,
            'caption_lower_case': caption.toLowerCase(),
            'tag': tags ?? [],
            'videoUrl': videoUrl,
            'thumbnailUrl': thumbnailUrl,
            'commentCount': 0,
            'likeCount': 0,
            'shareCount': 0,
            'viewCount': 0,
            'createdAt': Timestamp.now(),
            'userRef': _firebaseFirestore
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser?.uid),
          };

          await _firebaseFirestore.collection('videos').add(videoData);
          ref.read(uploadProgressControllerProvider.notifier).completeUpload();
          Fluttertoast.showToast(msg: 'Video uploaded successfully!');
        } catch (e) {
          debugPrint('Error uploading video: $e');
        }
      });
    } catch (e) {
      ref.read(uploadProgressControllerProvider.notifier).completeUpload();
      ref.read(appLoadingStateProvider.notifier).setState(false);

      rethrow;
    }
  }

  void startUpload(File thumbnailUrl, double progress) {
    state = UploadProgressState(
      progress: progress,
      thumbnailUrl: thumbnailUrl,
      isUploading: true,
    );
  }

  void prepareUpload(File thumbnailUrl, double progress) {
    state = state.copyWith(
        isUploading: true, progress: 0.0, thumbnailUrl: thumbnailUrl);
  }

  Future<Map<String, dynamic>?> saveVideo({
    required File file,
    required String fileName,
    String? rootDir = 'videos',
  }) async {
    try {
      final path =
          '${rootDir}/${DateTime.now().millisecondsSinceEpoch}-$fileName';
      debugPrint('file path is $path');
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

  void completeUpload() {
    state = UploadProgressState(
        progress: 0.0, thumbnailUrl: null, isUploading: false);
  }

  void startFakeUpload() {
    String defaultThumbnail =
        'https://images.ctfassets.net/8urtyqugdt2l/4wPk3KafRwgpwIcJzb0VRX/4894054c6182c62c1d850628935a4b0b/desktop-best-chest-exercises.jpg';

    state = UploadProgressState(
        progress: 0.0, thumbnailUrl: null, isUploading: true);

    double progress = 0;
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      progress += 1.0;
      if (progress >= 50) {
        timer.cancel();
        completeUpload();
      }
      state = state.copyWith(progress: progress);
    });
  }

  void navigatingBackHome(WidgetRef? ref) {
    if (ref != null) {
      HelpersUtils.navigatorState(ref.context).pop();

      HelpersUtils.navigatorState(ref.context).pop();
    }
  }
}

class UploadProgressState {
  final double progress;
  final File? thumbnailUrl;
  final bool isUploading;

  UploadProgressState({
    required this.progress,
    this.thumbnailUrl,
    required this.isUploading,
  });

  UploadProgressState copyWith(
      {double? progress, File? thumbnailUrl, bool? isUploading}) {
    return UploadProgressState(
      progress: progress ?? this.progress,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      isUploading: isUploading ?? this.isUploading,
    );
  }
}
