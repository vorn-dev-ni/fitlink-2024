import 'package:demo/features/home/model/event.dart';
import 'package:demo/features/home/views/main/event/event_grid_list.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:flutter/material.dart';

class EventTabs extends StatefulWidget {
  const EventTabs({super.key});

  @override
  State<EventTabs> createState() => _TabForYouState();
}

class _TabForYouState extends State<EventTabs>
    with AutomaticKeepAliveClientMixin<EventTabs> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
