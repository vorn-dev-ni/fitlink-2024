import 'dart:io';
import 'package:demo/core/riverpod/upload_progress.dart';
import 'package:demo/data/repository/firebase/video_repo.dart';
import 'package:demo/data/service/firebase/storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VideoUserActionController {
  final VideoRepository _videoRepository;
  final StorageService _storageService;
  final WidgetRef _ref;

  VideoUserActionController(
      {required VideoRepository videoRepository,
      required ref,
      required StorageService storageService})
      : _videoRepository = videoRepository,
        _ref = ref,
        _storageService = storageService;

  Future<void> uploadVideo({
    required File videoFile,
    required File thumbnailFile,
    required String caption,
    required List<String> tags,
  }) async {
    try {
      await _ref.read(uploadProgressControllerProvider.notifier).uploadVideo(
          tags: tags,
          widgetRef: _ref,
          videoFile: videoFile,
          thumbnailFile: thumbnailFile,
          caption: caption);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
