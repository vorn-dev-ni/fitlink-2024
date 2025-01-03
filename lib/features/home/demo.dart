import 'package:demo/core/riverpod/app_setting.dart';
import 'package:demo/features/other/app_info.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:demo/utils/localization/translation_helper.dart';

class DemoScreen extends ConsumerStatefulWidget {
  const DemoScreen({super.key});

  @override
  ConsumerState<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends ConsumerState<DemoScreen> {
  @override
  Widget build(BuildContext context) {
    final appSettings = ref.watch(appSettingsControllerProvider);
    return SizedBox(
      height: 100.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(tr(context).welcome,
                style:
                    AppTextTheme.getTextTheme(appSettings.appTheme!).bodyLarge),
            const AppInfo(),
          ],
        ),
      ),
    );
  }
}
