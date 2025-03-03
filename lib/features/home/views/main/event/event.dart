import 'package:demo/features/home/controller/tab/event_scroll_controller.dart';
import 'package:demo/features/home/model/event.dart';
import 'package:demo/features/home/views/main/event/event_grid_list.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventTabs extends ConsumerStatefulWidget {
  const EventTabs({super.key});

  @override
  ConsumerState<EventTabs> createState() => _TabForYouState();
}

class _TabForYouState extends ConsumerState<EventTabs>
    with AutomaticKeepAliveClientMixin<EventTabs> {
  @override
  Widget build(BuildContext context) {
    final scrollController = ref.watch(eventScrollControllerProvider);
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: [
          EventGridList(
            onPress: (int index, Event event) {
              HelpersUtils.navigatorState(context).pushNamed(
                  AppPage.eventDetail,
                  arguments: {'tag': 'event-${index}', 'event': event});
            },
          )
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
