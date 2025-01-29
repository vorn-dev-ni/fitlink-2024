import 'package:demo/common/widget/empty_content.dart';
import 'package:demo/common/widget/error_image_placeholder.dart';
import 'package:demo/features/home/controller/event/events_listing_controller.dart';
import 'package:demo/features/home/model/event.dart';
import 'package:demo/features/home/widget/event_skeleton_loading.dart';
import 'package:demo/features/other/not_found.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/formatters/formatter_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventGridList extends ConsumerStatefulWidget {
  final void Function(int index, Event eventId) onPress;
  const EventGridList({super.key, required this.onPress});

  @override
  ConsumerState<EventGridList> createState() => _EventGridListState();
}

class _EventGridListState extends ConsumerState<EventGridList> {
  @override
  Widget build(BuildContext context) {
    final eventsStream = ref.watch(eventsListingControllerProvider);

    return eventsStream.when(
      data: (data) {
        return data.isEmpty
            ? emptyContent(title: 'Oop, there are no events for today yet !!!')
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                  childAspectRatio: 0.7,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final events = data[index];
                  return InkWell(
                      highlightColor: AppColors.primaryColor,
                      hoverColor: AppColors.primaryColor,
                      onTap: () {
                        widget.onPress(index, events);
                      },
                      child: Stack(
                        children: [
                          Hero(
                            tag: 'event-$index',
                            child: FancyShimmerImage(
                              boxFit: BoxFit.cover,
                              errorWidget: errorImgplaceholder(),
                              shimmerBaseColor: index % 3 == 0
                                  ? const Color.fromARGB(255, 252, 245, 245)
                                  : const Color.fromARGB(255, 198, 195, 195),
                              imageUrl: events.feature,
                            ),
                          ),
                          Positioned(
                            top: Sizes.md,
                            left: Sizes.md,
                            child: Container(
                              padding: const EdgeInsets.all(Sizes.sm),
                              decoration: BoxDecoration(
                                  color:
                                      AppColors.neutralBlack.withOpacity(0.5),
                                  borderRadius:
                                      BorderRadius.circular(Sizes.md)),
                              child: Column(
                                children: [
                                  // Text(
                                  //   '${events.docId}',
                                  //   style: TextStyle(color: Colors.white),
                                  // ),
                                  Text(
                                    FormatterUtils.getFormattedMonth(
                                        events.preStartDate.toDate()),
                                    style: AppTextTheme
                                        .lightTextTheme.bodyMedium
                                        ?.copyWith(
                                            color: AppColors.backgroundLight,
                                            fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    events.preStartDate.toDate().day.toString(),
                                    style: AppTextTheme
                                        .lightTextTheme.bodyMedium
                                        ?.copyWith(
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
                                    style: AppTextTheme.lightTextTheme.bodyLarge
                                        ?.copyWith(
                                            color: AppColors.backgroundLight,
                                            fontWeight: FontWeight.w600),
                                  ),
                                  // Text(
                                  //   'by ${events.authorName}',
                                  //   maxLines: 2,
                                  //   overflow: TextOverflow.ellipsis,
                                  //   style: AppTextTheme.lightTextTheme.labelMedium
                                  //       ?.copyWith(
                                  //     color: AppColors.primaryColor,
                                  //   ),
                                  // ),
                                  // const SizedBox(
                                  //   height: 10,
                                  // ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        events.establishment,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextTheme
                                            .lightTextTheme.bodyMedium
                                            ?.copyWith(
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                      Text(
                                        events.freeEntry
                                            ? 'Free'
                                            : '\$ ${events.price}',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextTheme
                                            .lightTextTheme.bodyMedium
                                            ?.copyWith(
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
                },
              );
      },
      error: (error, stackTrace) {
        return emptyContent(title: error.toString());
      },
      loading: () {
        return const EventSkeletonLoading();
      },
    );
  }
}
