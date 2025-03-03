import 'dart:io';
import 'package:demo/common/widget/app_bar_custom.dart';
import 'package:demo/common/widget/app_dialog.dart';
import 'package:demo/common/widget/app_input.dart';
import 'package:demo/common/widget/app_loading.dart';
import 'package:demo/common/widget/backdrop_loading.dart';
import 'package:demo/common/widget/bottom_upload_sheet.dart';
import 'package:demo/common/widget/button.dart';
import 'package:demo/common/widget/focus_label.dart';
import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firebase/storage_service.dart';
import 'package:demo/data/service/firestore/firestore_service.dart';
import 'package:demo/features/home/controller/event_create/event_form_controller.dart';
import 'package:demo/features/home/views/main/event/event_post/event_date_picker.dart';
import 'package:demo/features/home/views/main/event/event_post/event_label.dart';
import 'package:demo/features/home/views/main/event/event_post/event_select_map.dart';
import 'package:demo/features/home/views/main/event/event_post/event_time_picker.dart';
import 'package:demo/features/home/widget/map_display.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/device/device_utils.dart';
import 'package:demo/utils/exception/app_exception.dart';
import 'package:demo/utils/formatters/formatter_utils.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/helpers/permission_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:demo/utils/validation/event_create_validation.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class EventPosting extends ConsumerStatefulWidget {
  const EventPosting({super.key});

  @override
  ConsumerState<EventPosting> createState() => _EventPostingState();
}

