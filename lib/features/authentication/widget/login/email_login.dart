import 'package:demo/common/widget/app_input.dart';
import 'package:demo/common/widget/button.dart';
import 'package:demo/features/authentication/widget/login/divider_auth.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo/utils/theme/text/text_theme.dart';

class EmailLoginTab extends ConsumerStatefulWidget {
  const EmailLoginTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EmailLoginTabState();
}

class _EmailLoginTabState extends ConsumerState<EmailLoginTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: Sizes.xl,
          ),
          AppInput(
            hintText: 'hello@example.com',
            placeholder: 'hello@example.com',
            labelText: 'Email Address',
            maxLength: 50,
          ),
          AppInput(
            hintText: '',
            obscureText: true,
            maxLength: 8,
            placeholder: 'hello@example.com',
            labelText: 'Password',
          ),
          Container(
            alignment: Alignment.centerRight,
            child: TextButton(
                onPressed: null,
                child: Text('Forgot password?',
                    textAlign: TextAlign.end,
                    style: AppTextTheme.lightTextTheme.bodySmall?.copyWith(
                        color: AppColors.secondaryColor,
                        fontWeight: FontWeight.w500))),
          ),
          ButtonApp(
              height: 18,
              splashColor: const Color.fromARGB(255, 207, 225, 255),
              label: "Login",
              onPressed: null,
              radius: 0,
              textStyle: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                  color: AppColors.backgroundLight,
                  fontWeight: FontWeight.w500) as dynamic,
              color: AppColors.secondaryColor,
              textColor: Colors.white,
              elevation: 0),
          dividerAuth(),
          Column(
            children: [
              ButtonApp(
                  height: 18,
                  splashColor: const Color.fromARGB(255, 207, 225, 255),
                  label: "Continue with Facebook",
                  onPressed: null,
                  radius: 0,
                  textStyle: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                      color: AppColors.backgroundLight,
                      fontWeight: FontWeight.w500) as dynamic,
                  color: AppColors.secondaryColor,
                  textColor: Colors.white,
                  elevation: 0),
              const SizedBox(
                height: Sizes.lg,
              ),
            ],
          )
        ],
      ),
    );
  }
}
