import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppInput extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final String? placeholder;
  final Function(String? value)? validator;
  final Function(String? value)? onSaved;
  final ValueChanged<String>? onChanged;
  final int? maxLength;
  final String? labelText;
  final String? optionalText;
  final Widget? prefix;
  final bool? isEnable;
  final Widget? suffix;
  final Function? onPress;
  final int? maxLines;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? formatter;

  const AppInput(
      {super.key,
      this.focusNode,
      this.hintText,
      this.onSaved,
      this.onPress,
      this.validator,
      this.suffix,
      this.isEnable = true,
      this.maxLines = 1,
      this.placeholder = "Enter your text",
      this.controller,
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      this.prefixIcon,
      this.prefix,
      this.onChanged,
      this.optionalText,
      this.labelText,
      this.formatter,
      this.maxLength = 50});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sizes.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (labelText != null)
            Padding(
              padding: const EdgeInsets.only(bottom: Sizes.sm),
              child: Row(
                children: [
                  Text(labelText!),
                  if (optionalText != null)
                    Text(
                      optionalText!,
                      style: const TextStyle(color: AppColors.errorColor),
                    ),
                ],
              ),
            ),
          TextFormField(
            controller: controller,
            focusNode: focusNode,
            selectionControls: materialTextSelectionControls,
            validator: (value) {
              // debugPrint("Value is ${value}");
              return validator != null ? validator!(value) : null;
            },
            onSaved: (newValue) {
              onSaved != null ? onSaved!(newValue) : null;
            },
            keyboardType: keyboardType,
            cursorColor: AppColors.secondaryColor,
            obscureText: obscureText,
            maxLength: maxLength,
            readOnly: isEnable! ? false : true,
            maxLines: maxLines,
            onChanged: onChanged,
            autocorrect: false,
            onTap: () {
              if (onPress != null) {
                onPress!();
              }
            },
            inputFormatters: formatter,
            style: AppTextTheme.lightTextTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.w400),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: AppColors.neutralColor),
              counterText: "",
              suffixIcon: suffix,
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: AppColors.errorColor)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: AppColors.errorColor)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: AppColors.primaryLight)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: AppColors.neutralColor)),
              prefixIcon: prefixIcon,
              prefix: prefix,
              // labelText: labelText,
              labelStyle: AppTextTheme.lightTextTheme.labelLarge,
            ),
          ),
        ],
      ),
    );
  }
}
