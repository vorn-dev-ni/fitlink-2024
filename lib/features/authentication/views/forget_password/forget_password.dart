import 'package:demo/common/widget/app_bar_custom.dart';
import 'package:demo/common/widget/app_input.dart';
import 'package:demo/common/widget/backdrop_loading.dart';
import 'package:demo/common/widget/button.dart';
import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/features/authentication/controller/auth_controller.dart';
import 'package:demo/features/authentication/views/login/footer_text_auth.dart';
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
import 'package:sizer/sizer.dart';

class ForgetPassword extends ConsumerStatefulWidget {
  const ForgetPassword({super.key});

  @override
  ConsumerState<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends ConsumerState<ForgetPassword> {
  late TextEditingController textEditingController;
  late AuthController authController;
  @override
  void initState() {
    authController = AuthController(ref: ref);
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(appLoadingStateProvider);

    return GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(context),
        child: Stack(
          children: [
            Scaffold(
              appBar: const AppBarCustom(
                  bgColor: AppColors.backgroundLight, showheader: false),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.xl),
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: 85.h,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          headerTitle(),
                          AppInput(
                            hintText: 'Chovy@gmail.com',
                            labelText: 'Email Address',
                            maxLength: 35,
                            controller: textEditingController,
                          ),
                          const SizedBox(
                            height: Sizes.xl,
                          ),
                          ButtonApp(
                              height: 14,
                              splashColor:
                                  const Color.fromARGB(255, 207, 225, 255),
                              label: "Reset Password",
                              onPressed: () async {
                                try {
                                  debugPrint(
                                      'email is ${textEditingController.text}');

                                  ref
                                      .read(appLoadingStateProvider.notifier)
                                      .setState(true);

                                  await authController.sendEmailforgetPassword(
                                      textEditingController.text);
                                  ref
                                      .read(appLoadingStateProvider.notifier)
                                      .setState(false);
                                  HelpersUtils.navigatorState(context)
                                      .pushNamed(
                                    AppPage.forgetpasswordSuccess,
                                  );
                                } catch (e) {
                                  ref
                                      .read(appLoadingStateProvider.notifier)
                                      .setState(false);
                                  if (mounted) {
                                    ScaffoldMessenger.of(context)
                                        .removeCurrentSnackBar();
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
                                  }
                                }

                                // HelpersUtils.navigatorState(context)
                                //     .pushNamed(AppPage.emailSuccess);
                              },
                              radius: 0,
                              textStyle: AppTextTheme.lightTextTheme.titleMedium
                                  ?.copyWith(
                                      color: AppColors.backgroundLight,
                                      fontWeight: FontWeight.w500) as dynamic,
                              color: AppColors.secondaryColor,
                              textColor: Colors.white,
                              elevation: 0),
                          const Spacer(),
                          footerTextAuth(
                              onPress: () {
                                HelpersUtils.navigatorState(context)
                                    .pushNamed(AppPage.register);
                              },
                              text1: 'Dont have an account?',
                              text2: ' Register here'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (isLoading == true)
              backDropLoading(
                  backgroundColor: const Color.fromARGB(255, 0, 0, 0)),
          ],
        ));
  }

  Column headerTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Forgot Password?',
          style: AppTextTheme.lightTextTheme.headlineLarge
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        Text(
          'Enter your email address to get the password reset access.',
          style: AppTextTheme.lightTextTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w400, color: AppColors.neutralDark),
        ),
        const SizedBox(
          height: Sizes.xl,
        ),
      ],
    );
  }
}
