import 'dart:async';
import 'dart:io';
import 'package:demo/common/widget/app_dialog.dart';
import 'package:demo/common/widget/backdrop_loading.dart';
import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/features/home/controller/posts/post_media_controller.dart';
import 'package:demo/features/home/controller/profile/profile_user_controller.dart';
import 'package:demo/features/home/model/post.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/exception/app_exception.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sizer/sizer.dart';

class UploadMediaPost extends ConsumerStatefulWidget {
  const UploadMediaPost({super.key});

  @override
  ConsumerState<UploadMediaPost> createState() => _UploadMediaPostState();
}

class _UploadMediaPostState extends ConsumerState<UploadMediaPost> {
  late FocusNode focusNodeText;
  int _selectedChipIndex = -1;
  UserData? user;
  bool showErrorBorder = false;
  File? previewImages;
  late AudioPlayer playAudioUpload;
  final textcaptionController = TextEditingController();
  final List<String> chipLabels = [
    "Event",
    "Gym",
    "Workout",
    "Fun",
    "Activity",
    "Engagement",
    "Creative",
    "Outdoor",
    "Normal",
    "Travel",
    "Food",
    "Lifestyle",
    "Entertainment",
    "Selfie",
    "Fashion",
    "Beauty",
    "Photography",
    "Pets",
    "Music",
    "Sports",
    "Gaming",
    "Motivation",
    "Fitness",
    "Technology",
    "Health",
    "Education",
    "Business",
    "Family",
    "Friends",
    "Relationship",
    "Trending",
    "Challenge",
    "Meme",
    "Inspiration",
    "Vlog",
    "Nature",
    "Art",
    "Shopping",
    "Celebration",
    "News",
    "Random",
  ];

