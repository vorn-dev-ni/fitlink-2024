import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class EventTimePicker extends ConsumerStatefulWidget {
  final TimeSelection timeselection;
  final DateTime? initialTime;
  final Function(DateTime) onSaveTime;

  const EventTimePicker({
    super.key,
    required this.timeselection,
    required this.initialTime,
    required this.onSaveTime,
  });

  @override
  ConsumerState<EventTimePicker> createState() => _EventTimePickerState();
}

class _EventTimePickerState extends ConsumerState<EventTimePicker> {
  late DateTime? time;
  @override
  void initState() {
    time = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child: Text(
                    "Cancel",
                    style: AppTextTheme.lightTextTheme.bodyLarge?.copyWith(
                        color: AppColors.errorColor,
                        fontWeight: FontWeight.w500),
                  ),
                  onPressed: () {
                    HelpersUtils.navigatorState(context).pop();
                  },
                ),
                CupertinoButton(
                  child: Text(
                    "Done",
                    style: AppTextTheme.lightTextTheme.bodyLarge?.copyWith(
                        color: AppColors.secondaryColor,
                        fontWeight: FontWeight.w500),
                  ),
                  onPressed: () {
                    widget.onSaveTime(time ?? DateTime.now());
                    HelpersUtils.navigatorState(context).pop();
                  },
                ),
              ],
            ),
          ),
          // Date Picker
          Expanded(
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              initialDateTime: widget.initialTime ?? DateTime.now(),
              use24hFormat: false,
              onDateTimeChanged: (DateTime newTime) {
                // onSaveTime(newTime);
                setState(() {
                  time = newTime;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
