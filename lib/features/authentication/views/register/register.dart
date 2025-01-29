import 'package:demo/common/widget/app_bar_custom.dart';
import 'package:demo/common/widget/app_input.dart';
import 'package:demo/common/widget/backdrop_loading.dart';
import 'package:demo/common/widget/button.dart';
import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/features/authentication/controller/auth_controller.dart';
import 'package:demo/features/authentication/controller/register_controller.dart';
import 'package:demo/features/authentication/views/forget_password_button.dart';
import 'package:demo/features/authentication/views/login/divider_auth.dart';
import 'package:demo/features/authentication/views/login/footer_text_auth.dart';
import 'package:demo/features/authentication/views/social_auth_button.dart';
import 'package:demo/gen/assets.gen.dart';
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
import 'package:flutter_svg/svg.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  bool showPassword = false;
  late TextEditingController _textEditingControllerFullName;
  late TextEditingController _textEditingControllerEmail;
  late TextEditingController _textEditingControllerPassword;
  late AuthController authController;
  @override
  void initState() {
    _textEditingControllerEmail = TextEditingController();
    _textEditingControllerFullName = TextEditingController();
    _textEditingControllerPassword = TextEditingController();
    authController = AuthController(ref: ref);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(registerControllerProvider);
    final appLoading = ref.watch(appLoadingStateProvider);

    return Stack(
      children: [
        GestureDetector(
          onTap: () => DeviceUtils.hideKeyboard(context),
          child: Scaffold(
            appBar: const AppBarCustom(
                bgColor: AppColors.backgroundLight, showheader: false),
            body: SafeArea(
              child: SingleChildScrollView(
                primary: false,
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      headerTitle(),
                      AppInput(
                        hintText: 'Chovy',
                        labelText: 'Fullname',
                        controller: _textEditingControllerFullName,
                        maxLength: 25,
                        onChanged: (value) {
                          ref
                              .read(registerControllerProvider.notifier)
                              .updateFullName(value.trim());
                        },
                      ),
                      AppInput(
                        hintText: 'Chovy@gmail.com',
                        controller: _textEditingControllerEmail,
                        labelText: 'Email',
                        maxLength: 35,
                        onChanged: (value) {
                          ref
                              .read(registerControllerProvider.notifier)
                              .updateEmail(value.trim());
                        },
                      ),
                      AppInput(
                        hintText: 'Example123',
                        obscureText: !showPassword,
                        maxLength: 12,
                        labelText: 'Password',
                        controller: _textEditingControllerPassword,
                        onChanged: (value) {
                          ref
                              .read(registerControllerProvider.notifier)
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
                      Container(
                        margin: const EdgeInsets.only(top: Sizes.xl),
                        child: Wrap(
                          children: [
                            const Text('By Continue, you agree to our '),
                            InkWell(
                                onTap: () async {
                                  await HelpersUtils.deepLinkLauncher(
                                      'https://www.freeprivacypolicy.com/live/e8fcdd80-d621-4ab4-b055-93f99aa2693f');
                                },
                                child: const Text(
                                  'terms and services',
                                  style: TextStyle(
                                      color: AppColors.secondaryColor,
                                      fontWeight: FontWeight.w500),
                                ))
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: Sizes.xl,
                      ),
                      ButtonApp(
                          height: 18,
                          splashColor: const Color.fromARGB(255, 207, 225, 255),
                          label: "Sign Up",
                          onPressed: _handleRegister,
                          radius: 0,
                          textStyle: AppTextTheme.lightTextTheme.bodyMedium
                              ?.copyWith(
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
                                .pushNamed(AppPage.auth);
                          },
                          text1: 'Already have an account?',
                          text2: ' Sign in here'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (appLoading == true)
          backDropLoading(backgroundColor: const Color.fromARGB(255, 0, 0, 0)),
      ],
    );
  }

  Column headerTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create an account',
          style: AppTextTheme.lightTextTheme.headlineLarge
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Future _handleRegister() async {
    try {
      ref.read(appLoadingStateProvider.notifier).setState(true);
      final authState = ref.read(registerControllerProvider);
      await authController.createAccount(authState);
      ref.read(appLoadingStateProvider.notifier).setState(false);
    } catch (e) {
      if (mounted) {
        ref.read(appLoadingStateProvider.notifier).setState(false);
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        if (e is AppException) {
          HelpersUtils.showErrorSnackbar(
              duration: 3000,
              context,
              e.title,
              e.message,
              StatusSnackbar.failed);
        } else {
          HelpersUtils.showErrorSnackbar(
              duration: 3000,
              context,
              'Something went wrong',
              e.toString(),
              StatusSnackbar.failed);
        }
      }
    }
  }
}
