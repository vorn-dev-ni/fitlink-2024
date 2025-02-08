import 'package:demo/common/widget/app_bar_custom.dart';
import 'package:demo/common/widget/backdrop_loading.dart';
import 'package:demo/common/widget/button.dart';
import 'package:demo/features/home/controller/submission/form_loading.dart';
import 'package:demo/features/home/controller/submission/form_submission_controller.dart';
import 'package:demo/features/home/controller/submission/step_header_controller.dart';
import 'package:demo/features/home/views/main/event/event_submission/event_form_header.dart';
import 'package:demo/features/home/views/main/event/event_submission/personal_address.dart';
import 'package:demo/features/home/views/main/event/event_submission/personal_doc.dart';
import 'package:demo/features/home/views/main/event/event_submission/personal_info.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/device/device_utils.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventFormSubmission extends ConsumerStatefulWidget {
  const EventFormSubmission({super.key});

  @override
  ConsumerState<EventFormSubmission> createState() =>
      _EventFormSubmissionState();
}

class _EventFormSubmissionState extends ConsumerState<EventFormSubmission> {
  late List<Widget> steps;

  @override
  void initState() {
    steps = const [PersonalInfo(), PersonalAddress(), PersonalDoc()];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final stepIndex = ref.watch(stepHeaderControllerProvider);
    final appLoading = ref.watch(formLoadingControllerProvider);
    return GestureDetector(
      onTap: () {
        DeviceUtils.hideKeyboard(context);
      },
      child: PopScope(
          canPop: true,
          child: Stack(
            children: [
              Scaffold(
                  appBar: AppBarCustom(
                    text: 'Form Request',
                    bgColor: AppColors.backgroundLight,
                    isCenter: true,
                    showheader: false,
                    trailing: IconButton(
                        alignment: Alignment.center,
                        onPressed: () {
                          if (stepIndex <= 0) {
                            bool isKeyboardVisible =
                                DeviceUtils.isKeyboardVisible(context);

                            if (isKeyboardVisible) {
                              DeviceUtils.hideKeyboard(context);
                            } else {
                              ref.invalidate(formSubmissionControllerProvider);
                              HelpersUtils.navigatorState(context).pop();
                            }
                          }
                          ref
                              .read(stepHeaderControllerProvider.notifier)
                              .backIndex();
                        },
                        icon: const Icon(Icons.arrow_back_ios)),
                  ),
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(Sizes.lg),
                      child: Column(
                        children: [
                          Container(
                              alignment: Alignment.center,
                              height: 50,
                              child: const EventFormHeader()),
                          steps[stepIndex],
                        ],
                      ),
                    ),
                  )),
              if (appLoading) backDropLoading()
            ],
          )),
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
              splashColor: const Color.fromARGB(255, 207, 225, 255),
              label: "Save Changes",
              onPressed: () {},
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
}
