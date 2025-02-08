import 'package:demo/common/widget/backdrop_loading.dart';
import 'package:demo/common/widget/button.dart';
import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/features/authentication/controller/auth_controller.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/exception/app_exception.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EmailVerifyConfimration extends ConsumerStatefulWidget {
  const EmailVerifyConfimration({super.key});

  @override
  ConsumerState<EmailVerifyConfimration> createState() =>
      _EmailVerifyConfimrationState();
}

class _EmailVerifyConfimrationState
    extends ConsumerState<EmailVerifyConfimration> {
  late AuthController authController;

  @override
  void initState() {
    authController = AuthController(ref: ref);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appLoading = ref.watch(appLoadingStateProvider);
    return Stack(
      children: [
        Scaffold(
          body: renderBody(),
        ),
        if (appLoading == true)
          backDropLoading(backgroundColor: const Color.fromARGB(255, 0, 0, 0)),
      ],
    );
  }

  Widget renderBody() {
    return PopScope(
      canPop: false,
      child: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(Sizes.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: Sizes.lg,
            ),
            SvgPicture.asset(
              Assets.icon.svg.check,
              width: 200,
              height: 200,
              colorFilter: const ColorFilter.mode(
                  AppColors.secondaryColor, BlendMode.srcIn),
            ),
            Text(
              'Success',
              style: AppTextTheme.lightTextTheme.headlineLarge,
            ),
            Text(
              'Your email was sent successfully, Please check your email to confirm before you can login !!!',
              textAlign: TextAlign.center,
              style: AppTextTheme.lightTextTheme.bodyMedium
                  ?.copyWith(color: AppColors.neutralDark),
            ),
            const Spacer(),
            ButtonApp(
                height: 18,
                splashColor: const Color.fromARGB(255, 207, 225, 255),
                label: "Resend Email",
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.currentUser?.reload();
                    ref.read(appLoadingStateProvider.notifier).setState(true);
                    await authController.resendEmail();

                    Fluttertoast.showToast(
                        msg: "Successfully resend email !!!",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: AppColors.successColor,
                        textColor: Colors.white,
                        fontSize: 16.0);

                    if (mounted) {
                      ref
                          .read(appLoadingStateProvider.notifier)
                          .setState(false);
                    }
                  } catch (e) {
                    if (mounted) {
                      ref
                          .read(appLoadingStateProvider.notifier)
                          .setState(false);
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      if (e is AppException) {
                        HelpersUtils.showErrorSnackbar(
                            duration: 4000,
                            context,
                            'Oop!!!',
                            'Please wait untill email is expired first, before you can resend again !!!',
                            StatusSnackbar.failed);
                        return;
                      }
                      HelpersUtils.showErrorSnackbar(
                          duration: 4000,
                          context,
                          'Oop!!!',
                          'Please wait untill email is expired first, before you can resend again !!!',
                          StatusSnackbar.failed);
                    }
                  }
                },
                radius: 0,
                textStyle: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                    color: AppColors.backgroundLight,
                    fontWeight: FontWeight.w500) as dynamic,
                color: AppColors.secondaryColor,
                textColor: Colors.white,
                elevation: 0),
          ],
        ),
      )),
    );
  }
}
