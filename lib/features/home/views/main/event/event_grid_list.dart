import 'package:demo/common/widget/cache_network_img.dart';
import 'package:demo/common/widget/empty_content.dart';
import 'package:demo/features/home/controller/event/events_listing_controller.dart';
import 'package:demo/features/home/model/event.dart';
import 'package:demo/features/home/views/main/event/event_submission/event_skeleton_item.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/formatters/formatter_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EventGridList extends ConsumerStatefulWidget {
  final void Function(int index, Event eventId) onPress;
  const EventGridList({super.key, required this.onPress});

  @override
  ConsumerState<EventGridList> createState() => _EventGridListState();
}

class _EventGridListState extends ConsumerState<EventGridList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final eventsStream = ref.watch(eventsListingControllerProvider);

    return eventsStream.when(
      data: (data) {
        return data.isEmpty
            ? emptyContent(title: 'Oop, there are no events for today yet !!!')
            : Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: StaggeredGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                  children: [
                    StaggeredGridTile.fit(
                      crossAxisCellCount: 2,
                      child: _buildEventItem(0, data[0]),
                    ),
                    ...List.generate(
                      data.length - 1,
                      (index) => StaggeredGridTile.fit(
                        crossAxisCellCount: 1,
                        child: _buildEventItem(index + 1, data[index + 1]),
                      ),
                    ),
                  ],
                ),
              );
      },
      error: (error, stackTrace) {
        return emptyContent(title: error.toString());
      },
      loading: () =>
          _buildGridLoading(List.generate(6, (_) => null), isLoading: true),
    );
  }

  Widget _buildGridLoading(List<Event?> data, {required bool isLoading}) {
    return Skeletonizer(
      enabled: true,
      ignorePointers: true,
      justifyMultiLineText: false,

      effect: const ShimmerEffect(
          highlightColor: Colors.white,
          baseColor: Color.fromARGB(212, 213, 213, 213)),

      ignoreContainers: true,

      // containersColor: AppColors.neutralBlack,
      // containersColor: AppColors.backgroundDark,

      child: StaggeredGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        children: List.generate(
          data.length,
          (index) => StaggeredGridTile.fit(
              crossAxisCellCount: index == 0 ? 2 : 1,
              child: const EventItemSkeleton()),
        ),
      ),
    );
  }

  Widget _buildEventItem(int index, Event events) {
    return InkWell(
        hoverColor: AppColors.primaryColor,
        onTap: () {
          widget.onPress(index, events);
        },
        child: Stack(
          children: [
            Hero(
              tag: 'event-$index',
              key: ValueKey(events.feature),
              child: CahceImageNetwork(
                index: index,
                feature: events.feature,
              ),
            ),
            Positioned(
              top: Sizes.md,
              left: Sizes.md,
              child: Container(
                padding: const EdgeInsets.all(Sizes.sm),
                decoration: BoxDecoration(
                    color: AppColors.neutralBlack.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(Sizes.md)),
                child: Column(
                  children: [
                    Text(
                      FormatterUtils.getFormattedMonth(
                          events.preStartDate.toDate()),
                      style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                          color: AppColors.backgroundLight,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      events.preStartDate.toDate().day.toString(),
                      style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.lg, vertical: Sizes.md),
                decoration: BoxDecoration(
                  color: AppColors.neutralBlack.withOpacity(0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      events.eventTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextTheme.lightTextTheme.bodyLarge?.copyWith(
                          color: AppColors.backgroundLight,
                          fontWeight: FontWeight.w600),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          width: 25.w,
                          child: Text(
                            events.establishment,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextTheme.lightTextTheme.bodyMedium
                                ?.copyWith(
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                        Text(
                          events.freeEntry ? 'Free' : '\$ ${events.price}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
