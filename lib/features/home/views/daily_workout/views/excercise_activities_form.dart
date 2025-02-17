import 'package:demo/common/widget/app_bar_custom.dart';
import 'package:demo/common/widget/app_input.dart';
import 'package:demo/common/widget/backdrop_loading.dart';
import 'package:demo/common/widget/button.dart';
import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/features/home/controller/activities/activity_form_controller.dart';
import 'package:demo/features/home/controller/workouts/activities_controller.dart';
import 'package:demo/features/home/views/main/event/event_post/event_date_picker.dart';
import 'package:demo/features/home/views/main/event/event_post/event_time_picker.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/device/device_utils.dart';
import 'package:demo/utils/formatters/formatter_utils.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:demo/utils/validation/activity_validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ExcerciseActivitiesForm extends ConsumerStatefulWidget {
  const ExcerciseActivitiesForm({super.key});

  @override
  ConsumerState<ExcerciseActivitiesForm> createState() =>
      _ExcerciseActivitiesFormState();
}

class _ExcerciseActivitiesFormState
    extends ConsumerState<ExcerciseActivitiesForm> {
  final _globalKey = GlobalKey<FormState>();
  String docId = "";
  late TextEditingController _textActivity;
  late TextEditingController _textDesc;
  DateTime? initDate;
  String? _validationDate = '';
  String? _validationStartTime = '';
  String? _validationEndTime = '';
  late AudioPlayer playAudioUpload;

  @override
  void initState() {
    playAudioUpload = AudioPlayer();
    bindingAudio();
    _textActivity = TextEditingController();
    _textDesc = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        final result =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

        if (result['title'] != "") {
          _textActivity.text = result['title'];
          _textDesc.text = result['desc'];
          docId = result['docId'];
          initDate = result['date'];
          ref
              .read(activityFormWorkoutControllerProvider.notifier)
              .updateDate(result['date']);
          ref
              .read(activityFormWorkoutControllerProvider.notifier)
              .updateTimeEnd(result['endTime']);
          ref
              .read(activityFormWorkoutControllerProvider.notifier)
              .updateTimeStart(result['startTime']);
        }
        if (result['date'] != "") {
          ref
              .read(activityFormWorkoutControllerProvider.notifier)
              .updateDate(result['date']);
        }
      },
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(appLoadingStateProvider);
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            DeviceUtils.hideKeyboard(context);
          },
          child: Scaffold(
            appBar: AppBarCustom(
                trailing: GestureDetector(
                  onTap: () {
                    HelpersUtils.navigatorState(context).pop();
                  },
                  child: const Icon(Icons.arrow_back_ios),
                ),
                text: 'Add new activity',
                bgColor: AppColors.backgroundLight,
                showheader: false),
            body: SafeArea(
                child: SingleChildScrollView(
                    child: Column(
              children: [
                Form(
                    key: _globalKey,
                    autovalidateMode: AutovalidateMode.always,
                    child: activitiesForm(context))
              ],
            ))),
          ),
        ),
        renderButton(false),
        if (loading) backDropLoading()
      ],
    );
  }

  void showDatePickerBottomSheet(
      BuildContext context, TimeSelection timeselection) async {
    DateTime? time = timeselection == TimeSelection.startTime
        ? ref.watch(activityFormWorkoutControllerProvider).startTime
        : ref.watch(activityFormWorkoutControllerProvider).endTime;

    final result = await showModalBottomSheet(
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
                ? ref
                    .read(activityFormWorkoutControllerProvider.notifier)
                    .updateTimeStart(
                      newTime,
                    )
                : ref
                    .read(activityFormWorkoutControllerProvider.notifier)
                    .updateTimeEnd(
                      newTime,
                    );

            if (timeselection == TimeSelection.endTime) {
              _validationEndTime = "";
            } else {
              _validationStartTime = "";
            }
          },
        );
      },
    );
  }

  void handleSave() async {
    try {
      ref.read(appLoadingStateProvider.notifier).setState(true);
      final mutateForm = ref.watch(activityFormWorkoutControllerProvider);
      final isValid = _globalKey.currentState?.validate();

      DateTime? date = mutateForm.date;
      DateTime? endTime = mutateForm.endTime;
      DateTime? startTime = mutateForm.startTime;

      if (ActivityValidation.validateDate(date) != "" ||
          ActivityValidation.validateEndtime(endTime) != "" ||
          ActivityValidation.validateDate(startTime) != "") {
        setState(() {
          _validationDate = ActivityValidation.validateDate(date);
          _validationEndTime = ActivityValidation.validateEndtime(endTime);
          _validationStartTime =
              ActivityValidation.validateStartTime(startTime);
        });

        return;
      }

      if (isValid == true) {
        _globalKey.currentState?.save();

        if (docId != '') {
          await ref
              .read(activityFormWorkoutControllerProvider.notifier)
              .updateActivity(docId);

          DateTime normalizedDate =
              DateTime(initDate!.year, initDate!.month, initDate!.day);
          ref.invalidate(activitiesControllerProvider(normalizedDate));
        } else {
          DateTime normalizedDate =
              DateTime(date!.year, date!.month, date!.day);
          await ref.read(activityFormWorkoutControllerProvider.notifier).save();
          ref.invalidate(activitiesControllerProvider(normalizedDate));
        }

        if (mounted) {
          playAudio();
          ref.read(appLoadingStateProvider.notifier).setState(false);
          ref.invalidate(activityFormWorkoutControllerProvider);
          HelpersUtils.navigatorState(context).pop();
        }
      }
    } catch (e) {
      ref.read(appLoadingStateProvider.notifier).setState(true);
    } finally {
      ref.read(appLoadingStateProvider.notifier).setState(false);
    }
  }

  Widget eventDatePickerField(context) {
    final mutateForm = ref.watch(activityFormWorkoutControllerProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: Sizes.lg,
        ),
        InkWell(
          borderRadius: BorderRadius.circular(Sizes.md),
          onTap: () async {
            final result = await HelpersUtils.navigatorState(context)
                .push(MaterialPageRoute(
              builder: (context) => EventDatePickerCustom(
                selectionMode: DateRangePickerSelectionMode.single,
              ),
            ));

            if (result == true) {
              setState(() {
                _validationDate = "";
              });
            }
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
                  mutateForm.date != null
                      ? FormatterUtils.formatDate(mutateForm.date!)
                      : 'Choose Date',
                  style: AppTextTheme.lightTextTheme.bodyLarge?.copyWith(
                    // ignore: unnecessary_null_comparison
                    color: mutateForm.date != null
                        ? AppColors.secondaryColor
                        : AppColors.neutralColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: Sizes.md,
        ),
        if (_validationDate != "")
          Text(
            _validationDate ?? "",
            style: AppTextTheme.lightTextTheme.bodySmall
                ?.copyWith(color: AppColors.errorColor),
          ),
        const SizedBox(
          height: Sizes.md,
        ),
        SizedBox(
          width: 100.w,
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  // overlayColor: WidgetStatePropertyAll(Colors.transparent),
                  borderRadius: BorderRadius.circular(Sizes.md),

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
                                  .read(activityFormWorkoutControllerProvider)
                                  .startTime) ??
                              ' Start Time',
                          style:
                              AppTextTheme.lightTextTheme.bodyLarge?.copyWith(
                            color: mutateForm.startTime != null
                                ? AppColors.secondaryColor
                                : AppColors.neutralColor,
                          ),
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
                  borderRadius: BorderRadius.circular(Sizes.md),
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
                                  .read(activityFormWorkoutControllerProvider)
                                  .endTime) ??
                              ' End Time',
                          style: AppTextTheme.lightTextTheme.bodyLarge
                              ?.copyWith(
                                  color: mutateForm.endTime != null
                                      ? AppColors.secondaryColor
                                      : AppColors.neutralColor,
                                  fontWeight: FontWeight.w600),
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
          height: Sizes.md,
        ),
        if (_validationEndTime != "" || _validationStartTime != "")
          Text(
            ' ${_validationStartTime != "" ? _validationStartTime : _validationEndTime}',
            style: AppTextTheme.lightTextTheme.bodySmall
                ?.copyWith(color: AppColors.errorColor),
          ),
        const SizedBox(
          height: Sizes.lg,
        ),
      ],
    );
  }

  Widget activitiesForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppInput(
            controller: _textActivity,
            labelText: 'Activity name',
            maxLength: 50,
            maxLines: 1,
            validator: (value) {
              return ActivityValidation.validateName(value, 50, 3);
            },
            onSaved: (value) {
              ref
                  .read(activityFormWorkoutControllerProvider.notifier)
                  .updateName(
                    value?.trim() ?? "",
                  );
            },
            hintText: 'Name of the Activity',
          ),
          AppInput(
            controller: _textDesc,
            labelText: 'Note',
            maxLength: 100,
            maxLines: 4,
            validator: (value) {
              return ActivityValidation.validateNote(value, 100, 3);
            },
            onSaved: (value) {
              ref
                  .read(activityFormWorkoutControllerProvider.notifier)
                  .updateNote(
                    value?.trim() ?? "",
                  );
            },
            hintText: 'Type your note here...',
          ),
          eventDatePickerField(context)
        ],
      ),
    );
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
              onPressed: () {
                handleSave();
              },
              splashColor: const Color.fromARGB(255, 207, 225, 255),
              label: "Save Changes",
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

  void bindingAudio() async {
    await playAudioUpload.setAsset(Assets.audio.uploadSound);
    playAudioUpload.setVolume(1);
  }

  void playAudio() {
    playAudioUpload.play();
  }
}
