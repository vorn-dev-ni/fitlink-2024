import 'package:demo/features/home/model/event.dart';
import 'package:demo/features/home/views/main/event/event_grid_list.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/image_asset.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class EventTabs extends StatefulWidget {
  const EventTabs({super.key});

  @override
  State<EventTabs> createState() => _TabForYouState();
}

class _TabForYouState extends State<EventTabs> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          FancyShimmerImage(
            boxFit: BoxFit.cover,
            height: 270,
            width: 100.w,
            alignment: Alignment.center,
            imageUrl:
                'https://i.pinimg.com/736x/40/a2/cc/40a2cc94f0149b7c8e73fa8017c87d54.jpg',
            errorWidget: Image.network(
              ImageAsset.errorPlaceholderImage,
              fit: BoxFit.contain,
              height: 140,
              width: 100.w,
            ),
          ),
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
}
