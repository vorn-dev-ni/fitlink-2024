import 'package:demo/features/home/controller/event_create/event_form_controller.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class EventDatePickerCustom extends ConsumerStatefulWidget {
  const EventDatePickerCustom({super.key});

  @override
  ConsumerState<EventDatePickerCustom> createState() =>
      _EventDatePickerCustomState();
}

class _EventDatePickerCustomState extends ConsumerState<EventDatePickerCustom> {
  List<PickerDateRange>? dateRanges;
  PickerDateRange? singleDateRanges;
  late DateRangePickerController _datePickerController;

  @override
  void initState() {
    final dateRange = ref.read(eventFormControllerProvider);

    _datePickerController = DateRangePickerController();
    singleDateRanges = PickerDateRange(
      dateRange.preStartDate ?? DateTime.now(),
      dateRange.preEndDate ?? DateTime.now().add(const Duration(days: 1)),
    );
    _datePickerController.selectedRange = PickerDateRange(
      dateRange.preStartDate ?? DateTime.now(),
      dateRange.preEndDate ?? DateTime.now().add(const Duration(days: 1)),
    );
    _datePickerController.view = DateRangePickerView.month;

    _datePickerController.displayDate =
        dateRange.preStartDate ?? DateTime.now();

    super.initState();
  }

  @override
  void dispose() {
    _datePickerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final dateRange = ref.watch(eventFormControllerProvider);
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        leading: IconButton(
            onPressed: () {
              HelpersUtils.navigatorState(context).pop();
            },
            icon: const Icon(
              Icons.close,
              color: AppColors.backgroundLight,
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
                onPressed: () {
                  ref.read(eventFormControllerProvider.notifier).updateDateTime(
                      start: singleDateRanges?.startDate,
                      end: singleDateRanges?.endDate);
                  HelpersUtils.navigatorState(context).pop();
                },
                child: Text(
                  'Save',
                  style: AppTextTheme.lightTextTheme.bodyLarge
                      ?.copyWith(color: AppColors.backgroundLight),
                )),
          )
        ],
      ),
      body: SafeArea(
          child: SizedBox(
        width: 100.w,
        height: 100.h,
        child: SfDateRangePicker(
            controller: _datePickerController,
            enablePastDates: false,
            monthViewSettings: DateRangePickerMonthViewSettings(
                viewHeaderStyle: DateRangePickerViewHeaderStyle(
                    textStyle: AppTextTheme.lightTextTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.normal,
                        color: AppColors.secondaryColor))),
            headerHeight: 100,
            minDate: DateTime.now(),
            startRangeSelectionColor: AppColors.secondaryColor,
            endRangeSelectionColor:
                AppColors.secondaryColor, // Change to your preferred color
            rangeSelectionColor: AppColors.secondaryColor.withOpacity(0.5),
            headerStyle: const DateRangePickerHeaderStyle(
              backgroundColor:
                  AppColors.secondaryColor, // Custom header background
              textStyle: TextStyle(color: Colors.white, fontSize: 18),
            ),
            monthCellStyle: DateRangePickerMonthCellStyle(
              textStyle: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                  color: AppColors.secondaryColor), // Ensure full visibility
              todayTextStyle: TextStyle(color: AppColors.primaryColor),

              todayCellDecoration: const BoxDecoration(
                color: Color.fromARGB(255, 46, 187, 247),
                shape: BoxShape.circle,
              ),
              disabledDatesTextStyle:
                  TextStyle(color: Color.fromARGB(255, 226, 224, 224)),
            ),
            selectionMode: DateRangePickerSelectionMode.range,
            allowViewNavigation: true,
            showNavigationArrow: true,
            onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
              setState(() {
                singleDateRanges = args.value;
              });
            },
            backgroundColor:
                AppColors.backgroundLight // Change the overall background color
            ),
      )),
    );
  }
}
