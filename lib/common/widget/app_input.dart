import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';

class AppInput extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData? prefixIcon;
  final String? placeholder;
  final ValueChanged<String>? onChanged;
  final int? maxLength;
  final String? labelText;

  const AppInput(
      {Key? key,
      this.hintText,
      this.placeholder = "Enter your text",
      this.controller,
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      this.prefixIcon,
      this.onChanged,
      this.labelText,
      this.maxLength = 50})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sizes.md),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        cursorColor: AppColors.primaryDark,
        obscureText: obscureText,
        maxLength: maxLength,
        maxLines: 1,
        onChanged: onChanged,
        autocorrect: false,
        decoration: InputDecoration(
            hintText: hintText,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: AppColors.primaryDark)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: AppColors.neutralColor)),
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            labelText: labelText,
            labelStyle: AppTextTheme.lightTextTheme.bodyMedium,
            helperText: ''),
      ),
    );
  }
}
