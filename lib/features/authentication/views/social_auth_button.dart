import 'package:demo/common/widget/button.dart';
import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/features/authentication/controller/auth_controller.dart';
import 'package:demo/features/home/controller/profile/profile_user_controller.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/exception/app_exception.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/local_storage/local_storage_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:demo/utils/constant/svg_asset.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SocialAuthButton extends ConsumerStatefulWidget {
  const SocialAuthButton({
    super.key,
  });

  @override
  ConsumerState<SocialAuthButton> createState() => _SocialAuthButtonState();
}

class _SocialAuthButtonState extends ConsumerState<SocialAuthButton> {
  late final AuthController authController;

  @override
  void initState() {
    authController = AuthController(ref: ref);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ButtonApp(
          height: 18,
          splashColor: const Color.fromARGB(255, 162, 159, 159),
          label: "Continue with Apple",
          onPressed: () async {
            await _continueApple();
          },
          iconButton: SvgPicture.string(
            SvgAsset.appleSvg,
            width: 3.w,
            height: 3.h,
          ),
          radius: 0,
          textStyle: AppTextTheme.lightTextTheme.labelLarge?.copyWith(
            color: AppColors.backgroundLight,
            fontWeight: FontWeight.w400,
          ) as dynamic,
          color: AppColors.neutralBlack,
          textColor: Colors.white,
          elevation: 0,
        ),
        const SizedBox(
          height: Sizes.lg,
        ),
        ButtonApp(
            height: 18,
            splashColor: const Color.fromARGB(255, 162, 159, 159),
            label: "Continue with Google",
            onPressed: _continueGoogle,
            iconButton: SvgPicture.string(
              SvgAsset.googleSvg,
              width: 3.w,
              height: 3.h,
            ),
            radius: 0,
            textStyle: AppTextTheme.lightTextTheme.labelLarge?.copyWith(
                color: AppColors.neutralDark,
                fontWeight: FontWeight.w500) as dynamic,
            color: AppColors.neutralColor,
            textColor: Colors.white,
            elevation: 0),
        const SizedBox(
          height: Sizes.lg,
        ),
        ButtonApp(
            height: 18,
            splashColor:
                const Color.fromARGB(255, 189, 214, 245).withOpacity(0.1),
            label: "Continue with Facebook",
            onPressed: _continueWithFacebook,
            iconButton: SvgPicture.string(
              SvgAsset.facebookSvg,
              width: 3.w,
              height: 3.h,
            ),
            radius: 0,
            textStyle: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                color: AppColors.backgroundLight,
                fontWeight: FontWeight.w500) as dynamic,
            color: const Color(0xff1877F2),
            textColor: Colors.white,
            elevation: 0),
        const SizedBox(
          height: Sizes.md,
        ),
      ],
    );
  }

  void _continueGoogle() async {
    try {
      if (mounted) {
        ref.read(appLoadingStateProvider.notifier).setState(true);
      }
      final isEmpty = await authController.loginWithGoogle();

      if (isEmpty == null) {
        ref.read(appLoadingStateProvider.notifier).setState(false);
      }
      if (mounted) {
        ref.invalidate(profileUserControllerProvider);
      }
    } catch (e) {
      if (mounted) {
        ref.read(appLoadingStateProvider.notifier).setState(false);
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
      }
    }
  }

  Future _continueApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Use provided email, otherwise generate random
      String email = credential.email ??
          LocalStorageUtils().getKey("apple_email") ??
          HelpersUtils.generateRandomEmail();
      String givenName = credential.givenName ??
          LocalStorageUtils().getKey("apple_given_name") ??
          "User";

      // Save email and given name if first time
      await LocalStorageUtils().setKeyString("apple_email", email);
      await LocalStorageUtils().setKeyString("apple_given_name", givenName);

      if (mounted) {
        ref.read(appLoadingStateProvider.notifier).setState(true);
      }

      final isEmpty = await authController.loginWithApple(
        email: email,
        fullName: givenName,
        authorizationCode: credential.authorizationCode,
        identityToken: credential.identityToken,
      );

      if (isEmpty == null) {
        ref.read(appLoadingStateProvider.notifier).setState(false);
      }

      if (mounted) {
        ref.invalidate(profileUserControllerProvider);
      }
    } catch (e) {
      if (mounted) {
        ref.read(appLoadingStateProvider.notifier).setState(false);
      }
    }
  }

  void _continueWithFacebook() async {
    try {
      ref.read(appLoadingStateProvider.notifier).setState(true);
      final isEmpty = await authController.loginUserWithFacebook();
      if (isEmpty == null) {
        ref.read(appLoadingStateProvider.notifier).setState(false);
      }
      if (mounted) {
        ref.invalidate(profileUserControllerProvider);
      }
    } catch (e) {
      if (mounted) {
        ref.read(appLoadingStateProvider.notifier).setState(false);

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
      }
    } finally {}
  }
}
