import 'package:demo/common/widget/app_bar_custom.dart';
import 'package:demo/common/widget/backdrop_loading.dart';
import 'package:demo/common/widget/button.dart';
import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/features/authentication/controller/auth_controller.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/exception/app_exception.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class ForgetPasswordSuccess extends ConsumerStatefulWidget {
  const ForgetPasswordSuccess({super.key});

  @override
  ConsumerState<ForgetPasswordSuccess> createState() =>
      _ForgetPasswordSuccessState();
}

class _ForgetPasswordSuccessState extends ConsumerState<ForgetPasswordSuccess> {
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
          appBar: const AppBarCustom(
              bgColor: AppColors.backgroundLight, showheader: false),
          body: renderBody(),
        ),
        if (appLoading == true)
          backDropLoading(backgroundColor: const Color.fromARGB(255, 0, 0, 0)),
      ],
    );
  }

  Widget renderBody() {
    return SafeArea(
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
            'Please check your email to reset your password',
            textAlign: TextAlign.center,
            style: AppTextTheme.lightTextTheme.bodyMedium
                ?.copyWith(color: AppColors.neutralDark),
          ),
          const Spacer(),
          ButtonApp(
              height: 18,
              splashColor: const Color.fromARGB(255, 207, 225, 255),
              label: "Back to login",
              onPressed: () {
                HelpersUtils.navigatorState(context).pushNamedAndRemoveUntil(
                  AppPage.auth,
                  (route) => false,
                );
              },
              radius: 0,
              textStyle: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                  color: AppColors.backgroundLight,
                  fontWeight: FontWeight.w500) as dynamic,
              color: AppColors.secondaryColor,
              textColor: Colors.white,
              elevation: 0),

          // ButtonApp(
          //     height: 18,
          //     splashColor: const Color.fromARGB(255, 207, 225, 255),
          //     label: "Resend Email",
          //     onPressed: () async {
          //       try {
          //         ref.read(appLoadingStateProvider.notifier).setState(true);
          //         await authController.sendEmailforgetPassword(userEmail ?? '');
          //       } catch (e) {
          //         ref.read(appLoadingStateProvider.notifier).setState(false);
          //         if (mounted) {
          //           ScaffoldMessenger.of(context).removeCurrentSnackBar();
          //           if (e is AppException) {
          //             HelpersUtils.showErrorSnackbar(
          //                 duration: 4000,
          //                 context,
          //                 e.title,
          //                 e.message,
          //                 StatusSnackbar.failed);
          //           } else {
          //             HelpersUtils.showErrorSnackbar(
          //                 duration: 4000,
          //                 context,
          //                 'Something went wrong',
          //                 e.toString(),
          //                 StatusSnackbar.failed);
          //           }
          //         }
          //       } finally {
          //         if (mounted) {
          //           ref.read(appLoadingStateProvider.notifier).setState(false);
          //         }
          //       }
          //     },
          //     radius: 0,
          //     textStyle: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
          //         color: AppColors.backgroundLight,
          //         fontWeight: FontWeight.w500) as dynamic,
          //     color: AppColors.secondaryColor,
          //     textColor: Colors.white,
          //     elevation: 0),
        ],
      ),
    ));
  }
}
