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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class PersonalAddress extends ConsumerStatefulWidget {
  const PersonalAddress({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PersonalAddressState();
}

class _PersonalAddressState extends ConsumerState<PersonalAddress> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _zipCodeController;
  late final TextEditingController _addressController;
  late String countryPicker = "";
  String errorCountryPicker = "";

  @override
  void initState() {
    bindingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            'Address Info',
            style: AppTextTheme.lightTextTheme.bodyLarge,
          ),
          const SizedBox(
            height: Sizes.lg,
          ),
          AppInput(
            controller: _zipCodeController,
            keyboardType: TextInputType.number,
            labelText: 'Zip code',
            maxLength: 11,
            onSaved: (value) {
              ref
                  .read(formSubmissionControllerProvider.notifier)
                  .updateAddressInfo(zipCode: value?.trim());
            },
            validator: (value) =>
                EventSubmitValidation.validateZipCode(value, 11, 4),
            hintText: 'Enter code',
          ),
          AppInput(
            controller: _addressController,
            labelText: 'Home Address',
            onSaved: (value) {
              ref
                  .read(formSubmissionControllerProvider.notifier)
                  .updateAddressInfo(address: value?.trim());
            },
            validator: (value) =>
                EventSubmitValidation.valisdateHomeAddres(value, 100, 3),
            maxLength: 100,
            hintText: 'Enter your address',
          ),
          Text(
            'Country',
            style: AppTextTheme.lightTextTheme.bodySmall,
          ),
          const SizedBox(
            height: Sizes.lg,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(Sizes.md),
                onTap: () {
                  openCountryPicker();
                },
                child: Container(
                  width: 100.w,
                  padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.md, vertical: Sizes.lg),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Sizes.md),
                      border: Border.all(color: AppColors.neutralColor)),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        countryPicker.isNotEmpty
                            ? countryPicker
                            : 'Pick a Country',
                        style: AppTextTheme.lightTextTheme.bodyLarge?.copyWith(
                            color: countryPicker.isNotEmpty
                                ? AppColors.backgroundDark
                                : AppColors.neutralColor,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        width: Sizes.md,
                      ),
                    ],
                  ),
                ),
              ),
              if (errorCountryPicker.isNotEmpty)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Text(
                    errorCountryPicker,
                    style: AppTextTheme.lightTextTheme.bodySmall
                        ?.copyWith(color: AppColors.errorColor),
                  ),
                ),
            ],
          ),
          const SizedBox(
            height: Sizes.xl,
          ),
          renderButton(false, () {
            final validateCountry =
                EventSubmitValidation.validateCountryPicker(countryPicker);

            _formKey.currentState?.validate();
            if (validateCountry != null) {
              setState(() {
                errorCountryPicker = validateCountry;
              });
              return;
            }
            if (_formKey.currentState?.validate() == true) {
              _formKey.currentState!.save();
              ref.read(stepHeaderControllerProvider.notifier).updateIndex(2);
            }

            if (validateCountry != null) {
              setState(() {
                errorCountryPicker = validateCountry;
              });
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
            .updateAddressInfo(country: country.name.trim());
        setState(() {
          countryPicker = country.name;
          errorCountryPicker = "";
        });
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
    _zipCodeController = TextEditingController();
    _addressController = TextEditingController();
    _zipCodeController.text =
        ref.read(formSubmissionControllerProvider).zipCode ?? "";
    _addressController.text =
        ref.read(formSubmissionControllerProvider).address ?? "";
    countryPicker = ref.read(formSubmissionControllerProvider).country ?? "";
  }
}
