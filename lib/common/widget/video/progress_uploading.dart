import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo/core/riverpod/upload_progress.dart';
import 'package:sizer/sizer.dart';

class UploadOverlay extends ConsumerStatefulWidget {
  const UploadOverlay({super.key});

  @override
  _UploadOverlayState createState() => _UploadOverlayState();
}

class _UploadOverlayState extends ConsumerState<UploadOverlay> {
  @override
  Widget build(BuildContext context) {
    final uploadState = ref.watch(uploadProgressControllerProvider);
    if (!uploadState.isUploading) {
      return const SizedBox();
    }
    return Positioned(
      bottom: 0,
      right: 0,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 300),
        offset:
            uploadState.isUploading ? const Offset(0, 0) : const Offset(0, 1),
        child: SafeArea(
          child: Container(
            width: 150,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (uploadState.thumbnailUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: Image.file(
                      uploadState.thumbnailUrl!,
                      // width: 200,
                      width: 100.w,
                      filterQuality: FilterQuality.high,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    maxLines: 2,
                    'Uploading... ${uploadState.progress.toStringAsFixed(2)}%',
                    textAlign: TextAlign.center,
                    style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                      color: AppColors.backgroundLight,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: uploadState.progress / 100,
                  backgroundColor: Colors.grey[600],
                  color: Colors.blueAccent,
                  minHeight: 6,
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
