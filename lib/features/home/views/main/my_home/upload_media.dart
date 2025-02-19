import 'dart:io';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/device/device_utils.dart';
import 'package:demo/utils/exception/app_exception.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class UploadMediaPost extends StatefulWidget {
  const UploadMediaPost({super.key});

  @override
  State<UploadMediaPost> createState() => _UploadMediaPostState();
}

class _UploadMediaPostState extends State<UploadMediaPost> {
  late FocusNode focusNodeText;
  int _selectedChipIndex = -1;
  final List<String> chipLabels = [
    "Event",
    "Gym",
    "Workout",
    "Fun",
    "Activity",
    "Engagement",
    "Creative",
    "Outdoor",
    "Normal"
  ];
  @override
  void initState() {
    focusNodeText = FocusNode();
    forceFocus();
    super.initState();
  }

  @override
  void dispose() {
    focusNodeText.dispose();
    super.dispose();
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
      // barrierColor: AppColors.secondaryColor,

      builder: (BuildContext context) {
        return renderChipItem(context);
      },
    );
  }

  Widget renderChipItem(BuildContext context) {
    return SizedBox(
      width: 100.w,
      height: 30.h,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Category",
              style: AppTextTheme.lightTextTheme.headlineSmall,
            ),
            Column(
              // mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 10,
                    alignment: WrapAlignment.center,
                    children: List.generate(
                      chipLabels.length,
                      (index) => ChoiceChip(
                        backgroundColor: AppColors.backgroundLight,
                        avatarBorder: Border.all(width: 0),
                        checkmarkColor: AppColors.primaryColor,
                        labelStyle: TextStyle(
                            color: _selectedChipIndex == index
                                ? AppColors.primaryColor
                                : AppColors.backgroundDark),
                        label: Text(chipLabels[index]),
                        selected: _selectedChipIndex == index,
                        side: BorderSide(width: 0),
                        onSelected: (isSelected) {
                          setState(() {
                            _selectedChipIndex = isSelected ? index : -1;
                          });
                          HelpersUtils.navigatorState(context).pop();
                        },
                      ),
                    ).toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        FocusScope.of(context).unfocus();
        final navigator = Navigator.of(context);
        navigator.pop(result);
      },
      child: Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: false,
            bottomSheet: renderBottomSheet(context),
            appBar: AppBar(
                centerTitle: false,
                backgroundColor: AppColors.backgroundLight,
                foregroundColor: AppColors.backgroundDark,
                leading: Padding(
                  padding: const EdgeInsets.only(left: Sizes.lg),
                  child: GestureDetector(
                    onTap: () async {
                      HelpersUtils.navigatorState(context).pop();
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      // size: 20,
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Sizes.xxl),
                    child: FilledButton(
                        style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Sizes.xxxl, vertical: 0),
                            backgroundColor: AppColors.secondaryColor),
                        onPressed: () {},
                        child: const Text('Post')),
                  )
                ],
                title: Text(
                  'Create Post',
                  style: AppTextTheme.lightTextTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w500),
                )),
            body: SafeArea(
                child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(Sizes.xl),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: Container(
                            child: Assets.app.defaultAvatar.image(
                                width: 60, height: 60, fit: BoxFit.cover),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              maxLines: 2, // Limits the text to 2 lines
                              overflow:
                                  TextOverflow.ellipsis, // Handles overflow
                              text: TextSpan(
                                style: AppTextTheme.lightTextTheme.bodyLarge
                                    ?.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black), // Default style
                                children: const <TextSpan>[
                                  TextSpan(
                                    text: 'Panhavorn ', // Plain text
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  TextSpan(
                                    text: 'is feeling ', // Plain text
                                  ),
                                  TextSpan(
                                    text: '😵 ', // Emoji with default style
                                    style: TextStyle(), // Increase emoji size
                                  ),
                                  TextSpan(
                                    text: 'crazy',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: Sizes.xs,
                            ),
                            GestureDetector(
                              onTap: _showChipSelectionBottomSheet,
                              child: Material(
                                  borderRadius: BorderRadius.circular(Sizes.lg),
                                  color: AppColors.secondaryColor,
                                  child: const Padding(
                                    padding: EdgeInsets.all(7),
                                    child: Text(
                                      'Select Category',
                                      style: TextStyle(
                                          color: AppColors.backgroundLight,
                                          fontSize: 8),
                                    ),
                                  )),
                            )
                          ],
                        ),
                      ],
                    ),
                    TextField(
                      focusNode: focusNodeText,
                      style: AppTextTheme.lightTextTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w400),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      maxLength: 200,
                      decoration: const InputDecoration(
                          hintText: 'What’s on your mind?',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          helperStyle:
                              TextStyle(color: AppColors.secondaryColor),
                          enabledBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          hintStyle: TextStyle(color: AppColors.neutralDark)),
                    ),
                    Assets.app.catGym.image(
                      width: 100.w,
                      height: 400,
                    ),
                  ],
                ),
              ),
            )),
          ),
        ],
      ),
    );
  }

  void _uploadingImage(UploadType type) async {
    try {
      // ref.read(appLoadingStateProvider.notifier).setState(true);

      File? fileImage = await HelpersUtils.pickImage(
          type == UploadType.photo ? ImageSource.gallery : ImageSource.camera);
      if (fileImage != null) {
        File? compressImage =
            await HelpersUtils.cropAndCompressImage(fileImage.path);
        if (compressImage != null) {
          debugPrint("Compress image");

          WidgetsBinding.instance.addPostFrameCallback(
            (timeStamp) {
              setState(() {
                // previewImages = compressImage;
              });
            },
          );
        }
      }
    } catch (e) {
      if (mounted && e is AppException) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        HelpersUtils.showErrorSnackbar(
            duration: 3000, context, 'Oop!', e.message, StatusSnackbar.failed);
      }
    } finally {
      // ref.read(appLoadingStateProvider.notifier).setState(false);
    }
  }

  Widget renderBottomSheet(BuildContext context) {
    return Material(
      color: const Color.fromARGB(255, 244, 246, 249),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(Sizes.lg),
        child: SizedBox(
          height: 4.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  splashColor: AppColors.warningColor,
                  style: IconButton.styleFrom(
                      overlayColor: AppColors.warningColor),
                  onPressed: () {
                    HelpersUtils.navigatorState(context)
                        .pushNamed(AppPage.feelingListing);
                  },
                  icon: SvgPicture.asset(
                    Assets.icon.svg.feeling,
                    width: 30,
                    height: 30,
                  )),
              IconButton(
                  splashColor: AppColors.warningColor,
                  style: IconButton.styleFrom(
                      overlayColor: AppColors.successColor),
                  onPressed: () {
                    _uploadingImage(UploadType.photo);
                  },
                  icon: SvgPicture.asset(
                    Assets.icon.svg.photo,
                    width: 30,
                    height: 30,
                  )),
              IconButton(
                  splashColor: AppColors.primaryColor,
                  style: IconButton.styleFrom(
                      overlayColor: AppColors.primaryColor),
                  onPressed: () {
                    _uploadingImage(UploadType.camera);
                  },
                  icon: SvgPicture.asset(
                    Assets.icon.svg.camera,
                    width: 30,
                    height: 40,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void forceFocus() async {
    await Future.delayed(Duration(milliseconds: 300));
    focusNodeText.requestFocus();
  }
}
