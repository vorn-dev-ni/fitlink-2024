import 'dart:io';
import 'package:demo/common/model/user_model.dart';
import 'package:demo/common/widget/app_bar_custom.dart';
import 'package:demo/common/widget/app_input.dart';
import 'package:demo/common/widget/backdrop_loading.dart';
import 'package:demo/common/widget/bottom_upload_sheet.dart';
import 'package:demo/common/widget/error_image_placeholder.dart';
import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/features/authentication/controller/auth_controller.dart';
import 'package:demo/features/home/controller/event/event_detail_participant.dart';
import 'package:demo/features/home/controller/profile/profile_user_controller.dart';
import 'package:demo/features/home/controller/profile/user_form_controller.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/device/device_utils.dart';
import 'package:demo/utils/exception/app_exception.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:demo/utils/validation/profile_edit_validation.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EditProfile extends ConsumerStatefulWidget {
  const EditProfile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  AuthModel? currentUser;
  late AudioPlayer playAudioUpload;
  late final AuthController authController;
  final _formkey = GlobalKey<FormState>();
  late TextEditingController textFirstName;
  File? previewImages;
  String? userAvatar;
  bool isLoading = true;
  late TextEditingController textLastName;
  late TextEditingController textBio;
  @override
  void initState() {
    if (mounted) {
      playAudioUpload = AudioPlayer();
      authController = AuthController(ref: ref);
      textFirstName = TextEditingController();
      textLastName = TextEditingController();
      textBio = TextEditingController();
      bindingData();
      Future.delayed(const Duration(milliseconds: 1200), () {
        bindingProfileState();
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void bindingProfileState() async {
    try {
      final asyncValues = await ref.read(profileUserControllerProvider.future);
      if (asyncValues != null) {
        currentUser = asyncValues;
      } else {
        currentUser = null;
      }

      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          if (mounted) {
            isLoading = false;
            setState(() {});
          }
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLoading = ref.watch(appLoadingStateProvider);
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            DeviceUtils.hideKeyboard(context);
          },
          child: Scaffold(
            appBar: AppBarCustom(
                text: 'Edit Profile',
                foregroundColor: AppColors.secondaryColor,
                leading: isLoading
                    ? null
                    : TextButton.icon(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          splashFactory: NoSplash.splashFactory,
                        ),
                        iconAlignment: IconAlignment.end,
                        onPressed: () async {
                          await _handleSubmit();
                        },
                        icon: const Icon(
                          Icons.check,
                          size: Sizes.iconSm,
                          color: AppColors.secondaryColor,
                        ),
                        label: Text(
                          'Save',
                          style: AppTextTheme.lightTextTheme.bodyMedium
                              ?.copyWith(color: AppColors.secondaryColor),
                        ),
                      ),
                bgColor: AppColors.backgroundLight,
                showheader: false),
            body: SafeArea(
              child: Skeletonizer(
                enabled: isLoading,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formkey,
                    autovalidateMode: AutovalidateMode.always,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [formField()],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (appLoading) backDropLoading()
      ],
    );
  }

  Widget formField() {
    return Padding(
      padding: const EdgeInsets.all(Sizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => _openBottomSheet(context),
            child: Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 233, 235, 237),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color.fromARGB(255, 233, 235, 237),
                        width: 0,
                      ),
                    ),
                    child: ClipOval(
                        child: userAvatar == null || userAvatar == ""
                            ? previewImages == null
                                ? Assets.app.defaultAvatar.image(
                                    width: 180,
                                    height: 180,
                                  )
                                : Image.file(
                                    previewImages!,
                                    width: 180,
                                    height: 180,
                                    fit: BoxFit.cover,
                                  )
                            : previewImages == null
                                ? FancyShimmerImage(
                                    boxFit: BoxFit.cover,
                                    errorWidget: errorImgplaceholder(),
                                    width: 180,
                                    height: 180,
                                    imageUrl: userAvatar!)
                                : Image.file(
                                    previewImages!,
                                    width: 180,
                                    height: 180,
                                    fit: BoxFit.cover,
                                  )),
                  ),
                  Positioned(
                      right: 0,
                      bottom: -20,
                      left: 0,
                      child: GestureDetector(
                        onTap: () => _openBottomSheet(context),
                        child: ClipOval(
                          child: Container(
                            padding: const EdgeInsets.all(Sizes.md),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 233, 235, 237),
                                  width: 4,
                                ),
                                color: AppColors.secondaryColor),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              color: AppColors.backgroundLight,
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: Sizes.xxl,
          ),
          AppInput(
            controller: textFirstName,
            maxLength: 30,
            labelText: 'First Name',
            hintText: 'Enter your first name',
            validator: (value) {
              return ProfileEditValidation.validateFirstName(value, 30, 3);
            },
            onSaved: (value) {
              ref
                  .read(userFormControllerProvider.notifier)
                  .updateFirstName(firstName: value?.trim());
            },
          ),
          AppInput(
            controller: textLastName,
            maxLength: 30,
            labelText: 'Last Name',
            hintText: 'Enter your last name',
            validator: (value) {
              return ProfileEditValidation.validateLastName(value, 30, 3);
            },
            onSaved: (value) {
              ref
                  .read(userFormControllerProvider.notifier)
                  .updateLastName(lastName: value?.trim());
            },
          ),
          AppInput(
            controller: textBio,
            labelText: 'Bio',
            maxLength: 100,
            maxLines: 4,
            validator: (value) {
              return ProfileEditValidation.validateBio(value, 30, 5);
            },
            onSaved: (value) {
              ref
                  .read(userFormControllerProvider.notifier)
                  .updateBio(bio: value?.trim());
            },
            hintText: 'Enter your bio',
          ),
        ],
      ),
    );
  }

  void _uploadingImage(UploadType type) async {
    try {
      ref.read(appLoadingStateProvider.notifier).setState(true);

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
    } finally {
      ref.read(appLoadingStateProvider.notifier).setState(false);
    }
  }

  void _openBottomSheet(BuildContext context) async {
    DeviceUtils.hideKeyboard(context);
    final result = await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppColors.backgroundLight,
        builder: (context) {
          return BottomUploadImage(
            context,
            (type) {
              _uploadingImage(type);
            },
          );
        });
    if (result != null) {
    } else {
      debugPrint("BottomSheet dismissed without selection");
    }
  }

  Future _handleSubmit() async {
    try {
      DeviceUtils.hideKeyboard(context);
      final isValid = _formkey.currentState?.validate();

      if (isValid == true) {
        ref.read(appLoadingStateProvider.notifier).setState(true);
        _formkey.currentState!.save();
        await Future.delayed(const Duration(milliseconds: 300));
        await ref
            .read(userFormControllerProvider.notifier)
            .updateUserProfile(previewImages);

        if (mounted) {
          HelpersUtils.navigatorState(context).pop();
          ref.read(appLoadingStateProvider.notifier).setState(false);
        }

        // ref.invalidate(profileUserControllerProvider);
        ref.invalidate(eventDetailParticipantProvider);
        playAudioUpload.setVolume(0.8);
        playAudioUpload.play();
        Fluttertoast.showToast(
            msg: "Update profile successfully !!!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.successColor,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      if (mounted) {
        Fluttertoast.showToast(
            msg: e.toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.errorColor,
            textColor: Colors.white,
            fontSize: 16.0);
        ref.read(appLoadingStateProvider.notifier).setState(false);
      }
    }
  }

  void bindingData() async {
    await playAudioUpload.setAsset(Assets.audio.uploadSound);
    final asyncValues = await ref.read(profileUserControllerProvider.future);
    if (asyncValues != null) {
      ref
          .read(userFormControllerProvider.notifier)
          .updateAvatar(avatar: asyncValues.avatar ?? "");

      final firstName = asyncValues.fullname?.split(' ')[0] ?? "";
      final nameParts = asyncValues.fullname?.split(' ') ?? [];
      final lastName =
          nameParts.length > 1 ? nameParts.sublist(1).join(' ') : "";
      textFirstName.text = firstName.trim();
      textLastName.text = lastName.trim();
      textBio.text = asyncValues.bio?.trim() ?? "";
      userAvatar = asyncValues.avatar ?? "";
    }
  }
}
