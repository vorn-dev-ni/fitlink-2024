import 'dart:io';

class VideoValidationHelper {
  static String? validateVideoFile(File? videoFile) {
    if (videoFile == null) {
      return 'Please provide a video file.';
    }

    return null;
  }

  static String? validateThumbnailFile(File? thumbnailFile) {
    if (thumbnailFile == null) {
      return 'Please provide a thumbnail image or cover for your video.';
    }

    if (!thumbnailFile.path.endsWith('.png') &&
        !thumbnailFile.path.endsWith('.jpg')) {
      return 'Invalid thumbnail format. Only .png and .jpg are supported.';
    }

    return null;
  }

  static String? validateCaption(String? caption) {
    if (caption == null || caption.isEmpty) {
      return 'Please provide a caption make sure it not empty.';
    }

    if (caption.length > 200) {
      return 'Caption is too long. It must be less than 200 characters.';
    }

    return null;
  }

  static String? validateTags(List<String>? tags) {
    if (tags == null || tags.isEmpty) {
      return 'Please provide at least one category in your video';
    }

    return null;
  }

  static String? validateUploadFields(File? videoFile, File? thumbnailFile,
      String? caption, List<String>? tags) {
    String? videoFileError = validateVideoFile(videoFile);
    if (videoFileError != null) return videoFileError;

    String? thumbnailFileError = validateThumbnailFile(thumbnailFile);
    if (thumbnailFileError != null) return thumbnailFileError;

    String? captionError = validateCaption(caption);
    if (captionError != null) return captionError;

    String? tagsError = validateTags(tags);
    if (tagsError != null) return tagsError;

    return null;
  }
}
