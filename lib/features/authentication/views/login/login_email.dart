import 'package:demo/common/widget/app_input.dart';
import 'package:demo/common/widget/backdrop_loading.dart';
import 'package:demo/common/widget/button.dart';
import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/data/repository/firebase/auth_login_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/features/authentication/controller/auth_controller.dart';
import 'package:demo/features/authentication/controller/login_controller.dart';
import 'package:demo/features/authentication/views/forget_password_button.dart';
import 'package:demo/features/authentication/views/login/divider_auth.dart';
import 'package:demo/features/authentication/views/login/footer_text_auth.dart';
import 'package:demo/features/authentication/views/social_auth_button.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/exception/app_exception.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter_svg/svg.dart';

class EmailLoginTab extends ConsumerStatefulWidget {
  const EmailLoginTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EmailLoginTabState();
}

class _EmailLoginTabState extends ConsumerState<EmailLoginTab> {
  bool showPassword = false;
  late TextEditingController _textEditingControllerEmail;
  late TextEditingController _textEditingControllerPassword;
  late AuthController authController;
  @override
  void initState() {
    _textEditingControllerEmail = TextEditingController();
    _textEditingControllerPassword = TextEditingController();
    authController = AuthController(ref: ref);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(loginControllerProvider);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: Sizes.xl,
          ),
          AppInput(
            hintText: 'hello@example.com',
            labelText: 'Email Address',
            controller: _textEditingControllerEmail,
            maxLength: 35,
            onChanged: (value) {
              ref
                  .read(loginControllerProvider.notifier)
                  .updateEmail(value.trim());
            },
          ),
          AppInput(
            hintText: 'Example123',
            obscureText: !showPassword,
            controller: _textEditingControllerPassword,
            maxLength: 12,
            labelText: 'Password',
            onChanged: (value) {
              ref
                  .read(loginControllerProvider.notifier)
                  .updatePassword(value.trim());
            },
            suffix: IconButton(
                onPressed: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
                icon: SvgPicture.asset(showPassword
                    ? Assets.icon.svg.eye
                    : Assets.icon.svg.eyeClosed)),
          ),
          forgetPasswordButton(context),
          ButtonApp(
              height: 18,
              splashColor: const Color.fromARGB(255, 207, 225, 255),
              label: "Login",
              onPressed: _handleLoginState,
              radius: 0,
              textStyle: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                  color: AppColors.backgroundLight,
                  fontWeight: FontWeight.w500) as dynamic,
              color: AppColors.secondaryColor,
              textColor: Colors.white,
              elevation: 0),
          dividerAuth(),
          const SocialAuthButton(),
          footerTextAuth(
              onPress: () {
                HelpersUtils.navigatorState(context)
                    .pushNamed(AppPage.register);
              },
              text1: 'Dont have an account?',
              text2: ' Register here'),
        ],
      ),
    );
  }

  Future _handleLoginState() async {
    try {
      ref.read(appLoadingStateProvider.notifier).setState(true);
      final authState = ref.read(loginControllerProvider);
      await authController.loginUser(authState);
    } catch (e) {
      ref.read(appLoadingStateProvider.notifier).setState(false);
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
      }
    }
  }
}