class _EventPostingState extends ConsumerState<EventPosting> {
  final _formDescTitleKey = GlobalKey<FormState>();
  DateTime? selectTime;
  File? previewImages;
  File? uploadImage;
  late AudioPlayer playAudioUpload;
  String? temPath;
  bool isUploading = false;
  bool canPop = false;
  late StorageService storageService;
  final FocusNode _focusNodeTitle = FocusNode();
  final FocusNode _focusNodeDesc = FocusNode();
  final FocusNode _focusNodePrice = FocusNode();
  final FocusNode _focusNodeImage = FocusNode();
  final FocusNode _focusNodeGymName = FocusNode();
  final FocusNode _focusNodeMap = FocusNode();
  final FocusNode _focusDateTime = FocusNode();
  UserRoles? userRoles;
  late FirestoreService firestoreService;
  @override
  void initState() {
    storageService = StorageService();
    firestoreService =
        FirestoreService(firebaseAuthService: FirebaseAuthService());

    checkUserRole();

    bindingAudio();
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      _focusNodeTitle.dispose();
      _focusNodeDesc.dispose();
      _focusNodeGymName.dispose();
      _focusNodePrice.dispose();
      _focusNodeImage.dispose();
      _focusDateTime.dispose();
      _focusNodeMap.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting = ref.watch(appLoadingStateProvider);
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            DeviceUtils.hideKeyboard(context);
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: renderAppBar(),
            body: renderBody(isSubmitting),
          ),
        ),
        if (isSubmitting) backDropLoading(),
      ],
    );
  }

  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return "Select Date & Time";
    return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} "
        "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  void resetFocusScope() {
    _focusNodeTitle.unfocus();
    _focusNodeDesc.unfocus();
    _focusNodePrice.unfocus();
    _focusNodeImage.unfocus();
    _focusDateTime.unfocus();
    _focusNodeMap.unfocus();
    _focusNodeGymName.unfocus();
  }

  void showDatePickerBottomSheet(
      BuildContext context, TimeSelection timeselection) {
    DateTime? time = timeselection == TimeSelection.startTime
        ? ref.watch(eventFormControllerProvider).timeStart
        : ref.watch(eventFormControllerProvider).timeEnd;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return EventTimePicker(
          timeselection: timeselection,
          initialTime: time,
          onSaveTime: (DateTime newTime) {
            timeselection == TimeSelection.startTime
                ? ref.read(eventFormControllerProvider.notifier).updateDateTime(
                      startTime: newTime,
                    )
                : ref.read(eventFormControllerProvider.notifier).updateDateTime(
                      endTime: newTime,
                    );
          },
        );
      },
    );
  }

  AppBarCustom renderAppBar() {
    return AppBarCustom(
      text: 'Create Event',
      showheader: false,
      isCenter: false,
      trailing: IconButton(
          onPressed: () {
            bool keyboardVisible = isKeyboardVisible(context);
            DeviceUtils.hideKeyboard(context);
            if (!keyboardVisible) {
              HelpersUtils.navigatorState(context).pop();
              return;
            }
            setState(() {
              canPop = true;
            });
          },
          icon: const Icon(Icons.arrow_back_ios)),
      bgColor: AppColors.backgroundLight,
      foregroundColor: AppColors.backgroundDark,
    );
  }

  SafeArea renderBody(isSubmitting) {
    return SafeArea(
        child: Stack(
      children: [
        SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(Sizes.xl),
          child: Form(
            key: _formDescTitleKey,
            autovalidateMode: AutovalidateMode.onUnfocus,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                eventUploader(),
                eventTitleDescField(),
                eventDatePickerField(),
                eventFreeEntryField(),
                eventSelectMapField(),
              ],
            ),
          ),
        )),
        renderButton(isSubmitting),
      ],
    ));
  }

  Widget renderButton(isSubmitting) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 5,
        margin: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        child: Container(
          color: AppColors.backgroundLight,
          padding: const EdgeInsets.all(Sizes.xxl),
          child: ButtonApp(
              height: 14,
              splashColor: const Color.fromARGB(255, 207, 225, 255),
              label: "Save Changes",
              onPressed: () => _saveChanges(isSubmitting),
              radius: 0,
              textStyle: AppTextTheme.lightTextTheme.titleMedium?.copyWith(
                  color: AppColors.backgroundLight,
                  fontWeight: FontWeight.w500) as dynamic,
              color: AppColors.secondaryColor,
              textColor: Colors.white,
              elevation: 0),
        ),
      ),
    );
  }

  Widget eventUploader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        focusLabel(focusNode: _focusNodeImage),
        eventLabel(label: 'Upload Poster'),
        const SizedBox(
          height: Sizes.xl,
        ),
        isUploading ? renderUploading() : renderImageBanner(),
        const SizedBox(
          height: Sizes.xl,
        ),
      ],
    );
  }

  InkWell renderImageBanner() {
    return InkWell(
      borderRadius: BorderRadius.circular(Sizes.lg),
      onTap: () => _openBottomSheet(context),
      child: previewImages != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(Sizes.lg),
              child: Container(
                color: AppColors.neutralBlack,
                child: Image.file(
                  previewImages!,

                  fit: DeviceUtils.isAndroid() ? BoxFit.contain : BoxFit.cover,
                  width: 100.w,
                  height: 250,
                  // isAntiAlias: true,r
                  // height: 100.h,
                ),
              ),
            )
          : SizedBox(
              width: 100.w,
              height: 250,
              child: DottedBorder(
                borderType: BorderType.RRect,
                color: AppColors.secondaryColor,
                radius: const Radius.circular(Sizes.lg),
                dashPattern: const [8, 4],
                strokeWidth: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      Assets.icon.svg.cloudUp,
                      width: 50,
                      height: 50,
                      colorFilter: const ColorFilter.mode(
                          AppColors.secondaryColor, BlendMode.srcIn),
                    ),
                    const Center(
                        child: Text(
                      'Browse and upload an image',
                      style: TextStyle(color: AppColors.secondaryColor),
                    )),
                  ],
                ),
              ),
            ),
    );
  }

  Container renderUploading() {
    return Container(
        decoration: BoxDecoration(
            color: AppColors.neutralColor,
            borderRadius: BorderRadius.circular(Sizes.lg)),
        height: 250,
        child: appLoadingSpinner());
  }

  Column eventSelectMapField() {
    final address = ref.watch(eventFormControllerProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        focusLabel(focusNode: _focusNodePrice),
        focusLabel(focusNode: _focusNodeMap),
        const SizedBox(
          height: Sizes.lg,
        ),
        InkWell(
          borderRadius: BorderRadius.circular(Sizes.lg),
          onTap: navigateToMap,
          child: address.address != null
              ? AbsorbPointer(
                  child: SizedBox(
                    height: 300,
                    child: MapDisplayLocation(
                      lat: address.lat,
                      lng: address.lng,
                      key: ValueKey('${address.lat}-${address.lng}'),
                    ),
                  ),
                )
              : SizedBox(
                  height: 300,
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    color: AppColors.secondaryColor,
                    radius: const Radius.circular(Sizes.lg),
                    dashPattern: const [8, 4],
                    strokeWidth: 1,
                    child: Center(
                      child: TextButton.icon(
                          icon: const Icon(
                            Icons.map,
                            color: AppColors.secondaryColor,
                          ),
                          onPressed: navigateToMap,
                          label: Text(
                            'Choose on Map',
                            style: AppTextTheme.lightTextTheme.bodyLarge
                                ?.copyWith(
                                    color: AppColors.secondaryColor,
                                    fontWeight: FontWeight.w500),
                          )),
                    ),
                  ),
                ),
        ),
        const SizedBox(
          height: 120,
        ),
      ],
    );
  }

  Column eventFreeEntryField() {
    final isFree = ref.watch(eventFormControllerProvider).freeEntry;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        eventLabel(
          label: 'Entry Level',
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Checkbox(
              activeColor: AppColors.secondaryColor,
              focusColor: AppColors.secondaryColor,
              side: const BorderSide(color: AppColors.secondaryColor),
              value: ref.read(eventFormControllerProvider).freeEntry,
              onChanged: (value) {
                ref
                    .read(eventFormControllerProvider.notifier)
                    .updateEntryLevel(freeEntry: value, pricing: null);
              },
            ),
            const Text('Free Entry'),
          ],
        ),
        if (isFree == false)
          AppInput(
            // labelText: '',
            maxLength: 10,
            maxLines: 1,
            // focusNode: _focusNodePrice,
            keyboardType: const TextInputType.numberWithOptions(
                signed: false, decimal: true),
            validator: (value) {
              return EventCreateValidation.validatePricing(value);
            },
            onSaved: (value) {
              ref
                  .read(eventFormControllerProvider.notifier)
                  .updateEntryLevel(pricing: value);
            },

            prefixIcon: const Icon(
              Icons.attach_money,
              color: AppColors.secondaryColor,
            ),
            hintText: 'Price',
          ),
      ],
    );
  }

  Column eventDatePickerField() {
    final dangeRange = ref.watch(eventFormControllerProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        eventLabel(label: 'Event Date'),
        focusLabel(focusNode: _focusDateTime),
        const SizedBox(
          height: Sizes.lg,
        ),
        InkWell(
          borderRadius: BorderRadius.circular(Sizes.md),
          onTap: () {
            HelpersUtils.navigatorState(context).push(MaterialPageRoute(
              builder: (context) => EventDatePickerCustom(
                selectionMode: DateRangePickerSelectionMode.range,
              ),
            ));
          },
          child: Container(
            width: 100.w,
            padding: const EdgeInsets.all(Sizes.xl),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Sizes.md),
                border: Border.all(color: AppColors.neutralColor)),
            child: Row(
              children: [
                const Icon(
                  Icons.date_range,
                  color: AppColors.secondaryColor,
                ),
                const SizedBox(
                  width: Sizes.md,
                ),
                Text(
                  dangeRange.startDate != null && dangeRange.startDate != ""
                      ? '${dangeRange.startDate} - ${dangeRange.endDate}'
                      : 'Pick up Date',
                  style: AppTextTheme.lightTextTheme.bodyLarge?.copyWith(
                      // ignore: unnecessary_null_comparison
                      color: dangeRange.startDate != null &&
                              dangeRange.startDate != ""
                          ? AppColors.secondaryColor
                          : AppColors.neutralColor,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: Sizes.lg,
        ),
        SizedBox(
          width: 100.w,
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    showDatePickerBottomSheet(context, TimeSelection.startTime);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(Sizes.lg),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Sizes.md),
                        border: Border.all(color: AppColors.neutralColor)),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.alarm,
                          color: AppColors.secondaryColor,
                        ),
                        const SizedBox(
                          width: Sizes.sm,
                        ),
                        Text(
                          FormatterUtils.formatDateToDuration(ref
                                  .read(eventFormControllerProvider)
                                  .timeStart) ??
                              ' Start Time',
                          style: AppTextTheme.lightTextTheme.bodyLarge
                              ?.copyWith(
                                  color: dangeRange.timeStart != null
                                      ? AppColors.secondaryColor
                                      : AppColors.neutralColor,
                                  fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: Sizes.lg,
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    showDatePickerBottomSheet(context, TimeSelection.endTime);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(Sizes.lg),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Sizes.md),
                        border: Border.all(color: AppColors.neutralColor)),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.alarm,
                          color: AppColors.secondaryColor,
                        ),
                        const SizedBox(
                          width: Sizes.sm,
                        ),
                        Text(
                          FormatterUtils.formatDateToDuration(ref
                                  .read(eventFormControllerProvider)
                                  .timeEnd) ??
                              ' End Time',
                          style: AppTextTheme.lightTextTheme.bodyLarge
                              ?.copyWith(
                                  // ignore: unnecessary_null_comparison
                                  color: dangeRange.timeEnd != null
                                      ? AppColors.secondaryColor
                                      : AppColors.neutralColor,
                                  fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: Sizes.lg,
        ),
      ],
    );
  }

  Widget eventTitleDescField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        eventLabel(
          label: 'Event Information',
        ),
        focusLabel(focusNode: _focusNodeTitle),
        focusLabel(focusNode: _focusNodeDesc),
        AppInput(
          controller: null,
          maxLength: 30,
          labelText: 'Event Name',
          hintText: 'Name of the event',
          validator: (value) {
            return EventCreateValidation.validateTitle(value, 30, 5);
          },
          onSaved: (value) {
            ref
                .read(eventFormControllerProvider.notifier)
                .updateEventDetails(newTitle: value?.trim());
          },
        ),
        focusLabel(focusNode: _focusNodeGymName),
        AppInput(
          controller: null,
          labelText: 'Description',
          maxLength: 100,
          maxLines: 4,
          validator: (value) {
            return EventCreateValidation.validateDesc(value, 100, 5);
          },
          onSaved: (value) {
            ref
                .read(eventFormControllerProvider.notifier)
                .updateEventDetails(newDescription: value?.trim());
          },
          hintText: 'Name of the event',
        ),
        AppInput(
          controller: null,
          maxLength: 30,
          labelText: 'Establishment name',
          hintText: 'Name of your brand or gym',
          validator: (value) {
            return EventCreateValidation.validateEstablishment(value, 30, 5);
          },
          onSaved: (value) {
            ref
                .read(eventFormControllerProvider.notifier)
                .updateEventDetails(establishment: value?.trim());
          },
        ),
      ],
    );
  }

  void _uploadingImage(UploadType type) async {
    try {
      // type == UploadType.camera
      //     ? PermissionUtils.checkCameraPermission(context)
      //     : PermissionUtils.checkGalleryPermission(context);
      File? fileImage = await HelpersUtils.pickImage(
          type == UploadType.photo ? ImageSource.gallery : ImageSource.camera);
      setState(() {
        isUploading = true;
      });

      if (fileImage != null) {
        File? compressImage =
            await HelpersUtils.cropAndCompressImage(fileImage.path);
        if (compressImage != null) {
          setState(() {
            previewImages = compressImage;
            uploadImage = compressImage;
          });
        }
      }
    } catch (e) {
      if (mounted && e is AppException) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        HelpersUtils.showErrorSnackbar(
            duration: 3000, context, 'Oop!', e.message, StatusSnackbar.failed);
      }
      isUploading = false;
    } finally {
      setState(() {});
      isUploading = false;
    }
  }

  void checkUserRole() async {
    if (FirebaseAuth.instance.currentUser != null) {
      final roleString = await firestoreService.checkUserRole();
      final newRole = UserRolesExtension.fromValue(roleString);
      if (newRole == UserRoles.NORMAL) {
        if (mounted) {
          HelpersUtils.navigatorState(context).pop();
        }
        if (mounted) {
          showDialog(
              context: context,
              builder: (context) => AppALertDialog(
                  onConfirm: () {},
                  positivebutton: SizedBox(
                      width: 100.w,
                      child: FilledButton(
                          style: FilledButton.styleFrom(
                              backgroundColor: AppColors.errorColor),
                          onPressed: () {
                            HelpersUtils.navigatorState(context).pop();
                            HelpersUtils.navigatorState(context)
                                .pushNamed(AppPage.eventRequestGymTrainer);
                          },
                          child: const Text('Confirm'))),
                  title: 'Notice',
                  desc:
                      "To proceed, please submit proof that you are a gym owner or trainer. This information is required to unlock full access to the app’s features"));
        }
      }
    }
  }

  void _saveChanges(isSubmitting) async {
    try {
      String? errorMessage = "";
      ref.read(appLoadingStateProvider.notifier).setState(true);
      final isValid = _formDescTitleKey.currentState!.validate();
      if (isValid) {
        _formDescTitleKey.currentState!.save();
        errorMessage =
            ref.read(eventFormControllerProvider.notifier).validateForm();
        if (previewImages?.path == null) {
          errorMessage = "Please Provide image poster for your event.";
        }

        if (errorMessage != null) {
          showDialog(
              context: context,
              builder: (context) => AppALertDialog(
                  onConfirm: () {
                    if (errorMessage!.contains('title')) {
                      _focusNodeTitle.requestFocus();
                    }
                    if (errorMessage.contains('map location')) {
                      _focusNodeMap.requestFocus();
                    }
                    if (errorMessage.contains('price')) {
                      _focusNodePrice.requestFocus();
                    }

                    if (errorMessage.contains('time')) {
                      _focusDateTime.requestFocus();
                    }
                    if (errorMessage.contains('image')) {
                      _focusNodeImage.requestFocus();
                    }
                  },
                  title: 'Missing Information',
                  desc: errorMessage ?? "Something went wrong !!!"));

          return;
        }

        if (uploadImage?.path != null && temPath != null) {
          await storageService.deleteFile(temPath!);
        }

        String extensionWithoutFileExtension =
            HelpersUtils.getLastFileName(uploadImage!.path);
        final result = await storageService.uploadFile(
            file: uploadImage!, fileName: extensionWithoutFileExtension);

        ref
            .read(eventFormControllerProvider.notifier)
            .updateImage(result!['downloadUrl']);

        await ref.read(eventFormControllerProvider.notifier).onSave();
        if (isSubmitting == false) {
          _formDescTitleKey.currentState?.reset();
          selectTime = null;
          previewImages = null;
          uploadImage = null;
          temPath = null;
          ref.invalidate(eventFormControllerProvider);
          if (mounted) {
            HelpersUtils.navigatorState(context).pop();
          }
          playAudio();
          Fluttertoast.showToast(
              msg: 'Successfully created the event !!!',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 3,
              backgroundColor: AppColors.secondaryColor,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } else {
        String? message =
            ref.read(eventFormControllerProvider.notifier).validateForm();
        showDialog(
            context: context,
            builder: (context) => AppALertDialog(
                onConfirm: () {
                  if (message != null && message.contains('title')) {
                    _focusNodeTitle.requestFocus();
                  }
                  if (message != null && message.contains('map location')) {
                    _focusNodeMap.requestFocus();
                  }
                  if (message != null && message.contains('price')) {
                    _focusNodePrice.requestFocus();
                  }

                  if (message != null && message.contains('date')) {
                    _focusDateTime.requestFocus();
                  }
                },
                title: 'Missing Information',
                desc: message ?? "Something went wrong !!!"));
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

  bool isKeyboardVisible(BuildContext context) {
    final padding = MediaQuery.of(context).viewInsets.bottom;
    return padding > 0;
  }

  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.backgroundLight,
        builder: (context) {
          return BottomUploadImage(
            context,
            (type) {
              _uploadingImage(type);
            },
          );
        });
  }

  void navigateToMap() {
    resetFocusScope();

    HelpersUtils.navigatorState(context).push(MaterialPageRoute(
      builder: (context) => const EventSelectMap(),
    ));
  }

  void bindingAudio() async {
    playAudioUpload = AudioPlayer();
    await playAudioUpload.setAsset(Assets.audio.uploadSound);
    playAudioUpload.setVolume(0.8);
  }

  void playAudio() async {
    playAudioUpload.play();
  }
}
