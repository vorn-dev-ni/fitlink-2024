import 'package:country_picker/country_picker.dart';
import 'package:demo/common/widget/app_input.dart';
import 'package:demo/features/home/controller/submission/form_submission_controller.dart';
import 'package:demo/features/home/controller/submission/step_header_controller.dart';
import 'package:demo/features/home/views/main/event/event_submission/submit_button.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/device/device_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:demo/utils/validation/event_submit_validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonalInfo extends ConsumerStatefulWidget {
  const PersonalInfo({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends ConsumerState<PersonalInfo> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullnameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneNumberController;

  @override
  void initState() {
    bindingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final code = ref.watch(formSubmissionControllerProvider).code;
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: Sizes.xxxl,
          ),
          Text(
            'Personal Info',
            style: AppTextTheme.lightTextTheme.bodyLarge,
          ),
          const SizedBox(
            height: Sizes.lg,
          ),
          AppInput(
            controller: _fullnameController,
            labelText: 'Full name',
            maxLength: 30,
            validator: (value) {
              return EventSubmitValidation.validateFullname(value, 30, 3);
            },
            onSaved: (value) {
              ref
                  .read(formSubmissionControllerProvider.notifier)
                  .updatePersonalInfo(fullName: value?.trim());
            },
            hintText: 'Enter your full name',
          ),
          AppInput(
            labelText: 'Email',
            maxLength: 50,
            validator: (value) =>
                EventSubmitValidation.validateEmail(value, 50, 3),
            onSaved: (value) {
              ref
                  .read(formSubmissionControllerProvider.notifier)
                  .updatePersonalInfo(email: value?.trim());
            },
            controller: _emailController,
            hintText: 'Enter your email address',
          ),
          AppInput(
            hintText: '965689895',
            controller: _phoneNumberController,
            validator: (value) =>
                EventSubmitValidation.validatePhoneNumber(value, 12, 6),
            labelText: 'Phone number',
            onSaved: (value) {
              ref
                  .read(formSubmissionControllerProvider.notifier)
                  .updatePersonalInfo(phoneNumber: value?.trim());
            },
            formatter: [
              FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
            ],
            keyboardType: TextInputType.phone,
            prefixIcon: Padding(
              padding: const EdgeInsets.only(bottom: 1),
              child: SizedBox(
                width: 65,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 14,
                    ),
                    GestureDetector(
                      onTap: () {
                        openCountryPicker();
                      },
                      child: SizedBox(
                        width: 35,
                        child: Text(
                          textAlign: TextAlign.center,
                          '${code}',
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
          const SizedBox(
            height: Sizes.xl,
          ),
          renderButton(false, () {
            _formKey.currentState?.validate();
            if (_formKey.currentState?.validate() == true) {
              _formKey.currentState!.save();
              ref.read(stepHeaderControllerProvider.notifier).updateIndex(1);
            }
          }, 'Next'),
        ],
      ),
    );
  }

  void openCountryPicker() {
    showCountryPicker(
      context: context,
      useSafeArea: true,
      favorite: <String>['KH'],
      showPhoneCode: false,
      onSelect: (Country country) {
        DeviceUtils.hideKeyboard(context);
        ref
            .read(formSubmissionControllerProvider.notifier)
            .updatePersonalInfo(code: country.phoneCode ?? "");
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

  void bindingController() {
    _fullnameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _fullnameController.text =
        ref.read(formSubmissionControllerProvider).contactName ?? "";
    _emailController.text =
        ref.read(formSubmissionControllerProvider).email ?? "";
    _phoneNumberController.text =
        ref.read(formSubmissionControllerProvider).phoneNumber ?? "";
  }
}
