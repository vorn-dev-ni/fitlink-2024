import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/local_storage/local_storage_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';

class EuDialog extends StatefulWidget {
  const EuDialog({super.key});

  @override
  State<EuDialog> createState() => _EuDialogState();
}

class _EuDialogState extends State<EuDialog> {
  bool? _isAgreed;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.backgroundLight,
      title: Text(
        'End-User License Agreement',
        style: AppTextTheme.lightTextTheme.titleMedium,
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                'Please read and accept the terms below to continue using FitLink.',
                style: AppTextTheme.lightTextTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              Text(
                '1. Acceptance of Terms\n'
                'By accessing or using this application ("FitLink"), you agree to be bound by these Terms of Use. '
                'If you do not agree with any part of these terms, you must discontinue use immediately.\n\n'
                '2. User Responsibilities\n'
                'You agree to use FitLink only for lawful purposes and in compliance with all applicable regulations. '
                'You shall not misuse, modify, reverse-engineer, or attempt to gain unauthorized access to any part of the platform.\n\n'
                '3. Account Security\n'
                'You are responsible for maintaining the confidentiality of your account information, including your password. '
                'FitLink is not liable for any loss or damage resulting from unauthorized account access.\n\n'
                '4. Content and Usage\n'
                'FitLink may provide features such as training plans, performance tracking, and communication tools. '
                'You agree not to upload, distribute, or share any content that is harmful, abusive, defamatory, or violates any third-party rights.\n\n'
                '5. Health Disclaimer\n'
                'FitLink provides general fitness tracking and management tools but does not offer medical advice. '
                'Always consult a qualified healthcare provider before beginning any exercise program. '
                'Use of FitLink is entirely at your own risk.\n\n'
                '6. Data Collection and Privacy\n'
                'By using FitLink, you consent to the collection, storage, and processing of your data as described in our Privacy Policy. '
                'We may collect fitness data, device information, interactions, and other analytics to improve the service.\n\n'
                '7. Third-Party Integrations\n'
                'FitLink may integrate with third-party services (e.g., payment providers, fitness trackers). '
                'We are not responsible for the actions, data handling, or service availability of third-party platforms.\n\n'
                '8. License Grant\n'
                'FitLink grants you a limited, non-transferable, non-exclusive license to access and use the application for personal, non-commercial purposes. '
                'This license does not permit resale, distribution, or derivative works.\n\n'
                '9. Termination\n'
                'FitLink reserves the right to suspend or terminate your account at any time for violating these terms or engaging in harmful activities. '
                'Upon termination, your access to the platform and related services may be restricted.\n\n'
                '10. Limitation of Liability\n'
                'FitLink shall not be liable for any direct, indirect, incidental, or consequential damages arising from your use of the application. '
                'All content and services are provided on an "as-is" basis.\n\n'
                '11. Updates and Changes\n'
                'FitLink may update or modify these Terms of Use at any time. '
                'Continued use of the application after changes are posted constitutes acceptance of the updated terms.\n\n'
                '12. Governing Law\n'
                'These Terms of Use shall be governed by and interpreted in accordance with local laws applicable to the jurisdiction in which FitLink operates.\n\n'
                '13. Contact Information\n'
                'If you have any questions, concerns, or requests regarding these Terms, please contact our support team.\n',
                textAlign: TextAlign.justify,
                style: AppTextTheme.lightTextTheme.bodySmall,
              ),

              const SizedBox(height: 12),
              // The Mandatory Checkbox
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _isAgreed ?? false,
                    activeColor: AppColors.secondaryColor,
                    side: const BorderSide(
                      color: AppColors.secondaryColor,
                      width: 2,
                    ),
                    onChanged: (bool? newValue) async {
                      setState(() {
                        _isAgreed = newValue ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text(
                        'I confirm that I have read and agree to the EULA.',
                        style: AppTextTheme.lightTextTheme.titleSmall,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: _isAgreed != null
              ? () async {
                  await LocalStorageUtils().setBoolKey('hasAgree', false);
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                }
              : null,
          child: Text(
            'Decline',
            style: AppTextTheme.lightTextTheme.bodySmall?.copyWith(
                color: _isAgreed == null
                    ? AppColors.errorLight
                    : AppColors.errorColor),
          ),
        ),
        // Accept (Enabled only when agreed)
        ElevatedButton(
          onPressed: _isAgreed != null
              ? () async {
                  await LocalStorageUtils().setBoolKey('hasAgree', true);
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                }
              : null,
          child: Text(
            'Accept',
            style: AppTextTheme.lightTextTheme.bodySmall
                ?.copyWith(color: AppColors.primaryColor),
          ),
        ),
      ],
    );
  }
}
