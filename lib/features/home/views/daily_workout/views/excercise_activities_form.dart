import 'package:demo/common/widget/app_bar_custom.dart';
import 'package:demo/common/widget/app_input.dart';
import 'package:demo/common/widget/button.dart';
import 'package:demo/features/home/views/main/event/event_post/event_date_picker.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/device/device_utils.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ExcerciseActivitiesForm extends StatefulWidget {
  const ExcerciseActivitiesForm({super.key});

  @override
  State<ExcerciseActivitiesForm> createState() =>
      _ExcerciseActivitiesFormState();
}

class _ExcerciseActivitiesFormState extends State<ExcerciseActivitiesForm> {
  @override
  Widget build(BuildContext context) {
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
              children: [Form(child: activitiesForm(context))],
            ))),
          ),
        ),
        renderButton(false),
      ],
    );
  }
}

Widget activitiesForm(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(Sizes.lg),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppInput(
          controller: null,
          labelText: 'Activity name',
          maxLength: 50,
          maxLines: 1,
          validator: (value) {
            return null;
          },
          onSaved: (value) {},
          hintText: 'Name of the Activity',
        ),
        AppInput(
          controller: null,
          labelText: 'Note',
          maxLength: 100,
          maxLines: 4,
          validator: (value) {
            return null;
          },
          onSaved: (value) {},
          hintText: 'Type your note here...',
        ),
        eventDatePickerField(context)
      ],
    ),
  );
}

Column eventDatePickerField(context) {
  // final dangeRange = ref.watch(eventFormControllerProvider);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(
        height: Sizes.lg,
      ),
      InkWell(
        borderRadius: BorderRadius.circular(Sizes.md),
        onTap: () {
          HelpersUtils.navigatorState(context).push(MaterialPageRoute(
            builder: (context) => const EventDatePickerCustom(),
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
                'Choose Date',
                style: AppTextTheme.lightTextTheme.bodyLarge?.copyWith(
                    // ignore: unnecessary_null_comparison
                    color: AppColors.neutralColor,
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
                // overlayColor: WidgetStatePropertyAll(Colors.transparent),
                borderRadius: BorderRadius.circular(Sizes.md),

                onTap: () {
                  // showDatePickerBottomSheet(context, TimeSelection.startTime);
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
                        'Start Time',
                        style: AppTextTheme.lightTextTheme.bodyLarge?.copyWith(
                            // ignore: unnecessary_null_comparison
                            color: AppColors.neutralColor,
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
                borderRadius: BorderRadius.circular(Sizes.md),
                onTap: () {
                  // showDatePickerBottomSheet(context, TimeSelection.endTime);
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
                        ' End Time',
                        style: AppTextTheme.lightTextTheme.bodyLarge?.copyWith(
                            // ignore: unnecessary_null_comparison
                            color: 0 == null
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
            onPressed: () {},
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
