import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:demo/common/widget/app_dialog.dart';
import 'package:demo/data/repository/firebase/video_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firebase/storage_service.dart';
import 'package:demo/data/service/firestore/video/video_service.dart';
import 'package:demo/features/home/controller/video/video_action_controller.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/constant_data.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/helpers/permission_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:demo/utils/validation/video_validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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
  bool _isInitializing = false;
  final cameraZoomMax = 8;
  final cameraZoomMin = 0.5;
  final zoomScaleFactor = 0.1;
  double previousZoomValue = 1;
  double currentZoomValue = 1;
  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted) {
      bool isScreenActive = ModalRoute.of(context)?.isCurrent ?? false;
      if (!isScreenActive) {
        if (_isRecording) {
          // _stopRecording();
          if (_timer?.isActive == true) {
            _timer?.cancel();
          }
          setState(() {
            _isRecording = false;
            _recordDuration = 0;
          });
        }
        if (_controller != null && _controller!.value.isInitialized) {
          try {
            _controller!.dispose();
            _controller = null;
          } catch (e) {
            debugPrint("Error disposing camera: $e");
          }
        }
      } else {
        _initializeCamera();
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || !_controller!.value.isInitialized) return;

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      if (_isRecording) {
        // _stopRecording();
        if (_timer?.isActive == true) {
          _timer?.cancel();
        }
        setState(() {
          _isRecording = false;
          _recordDuration = 0;
        });
      }
    }
    if (state == AppLifecycleState.resumed) {
      setState(() {
        _initializeCamera();
      });
    }
  }

  Future<void> _checkCameraPermission() async {
    final status = await Permission.camera.status;
    final audioStatus = await Permission.microphone.status;

    if (status.isGranted && audioStatus.isGranted) {
      _initializeCamera();
      return;
    }

    if (!status.isGranted) {
      final newStatus = await Permission.camera.request();
      if (!newStatus.isGranted) {
        _showPermissionDialog();
        return;
      }
    }

    if (!audioStatus.isGranted) {
      final newAudioStatus = await Permission.microphone.request();
      if (!newAudioStatus.isGranted) {
        _showPermissionDialog(
            title: 'Microphone permission',
            desc: 'Please open your microphone setting');
        return;
      }
    }

    if (await Permission.camera.isGranted &&
        await Permission.microphone.isGranted) {
      setState(() {});

      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          _initializeCamera();
        },
      );
    }
  }

  void _showPermissionDialog({String? title, String? desc}) {
    PermissionUtils.showPermissionDialog(context, title ?? 'Camera Permission',
            desc ?? 'Please open your camera setting', true)
        .then(
      (value) {
        if (mounted) {
          HelpersUtils.navigatorState(context).pop();
        }
      },
    );
  }

  Future<void> _initializeCamera() async {
    try {
      if (_isInitializing) return;
      _isInitializing = true;

      _cameras = await availableCameras();

      if (_cameras.isNotEmpty) {
        _controller = CameraController(
          enableAudio: true,
          fps: 30,
          _isFrontCamera ? _cameras[1] : _cameras[0],
          ResolutionPreset.high,
        );

        await _controller?.initialize();
        await _controller?.prepareForVideoRecording();

        if (mounted) setState(() {});
      }
      _isInitializing = false;
    } catch (e) {
      // _showPermissionDialog(title: 'Permission', desc: e.toString());

      // Fluttertoast.showToast(msg: e.toString());
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
      await _controller?.dispose();
      _isFrontCamera = !_isFrontCamera;
      await _initializeCamera();
    }
  }

  void _startRecording() async {
    if (_controller == null ||
        _isRecording ||
        _timer != null && _timer!.isActive) {
      return;
    }

    try {
      await _controller!.prepareForVideoRecording();
      await _controller!.startVideoRecording();

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_recordDuration >= 60) {
          _stopRecording();
        } else {
          setState(() => _recordDuration++);
        }
      });
    } catch (e) {
      debugPrint("Error starting recording: $e");
    } finally {
      setState(() => _isRecording = !_isRecording);
    }
  }

  void _stopRecording() async {
    if (_controller == null || !_isRecording || _recordDuration <= 0) return;
    _timer?.cancel();
    _recordDuration = 0;

    try {
      final file = await _controller!.stopVideoRecording();
      _controller?.prepareForVideoRecording();
      final thumbnailString = await HelpersUtils.generateThumbnail(file.path);
      File videoFile = File(file.path);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPreviewPage(
              videoPath: file.path,
              videoFile: videoFile,
              thumbnailData: thumbnailString!['data'],
            ),
          ),
        ).whenComplete(
          () async {},
        );
      }
    } catch (e) {
      debugPrint("Error stopping recording: $e");
    }

    setState(() => _isRecording = false);
  }

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(seconds: 60),
    );
    if (pickedFile != null && mounted) {
      debugPrint("Image picked: ${pickedFile.path}");
      final thumbnailString =
          await HelpersUtils.generateThumbnail(pickedFile.path);

      File videoFile = File(pickedFile.path);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPreviewPage(
              videoPath: pickedFile.path,
              videoFile: videoFile,
              thumbnailData: thumbnailString!['data'],
            ),
          ),
        ).whenComplete(
          () {},
        );
      }
      // HelpersUtils.navigatorState(context)
      //     .pushNamed(AppPage.previewVideo, arguments: pickedFile.path);
    }
  }

  void _dispose() {
    _controller?.stopVideoRecording();
    _controller?.dispose();

    _timer?.cancel();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _dispose();
    super.dispose();
  }

  double _currentZoomLevel = 1.0;

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Container(
        decoration: const BoxDecoration(color: AppColors.backgroundDark),
      );
    }

    Matrix4 cameraTransform =
        _isFrontCamera ? Matrix4.rotationY(3.14159) : Matrix4.identity();

    return GestureDetector(
      onScaleUpdate: (details) async {
        if (_controller != null) {
          var maxZoomLevel = await _controller!.getMaxZoomLevel();
          var minZoomLevel = 1.0;

          var dragIntensity = details.scale;

          if (_currentZoomLevel < maxZoomLevel && dragIntensity > 1) {
            _currentZoomLevel =
                (_currentZoomLevel + 0.1).clamp(minZoomLevel, maxZoomLevel);
          } else if (_currentZoomLevel > minZoomLevel && dragIntensity < 1) {
            _currentZoomLevel =
                (_currentZoomLevel - 0.1).clamp(minZoomLevel, maxZoomLevel);
          }

          if (_currentZoomLevel == maxZoomLevel && dragIntensity > 1) {
            return; // Do nothing if at max zoom level
          }

          _controller!.setZoomLevel(_currentZoomLevel);

          debugPrint('Current Zoom Level: $_currentZoomLevel');
        }
      },
      child: AspectRatio(
        aspectRatio: .56,
        child: Stack(
          children: [
            Transform(
              transform: cameraTransform,
              alignment: Alignment.center,
              child: CameraPreview(_controller!),
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
                  // onLongPress: _startRecording,
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
                    onPressed: _pickVideo,
                  ),
                ),
              ),
            if (_isRecording)
              Positioned(
                bottom: 20,
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
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String formatDuration(int durationInSeconds) {
    return '${(durationInSeconds ~/ 60).toString().padLeft(2, '0')}:${(durationInSeconds % 60).toString().padLeft(2, '0')}';
  }

  Widget buildCameraPreview() {
    return AspectRatio(
      aspectRatio: 9 / 16,
      child: CameraPreview(_controller!),
    );
  }
}

class VideoPreviewPage extends ConsumerStatefulWidget {
  final String videoPath;
  final File videoFile;
  final Uint8List? thumbnailData;
  VideoPreviewPage(
      {Key? key,
      required this.videoPath,
      this.thumbnailData,
      required this.videoFile})
      : super(key: key);

  @override
  ConsumerState<VideoPreviewPage> createState() => _VideoPreviewPageState();
}

class _VideoPreviewPageState extends ConsumerState<VideoPreviewPage> {
  final textcaptionController = TextEditingController();
  FocusNode focusNodeText = FocusNode();
  File? previewImage;

  final Map<int, String> _selectedChipIndices = {};
  late VideoUserActionController videoUserActionController;
  @override
  void initState() {
    videoUserActionController = VideoUserActionController(
        ref: ref,
        videoRepository: VideoRepository(
            videoService:
                VideoService(firebaseAuthService: FirebaseAuthService())),
        storageService: StorageService());
    super.initState();
  }

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
                  if (_selectedChipIndices.isNotEmpty)
                    Wrap(
                      spacing: Sizes.sm,
                      runSpacing: Sizes.sm,
                      children: _selectedChipIndices.entries.map((entry) {
                        return Container(
                            padding: const EdgeInsets.all(Sizes.sm),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 233, 237, 243),
                                borderRadius: BorderRadius.circular(Sizes.lg)),
                            child: Text(entry.value));
                      }).toList(),
                    ),

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
        onPressed: () async {
          File? thumbnail;
          String caption = textcaptionController.text.trim();
          if (previewImage == null) {
            final thumbnailFile = widget.thumbnailData;
            if (thumbnailFile != null) {
              thumbnail = await saveThumbnail(thumbnailFile);
            }
          } else {
            thumbnail = previewImage;
          }
          List<String> tags = _selectedChipIndices.values.toList();
          final messageValidation = VideoValidationHelper.validateUploadFields(
              widget.videoFile, thumbnail, caption, tags);
          if (messageValidation != null) {
            if (mounted) {
              showDialog(
                  context: context,
                  builder: (context) => AppALertDialog(
                      bgColor: AppColors.backgroundLight,
                      textColor: AppColors.errorColor,
                      contentColor: AppColors.backgroundDark,
                      onConfirm: () {},
                      title: 'Missing Field',
                      desc: messageValidation));
            }

            return;
          }

          if (thumbnail != null) {
            await videoUserActionController.uploadVideo(
              videoFile: widget.videoFile,
              thumbnailFile: thumbnail,
              caption: caption,
              tags: tags,
            );
          } else {
            Fluttertoast.showToast(msg: "Video or Thumbnail is missing!");
          }
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
                              borderRadius: BorderRadius.circular(Sizes.md),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 1,
                                  offset: const Offset(0, 0.5),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(Sizes.sm),
                              child: previewImage != null
                                  ? Image.file(
                                      previewImage!,
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.memory(
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
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                shape: BoxShape.circle,
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
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                _pickImage();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: AppColors.backgroundDark
                                        .withOpacity(0.5)),
                                child: Text(
                                  'Edit Cover',
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
                            ),
                          ),
                        ],
                      ))),
        ],
      ),
    );
  }

  Future<File?> saveThumbnail(Uint8List? thumbnailData) async {
    if (thumbnailData == null) {
      return null;
    }

    final directory = await getTemporaryDirectory();

    final file = File('${directory.path}/thumbnail.png');

    await file.writeAsBytes(thumbnailData);

    return file;
  }

  Future<void> _pickImage() async {
    File? fileImage = await HelpersUtils.pickImage(ImageSource.gallery);
    if (fileImage != null) {
      File? compressImage =
          await HelpersUtils.cropAndCompressImage(fileImage.path);
      if (compressImage != null) {
        debugPrint("Compress image");
        if (mounted) {
          setState(() {
            previewImage = compressImage;
          });
        }
      }
    }
  }

  void _showChipSelectionBottomSheet() {
    setState(() {});
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
            return ChipSelectionBottomSheet(
                chipLabels: chipLabels,
                key: UniqueKey(),
                selectedChipIndices: _selectedChipIndices);
          },
        );
      },
    ).then(
      (value) {
        setState(() {});
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
                        color: _selectedChipIndices.containsKey(index)
                            ? AppColors.primaryColor
                            : AppColors.backgroundDark,
                      ),
                      label: Text(chipLabels[index]),
                      selected: _selectedChipIndices.containsKey(index),
                      side: const BorderSide(width: 0),
                      onSelected: (isSelected) {
                        setState(() {
                          if (isSelected) {
                            _selectedChipIndices[index] = chipLabels[index];
                          } else {
                            _selectedChipIndices.remove(index);
                          }
                        });

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

class ChipSelectionBottomSheet extends StatefulWidget {
  final List<String> chipLabels;
  late Map<int, String> selectedChipIndices;

  ChipSelectionBottomSheet({
    Key? key,
    required this.chipLabels,
    required this.selectedChipIndices,
  }) : super(key: key);

  @override
  _ChipSelectionBottomSheetState createState() =>
      _ChipSelectionBottomSheetState();
}

class _ChipSelectionBottomSheetState extends State<ChipSelectionBottomSheet> {
  late Map<int, String> _selectedChipIndices;

  @override
  void initState() {
    setState(() {
      _selectedChipIndices = widget.selectedChipIndices;
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.lg),
              child: Text(
                "Category",
                style: AppTextTheme.lightTextTheme.headlineSmall,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            spacing: 10,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: List.generate(
              widget.chipLabels.length,
              (index) => ChoiceChip(
                padding: const EdgeInsets.all(0),
                backgroundColor: AppColors.backgroundLight,
                avatarBorder: Border.all(width: 0),
                checkmarkColor: AppColors.primaryColor,
                labelStyle: TextStyle(
                  color: widget.selectedChipIndices.containsKey(index)
                      ? AppColors.primaryColor
                      : AppColors.backgroundDark,
                ),
                label: Text(widget.chipLabels[index]),
                selected: widget.selectedChipIndices.containsKey(index),
                side: const BorderSide(width: 0),
                onSelected: (isSelected) {
                  setState(() {
                    if (isSelected) {
                      _selectedChipIndices[index] = widget.chipLabels[index];
                    } else {
                      _selectedChipIndices.remove(index);
                    }
                  });
                },
              ),
            ).toList(),
          ),
        ),
      ],
    );
  }
}
