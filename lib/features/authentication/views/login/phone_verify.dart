import 'package:demo/common/widget/backdrop_loading.dart';
import 'package:demo/common/widget/button.dart';
import 'package:demo/common/widget/custom_text_otp.dart';
import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/features/authentication/controller/login_controller.dart';
import 'package:demo/features/authentication/controller/otp_controller.dart';
import 'package:demo/features/home/controller/profile/profile_user_controller.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/device/device_utils.dart';
import 'package:demo/utils/exception/app_exception.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PhoneOtpVerify extends ConsumerStatefulWidget {
  const PhoneOtpVerify({super.key});

  @override
  ConsumerState<PhoneOtpVerify> createState() => _PhoneOtpVerifyState();
}

class _PhoneOtpVerifyState extends ConsumerState<PhoneOtpVerify> {
  late final data;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      data = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      if (data.containsKey('phone')) {
        ref
            .read(loginControllerProvider.notifier)
            .updatePhoneNumber(data['phone']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appLoading = ref.watch(appLoadingStateProvider);
    return PopScope(
      canPop: true,
      child: GestureDetector(
          onTap: () => DeviceUtils.hideKeyboard(context),
          child: Stack(
            children: [
              Scaffold(
                body: SafeArea(
                    child: Padding(
                  padding: const EdgeInsets.all(Sizes.xl),
                  child: Column(
                    children: [
                      // Text(data['verificationId']),
                      headerTitle(),
                      const SizedBox(
                        height: Sizes.xxxl,
                      ),
                      CustomOtpField(
                        onCompleted: (values) {
                          debugPrint("User has filled");
                          ref
                              .read(otpControlelrProvider.notifier)
                              .updateCode(values);
                          _handleVerify();
                        },
                        onOtpChanged: (value) {
                          ref
                              .read(otpControlelrProvider.notifier)
                              .updateCode(value);
                        },
                      ),
                      const SizedBox(
                        height: Sizes.xxxl,
                      ),
                      ButtonApp(
                          height: 14,
                          splashColor: const Color.fromARGB(255, 207, 225, 255),
                          label: "Verify",
                          onPressed: _handleVerify,
                          radius: 0,
                          textStyle: AppTextTheme.lightTextTheme.titleMedium
                              ?.copyWith(
                                  color: AppColors.backgroundLight,
                                  fontWeight: FontWeight.w500) as dynamic,
                          color: AppColors.secondaryColor,
                          textColor: Colors.white,
                          elevation: 0),
                      const Spacer(),
                      TextButton(
                        onPressed: () async {
                          ref
                              .read(loginControllerProvider.notifier)
                              .sendPhoneOtp(
                            onSuccessVerification:
                                (verificationId, resendToken) {
                              debugPrint("Phone has success verification");
                              Fluttertoast.showToast(
                                  msg: "Phone has success verification !!!",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: AppColors.successColor,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            },
                          );
                          Fluttertoast.showToast(
                              msg: "Phone has success verification !!!",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: AppColors.successColor,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          debugPrint("Phone resend code already");
                        },
                        style: const ButtonStyle(
                            elevation: WidgetStatePropertyAll(0),
                            shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder()),
                            overlayColor: WidgetStatePropertyAll(
                                Color.fromARGB(255, 224, 224, 224)),
                            splashFactory: InkSplash.splashFactory),
                        child: Text('Resend Code',
                            style: AppTextTheme.lightTextTheme.titleMedium
                                ?.copyWith(color: AppColors.secondaryColor)),
                      ),
                    ],
                  ),
                )),
              ),
              if (appLoading == true)
                backDropLoading(
                    backgroundColor: const Color.fromARGB(255, 0, 0, 0)),
            ],
          )),
    );
  }

  Column headerTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone Verification',
          style: AppTextTheme.lightTextTheme.headlineLarge
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        Text(
          'Enter the verification code we just sent on your phone number.',
          style: AppTextTheme.lightTextTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w400, color: AppColors.neutralDark),
        ),
      ],
    );
  }

  void _handleVerify() async {
    try {
      DeviceUtils.hideKeyboard(context);
      ref.read(appLoadingStateProvider.notifier).setState(true);
      await ref.read(loginControllerProvider.notifier).sendCodeSignInPhone(
          onSuccessOtp: () {
            // HelpersUtils.navigatorState(context).pushNamed(
            //   AppPage.home,
            // );
            // ref.invalidate(profileUserControllerProvider);

            debugPrint("PTTP is >>> ");

            // if (HelpersUtils.navigatorState(context).canPop() == true) {
            //   HelpersUtils.navigatorState(context).pop();
            //   HelpersUtils.navigatorState(context).pop();
            //   // HelpersUtils.navigatorState(context).pop();
            // }
          },
          verificationId: data['verificationId']);
      ref.read(appLoadingStateProvider.notifier).setState(false);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        if (e is AppException) {
          HelpersUtils.showErrorSnackbar(
              duration: 4000,
              context,
              e.title,
              e.message,
              StatusSnackbar.failed);
        } else {
          HelpersUtils.showErrorSnackbar(
              duration: 4000,
              context,
              'Something went wrong',
              e.toString(),
              StatusSnackbar.failed);
        }

        ref.read(appLoadingStateProvider.notifier).setState(false);
      }
    }
  }
}
