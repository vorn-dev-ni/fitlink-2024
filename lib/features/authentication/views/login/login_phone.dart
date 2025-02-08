import 'package:country_picker/country_picker.dart';
import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/features/authentication/controller/login_controller.dart';
import 'package:demo/features/authentication/views/forget_password_button.dart';
import 'package:demo/features/authentication/views/login/footer_text_auth.dart';
import 'package:demo/features/other/app_info.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/device/device_utils.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo/common/widget/app_input.dart';
import 'package:demo/common/widget/button.dart';
import 'package:demo/features/authentication/views/login/divider_auth.dart';
import 'package:demo/features/authentication/views/social_auth_button.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/theme/text/text_theme.dart';

class PhoneNumberTab extends ConsumerStatefulWidget {
  const PhoneNumberTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PhoneNumberTabState();
}

class _PhoneNumberTabState extends ConsumerState<PhoneNumberTab> {
  late TextEditingController _textEditingControllerPhone;
  @override
  void initState() {
    _textEditingControllerPhone = TextEditingController();

    super.initState();
  }

  void openCountryPicker() {
    showCountryPicker(
      context: context,
      useSafeArea: true,
      favorite: <String>['KH'],
      showPhoneCode: true,
      onSelect: (Country country) {
        debugPrint(country.phoneCode);
        ref
            .read(loginControllerProvider.notifier)
            .updateCountryCode(country.phoneCode);
        DeviceUtils.hideKeyboard(context);
        DeviceUtils.hideKeyboard(context);
      },
      moveAlongWithKeyboard: false,
      countryListTheme: CountryListThemeData(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
          ),
          flagSize: 30,
          inputDecoration: InputDecoration(
            labelText: 'Search',
            labelStyle: AppTextTheme.lightTextTheme.bodyMedium,
            hintText: '',
            prefixIcon: const Icon(
              Icons.search,
              color: AppColors.secondaryColor,
            ),
            focusColor: AppColors.secondaryColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Sizes.lg),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 226, 231, 231),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Sizes.lg),
              borderSide: const BorderSide(
                color: AppColors.secondaryColor,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Sizes.lg),
              borderSide: BorderSide(
                color:
                    const Color.fromARGB(255, 226, 231, 239).withOpacity(0.2),
              ),
            ),
          ),
          searchTextStyle: AppTextTheme.lightTextTheme.bodyMedium?.copyWith()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(loginControllerProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: Sizes.xl,
          ),
          AppInput(
            hintText: '965689895',
            labelText: 'Phone number',
            formatter: [
              FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
            ],
            controller: _textEditingControllerPhone,
            keyboardType: TextInputType.phone,
            onChanged: (value) {
              ref
                  .read(loginControllerProvider.notifier)
                  .updatePhoneNumber(value);
            },
            prefixIcon: Padding(
              padding: const EdgeInsets.only(bottom: 1),
              child: SizedBox(
                width: 65,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        openCountryPicker();
                      },
                      child: SizedBox(
                        width: 50,
                        child: Text(
                          textAlign: TextAlign.center,
                          '+${userState.countryCode}',
                          style: AppTextTheme.lightTextTheme.bodyLarge
                              ?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff4B5768)),
                        ),
                      ),
                    ),
                    const VerticalDivider(
                      thickness: 1,
                      width: 4,
                    ),
                    Text(
                      '|',
                      style: AppTextTheme.lightTextTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w300,
                          color: const Color(0xff4B5768)),
                    ),
                  ],
                ),
              ),
            ),
            maxLength: 10,
          ),
          forgetPasswordButton(context),
          ButtonApp(
              height: 18,
              splashColor: const Color.fromARGB(255, 207, 225, 255),
              label: "Login",
              onPressed: () async {
                try {
                  DeviceUtils.hideKeyboard(context);
                  ref.read(appLoadingStateProvider.notifier).setState(true);

                  bool isValid = ref
                      .read(loginControllerProvider.notifier)
                      .checkLoginPhoneState();
                  if (isValid == false) {
                    HelpersUtils.showErrorSnackbar(
                        duration: 3000,
                        context,
                        'Input Required',
                        'Phone number must be valid and not empty',
                        StatusSnackbar.failed);
                    ref.read(appLoadingStateProvider.notifier).setState(false);

                    return;
                  }
                  DeviceUtils.hideKeyboard(context);
                  await ref.read(loginControllerProvider.notifier).sendPhoneOtp(
                    onSuccessVerification: (verificationId, resendToken) {
                      debugPrint("Login phone success");
                      ref
                          .read(appLoadingStateProvider.notifier)
                          .setState(false);
                      HelpersUtils.navigatorState(context)
                          .pushNamed(AppPage.otpVerify, arguments: {
                        'verificationId': verificationId,
                        'resendToken': resendToken,
                        'phone': userState.phoneNumber
                      });
                    },
                  );
                } catch (e) {
                  if (mounted) {
                    ref.read(appLoadingStateProvider.notifier).setState(false);
                    HelpersUtils.showErrorSnackbar(
                        duration: 6000,
                        context,
                        'Oops!!!',
                        e.toString(),
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
          dividerAuth(),
          const SocialAuthButton(),
          footerTextAuth(
              onPress: () {
                HelpersUtils.navigatorState(context)
                    .pushNamed(AppPage.register);
              },
              text1: 'Dont have an account?',
              text2: ' Register here'),
          const AppInfo(),
        ],
      ),
    );
  }
}
