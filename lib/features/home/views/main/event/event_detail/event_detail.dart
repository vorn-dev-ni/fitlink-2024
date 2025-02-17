import 'package:demo/common/widget/error_image_placeholder.dart';
import 'package:demo/common/widget/image_modal_viewer.dart';
import 'package:demo/features/home/model/event.dart';
import 'package:demo/features/home/views/main/event/event_detail/event_desc.dart';
import 'package:demo/features/home/views/main/event/event_detail/event_header.dart';
import 'package:demo/features/home/views/main/event/event_detail/event_interest.dart';
import 'package:demo/features/home/views/main/event/event_detail/event_map.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/formatters/formatter_utils.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventDetail extends ConsumerStatefulWidget {
  const EventDetail({super.key});

  @override
  ConsumerState<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends ConsumerState<EventDetail> {
  String tag = "";

  Event? event;
  @override
  void didChangeDependencies() {
    final result =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    if (result.containsKey('tag')) {
      tag = result['tag'];
      event = result['event'];
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark, // For iOS
    ));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          if (event != null) appBar(context, event!),
          if (event != null)
            eventHeaderSection(
                address: event!.address,
                endTime:
                    FormatterUtils.getFormattedTime(event!.timeStart.toDate()),
                establishment: event!.establishment,
                isFree: event!.freeEntry,
                startTime:
                    FormatterUtils.getFormattedTime(event!.endTime.toDate()),
                title: event!.eventTitle,
                price: event!.price?.toString() ?? ""),
          EventDesc(desc: event!.descriptions),
          if (event != null)
            eventMapSection(
                LatLng(
                  event!.lat,
                  event!.lng,
                ),
                event!.establishment),
          if (event != null)
            EventBottomInterest(
                users: event!.participants,
                desc: event!.descriptions,
                feature: event!.feature,
                docId: event!.docId,
                title: event!.eventTitle),
        ],
      ),
    );
  }

  SliverAppBar appBar(BuildContext context, Event event) {
    return SliverAppBar(
      expandedHeight: 300,
      leading: IconButton(
        style: IconButton.styleFrom(
            padding: const EdgeInsets.only(left: Sizes.sm),
            backgroundColor: AppColors.backgroundDark.withOpacity(0.5)),
        icon: const Icon(Icons.arrow_back_ios,
            color: Colors.white), // Custom back button
        onPressed: () {
          HelpersUtils.navigatorState(context).pop();
        },
      ),
      pinned: true,
      stretch: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(''),
        collapseMode: CollapseMode.parallax,
        stretchModes: const [
          StretchMode.zoomBackground,
        ],
        background: Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ZoomableImage(
                      imageUrl: event.feature,
                    );
                  },
                );
              },
              child: Hero(
                tag: tag,
                child: FancyShimmerImage(
                    imageUrl: event.feature,
                    boxFit: BoxFit.cover,
                    errorWidget: errorImgplaceholder()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