  @override
  void initState() {
    focusNodeText = FocusNode();
    playAudioUpload = AudioPlayer();
    forceFocus();
    bindingAudio();
    bindingData();
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
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.8,
          expand: false,
          snap: true,
          builder: (context, scrollController) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_selectedChipIndex != -1) {
                double offset = _selectedChipIndex * 10.0;
                scrollController.animateTo(
                  offset,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            });
            return renderChipItem(context, scrollController);
          },
        );
      },
    );
  }

  Widget renderChipItem(
      BuildContext context, ScrollController scrollController) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.lg),
      decoration: const BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Category",
            style: AppTextTheme.lightTextTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
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
                      ref
                          .read(postMediaControllerProvider.notifier)
                          .updateTag(chipLabels[index]);
                      HelpersUtils.navigatorState(context).pop();
                    },
                  ),
                ).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(appLoadingStateProvider);
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
            appBar: renderAppBar(context),
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SafeArea(
                  child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.manual,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.xxl, vertical: Sizes.lg),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: user?.avatar != ""
                                ? FancyShimmerImage(
                                    imageUrl: user!.avatar!,
                                    width: 60,
                                    height: 60,
                                    boxFit: BoxFit.cover,
                                  )
                                : Container(
                                    child: Assets.app.defaultAvatar.image(
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover),
                                  ),
                          ),
                          const SizedBox(
                            width: Sizes.sm,
                          ),
                          renderProfileStatus(),
                        ],
                      ),
                      const SizedBox(
                        height: Sizes.xs,
                      ),
                      TextField(
                        controller: textcaptionController,
                        focusNode: focusNodeText,
                        style: AppTextTheme.lightTextTheme.bodyLarge
                            ?.copyWith(fontWeight: FontWeight.w400),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        onChanged: (value) {
                          ref
                              .read(postMediaControllerProvider.notifier)
                              .updateText(value?.trim());
                        },
                        maxLength: 200,
                        decoration: const InputDecoration(
                            hintText: 'What’s on your mind?',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.all(0),
                            helperStyle:
                                TextStyle(color: AppColors.secondaryColor),
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            hintStyle: TextStyle(color: AppColors.neutralDark)),
                      ),
                      const SizedBox(
                        height: Sizes.md,
                      ),
                      if (previewImages != null)
                        Image.file(
                          previewImages!,
                          width: 100.w,
                          height: 400,
                          fit: BoxFit.cover,
                        )
                    ],
                  ),
                ),
              )),
            ),
          ),
          if (loading) backDropLoading()
        ],
      ),
    );
  }

  PreferredSizeWidget renderAppBar(BuildContext context) {
    final tag = ref.watch(postMediaControllerProvider).tag;
    return AppBar(
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
                onPressed: () {
                  handleSubmit(tag);
                },
                child: const Text('Post')),
          )
        ],
        title: Text(
          'Create Post',
          style: AppTextTheme.lightTextTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.w500),
        ));
  }

  Widget renderProfileStatus() {
    final userStatus = ref.watch(postMediaControllerProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        userStatus.emoji != null
            ? RichText(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400, color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                      text: '${user?.fullName}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const TextSpan(
                      text: ' is ',
                    ),
                    TextSpan(
                      text: '${userStatus.emoji} feeling ',
                      style: const TextStyle(),
                    ),
                    TextSpan(
                      text: '${userStatus.feeling}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              )
            : RichText(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  style: AppTextTheme.lightTextTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w400, color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                      text: '${user?.fullName} ',
                      style: const TextStyle(fontWeight: FontWeight.w500),
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
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Row(
                  children: [
                    const Icon(
                      Icons.arrow_drop_down,
                      size: Sizes.lg,
                      color: AppColors.backgroundLight,
                    ),
                    Text(
                      userStatus.tag ?? 'Select Category',
                      style: const TextStyle(
                          color: AppColors.backgroundLight, fontSize: 8),
                    ),
                    const SizedBox(
                      width: Sizes.sm,
                    )
                  ],
                ),
              )),
        )
      ],
    );
  }

  void bindingAudio() async {
    await playAudioUpload.setAsset(Assets.audio.uploadSound);
    playAudioUpload.setVolume(1);
  }

  void playAudio() {
    playAudioUpload.seek(const Duration(seconds: 0));
    playAudioUpload.play();
  }

  void bindingData() async {
    final asyncValues = await ref.read(profileUserControllerProvider.future);
    if (asyncValues != null) {
      final firstName = asyncValues.fullname?.split(' ')[0] ?? "";
      final nameParts = asyncValues.fullname?.split(' ') ?? [];
      final lastName =
          nameParts.length > 1 ? nameParts.sublist(1).join(' ') : "";
      user = UserData(
          fullName: "$firstName $lastName",
          id: FirebaseAuth.instance.currentUser!.uid,
          avatar: asyncValues.avatar);
    }
    setState(() {});
  }

  void _uploadingImage(UploadType type) async {
    try {
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
                previewImages = compressImage;
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
    await Future.delayed(const Duration(milliseconds: 300));
    focusNodeText.requestFocus();
  }

  void handleSubmit(String? tag) async {
    if (textcaptionController.text.isNotEmpty && tag != null) {
      ref.read(appLoadingStateProvider.notifier).setState(true);
      await ref
          .read(postMediaControllerProvider.notifier)
          .handlePost(previewImages);

      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Fluttertoast.showToast(
              msg: "Successfully Posted !!!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2,
              backgroundColor: AppColors.secondaryColor,
              textColor: Colors.white,
              fontSize: 16.0);
          ref.read(appLoadingStateProvider.notifier).setState(false);
          playAudio();
          HelpersUtils.navigatorState(context).pop();
          HelpersUtils.navigatorState(context).pop();
        }
      });

      Timer(const Duration(seconds: 2), () {
        playAudioUpload.dispose();
        debugPrint("Audio has been dispose");
      });
    } else {
      validationError(context, tag);
    }
  }

  void validationError(
    BuildContext context,
    String? tag,
  ) {
    String title = "";
    String desc = "";
    if (tag == null) {
      title = 'Category is missing';
      desc = "Please don't leave your tag in empty because it is required !!!";
    } else {
      title = 'Caption is missing';
      desc =
          "Please don't leave your caption in empty because it is required !!!";
      setState(() {
        showErrorBorder = true;
      });
    }

    showDialog(
        context: context,
        builder: (context) => AppALertDialog(
            bgColor: AppColors.backgroundLight,
            showIcon: false,
            onConfirm: () {},
            contentColor: AppColors.backgroundDark,
            textColor: AppColors.backgroundDark,
            title: title,
            desc: desc));
  }
}
