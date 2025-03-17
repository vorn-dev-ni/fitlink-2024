import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/constant_data.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';

class CameraRecordCustom extends StatefulWidget {
  final Function(String videoPath, String thumbnail) onVideoRecorded;

  const CameraRecordCustom({Key? key, required this.onVideoRecorded})
      : super(key: key);

  @override
  State<CameraRecordCustom> createState() => _CameraRecordCustomState();
}

class _CameraRecordCustomState extends State<CameraRecordCustom>
    with WidgetsBindingObserver {
  CameraController? _controller;
  late List<CameraDescription> _cameras;
  bool _isRecording = false;
  bool _isFlashOn = false;
  Timer? _timer;
  int _recordDuration = 0;
  bool _isFrontCamera = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras.isNotEmpty) {
      _controller = CameraController(
          enableAudio: true,
          fps: 60,
          _isFrontCamera ? _cameras[1] : _cameras[0],
          ResolutionPreset.high);
      await _controller?.initialize();
      if (mounted) setState(() {});
    }
  }

  Future<void> _toggleFlash() async {
    if (_controller != null && _controller!.value.isInitialized) {
      _isFlashOn = !_isFlashOn;
      await _controller!
          .setFlashMode(_isFlashOn ? FlashMode.torch : FlashMode.off);
      setState(() {});
    }
  }

  Future _toggleCameraPosition() async {
    if (_controller != null && _controller!.value.isInitialized) {
      _isFrontCamera = !_isFrontCamera;
      await _initializeCamera();
    }
  }

  void _startRecording() async {
    if (_controller == null || _isRecording) return;

    try {
      await _controller!.startVideoRecording();
      setState(() => _isRecording = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_recordDuration >= 60) {
          _stopRecording();
        } else {
          setState(() => _recordDuration++);
        }
      });
    } catch (e) {
      debugPrint("Error starting recording: $e");
    }
  }

  void _stopRecording() async {
    if (_controller == null || !_isRecording) return;
    _timer?.cancel();
    _recordDuration = 0;

    try {
      final file = await _controller!.stopVideoRecording();
      final thumbnailString = await HelpersUtils.generateThumbnail(file.path);

      // debugPrint("Thumnnail is ${thumbnailString}");
      widget.onVideoRecorded(file.path, "");

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPreviewPage(
              videoPath: file.path,
              thumbnailData: thumbnailString!['data'],
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint("Error stopping recording: $e");
    }

    setState(() => _isRecording = false);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(seconds: 60),
    );
    if (pickedFile != null && mounted) {
      debugPrint("Image picked: ${pickedFile.path}");
      HelpersUtils.navigatorState(context)
          .pushNamed(AppPage.previewVideo, arguments: pickedFile.path);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _controller!.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Container(
        decoration: const BoxDecoration(color: AppColors.backgroundDark),
      );
    }

    return Stack(
      children: [
        // Positioned.fill(child: CameraPreview(_controller!)),
        Positioned.fill(
          child: AspectRatio(
            aspectRatio: 9 / 16,
            child: CameraPreview(
              _controller!,
            ),
          ),
        ),
        if (!_isRecording)
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  _isFlashOn ? Icons.flash_on : Icons.flash_off,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: _toggleFlash,
              ),
            ),
          ),
        if (!_isRecording)
          Positioned(
            top: 20,
            right: 80,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  CupertinoIcons.switch_camera,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: _toggleCameraPosition,
              ),
            ),
          ),
        Positioned(
          bottom: 60,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: _isRecording ? _stopRecording : _startRecording,
              // onLongPressUp: _stopRecording,
              onLongPress: _startRecording,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: _isRecording ? Colors.red : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
              ),
            ),
          ),
        ),
        if (!_isRecording)
          Positioned(
            bottom: 10,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.photo,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: _pickImage,
              ),
            ),
          ),
        if (_isRecording)
          Positioned(
            bottom: 20, // Adjusted to show the duration above the button
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                    color: AppColors.backgroundDark.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(Sizes.md)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                child: Text(
                  '${formatDuration(_recordDuration)} / 01:00',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

String formatDuration(int durationInSeconds) {
  return '${(durationInSeconds ~/ 60).toString().padLeft(2, '0')}:${(durationInSeconds % 60).toString().padLeft(2, '0')}';
}

class VideoPreviewPage extends StatefulWidget {
  final String videoPath;
  final Uint8List? thumbnailData;
  VideoPreviewPage({Key? key, required this.videoPath, this.thumbnailData})
      : super(key: key);

  @override
  State<VideoPreviewPage> createState() => _VideoPreviewPageState();
}

class _VideoPreviewPageState extends State<VideoPreviewPage> {
  final textcaptionController = TextEditingController();
  FocusNode focusNodeText = FocusNode();
  int _selectedChipIndex = -1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        focusNodeText.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Preview'),
          scrolledUnderElevation: 0,
          backgroundColor: AppColors.backgroundLight,
          foregroundColor: AppColors.backgroundDark,
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: Sizes.lg,
                  ),
                  renderHeader(),
                  const SizedBox(
                    height: Sizes.lg,
                  ),
                  Container(
                      padding: const EdgeInsets.all(Sizes.sm),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 233, 237, 243),
                          borderRadius: BorderRadius.circular(Sizes.lg)),
                      child: const Text('# Category')),

                  renderSpacer(),
                  GestureDetector(
                    onTap: () {
                      _showChipSelectionBottomSheet();
                    },
                    child: const Row(
                      children: [Icon(Icons.add), Text('Add a category')],
                    ),
                  ),
                  // const Spacer(),

                  const SizedBox(height: Sizes.xl),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: renderPostButton(),
        ),
      ),
    );
  }

  Widget renderSpacer() {
    return GestureDetector(
      child: const Column(
        children: [
          SizedBox(
            height: Sizes.lg,
          ),
          Divider(
            color: AppColors.neutralColor,
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  SizedBox renderPostButton() {
    return SizedBox(
      width: 100.w,
      child: ElevatedButton.icon(
        icon: const Icon(
          CupertinoIcons.arrow_up,
          color: Colors.white,
          size: 20,
        ),
        label: const Text("Post"),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        onPressed: () {
          debugPrint("Post button clicked");
        },
      ),
    );
  }

  Widget renderHeader() {
    return SizedBox(
      width: 100.w,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextField(
              controller: textcaptionController,
              focusNode: focusNodeText,
              style: AppTextTheme.lightTextTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w400),
              keyboardType: TextInputType.multiline,
              maxLines: 4,
              onChanged: (value) {},
              // maxLength: 100,
              decoration: const InputDecoration(
                  hintText: 'Add a catchy title',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.all(0),
                  helperStyle: TextStyle(color: AppColors.secondaryColor),
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  hintStyle: TextStyle(color: AppColors.neutralDark)),
            ),
          ),
          const SizedBox(
            width: Sizes.md,
          ),
          Expanded(
              flex: 2,
              child: widget.thumbnailData == null
                  ? GestureDetector(
                      onTap: () {
                        HelpersUtils.navigatorState(context).pushNamed(
                            AppPage.previewVideo,
                            arguments: widget.videoPath);
                      },
                      child: VideoPlayerWidget(videoPath: widget.videoPath))
                  : GestureDetector(
                      onTap: () {
                        HelpersUtils.navigatorState(context).pushNamed(
                            AppPage.previewVideo,
                            arguments: widget.videoPath);
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  Sizes.md), // Border radius on the container
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.2), // Shadow color
                                  blurRadius: 1, // How blurry the shadow is
                                  offset: const Offset(
                                      0, 0.5), // Position of the shadow
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(Sizes
                                  .sm), // Border radius on the image itself
                              child: Image.memory(
                                widget.thumbnailData!,
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            bottom: 0,
                            left: 40,
                            right: 40,
                            child: Container(
                              width:
                                  10, // Width and height of the container (double the icon size for circular effect)
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(
                                    0.3), // Background color (you can change it to any color you prefer)
                                shape: BoxShape
                                    .circle, // Makes the container circular
                              ),
                              child: const Icon(
                                Icons.play_arrow,
                                size: Sizes.iconXl,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Text(
                              'Preview',
                              style: TextStyle(
                                color: AppColors.backgroundLight,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.7),
                                    offset: const Offset(1, 1),
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ))),
        ],
      ),
    );
  }

  void _showChipSelectionBottomSheet() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      isDismissible: true,
      elevation: 0,
      enableDrag: true,
      backgroundColor: AppColors.backgroundLight,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.5,
          expand: false,
          snap: false,
          builder: (context, scrollController) {
            return renderChipItem(context, scrollController);
          },
        );
      },
    );
  }

  Widget renderChipItem(
      BuildContext context, ScrollController scrollController) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.lg),
            child: Text(
              "Category",
              style: AppTextTheme.lightTextTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: List.generate(
                    chipLabels.length,
                    (index) => ChoiceChip(
                      padding: const EdgeInsets.all(0),
                      backgroundColor: AppColors.backgroundLight,
                      avatarBorder: Border.all(width: 0),
                      checkmarkColor: AppColors.primaryColor,
                      labelStyle: TextStyle(
                        color: _selectedChipIndex == index
                            ? AppColors.primaryColor
                            : AppColors.backgroundDark,
                      ),
                      label: Text(chipLabels[index]),
                      selected: _selectedChipIndex == index,
                      side: const BorderSide(width: 0),
                      onSelected: (isSelected) {
                        setState(() {
                          _selectedChipIndex = isSelected ? index : -1;
                        });
                        // ref
                        //     .read(postMediaControllerProvider.notifier)
                        //     .updateTag(chipLabels[index]);
                        HelpersUtils.navigatorState(context).pop();
                      },
                    ),
                  ).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;

  const VideoPlayerWidget({Key? key, required this.videoPath})
      : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {});
        // _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container(
          height: 180,
          width: 180,
          color: AppColors.backgroundDark,
          child: const Center(child: CircularProgressIndicator()));
    }

    return Stack(
      children: [
        Positioned(
          top: 0,
          child: Container(
            height: 180,
            width: 180,

            color: AppColors.neutralBlack,
            // clipBehavior: Clip.hardEdge,
            // color: AppColors.backgroundDark,
          ),
        ),
        Positioned(
          child: SizedBox(
            height: 180,
            width: 180,
            // clipBehavior: Clip.hardEdge,
            // color: AppColors.backgroundDark,
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          ),
        ),
      ],
    );
  }
}
