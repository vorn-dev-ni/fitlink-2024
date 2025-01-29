import 'package:demo/features/home/controller/submission/step_header_controller.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventFormHeader extends ConsumerStatefulWidget {
  const EventFormHeader({super.key});

  @override
  ConsumerState<EventFormHeader> createState() => _EventFormHeaderState();
}

class _EventFormHeaderState extends ConsumerState<EventFormHeader> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          top: 0,
          child: Divider(
            color: AppColors.backgroundDark,
            height: 21,
          ),
        ),
        Positioned.fill(
          // top: 0,
          top: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              headerBadge(index: 1),
              headerBadge(index: 2),
              headerBadge(index: 3),
            ],
          ),
        ),
      ],
    );
  }

  Widget headerBadge({bool showDivider = true, required int index}) {
    final stepIndex = ref.watch(stepHeaderControllerProvider);

    return Badge(
      label: Text(
        '$index',
        style: AppTextTheme.lightTextTheme.bodyMedium
            ?.copyWith(color: AppColors.backgroundLight),
      ),
      largeSize: 40,
      padding: const EdgeInsets.all(Sizes.lg),
      backgroundColor: stepIndex + 1 == index
          ? AppColors.secondaryColor
          : const Color.fromARGB(255, 224, 223, 223),
    );
  }
}
