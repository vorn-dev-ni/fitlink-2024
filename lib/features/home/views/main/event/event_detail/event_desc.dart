import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/theme/text/text_theme.dart';

class EventDesc extends StatefulWidget {
  final String desc;
  const EventDesc({super.key, this.desc = ""});

  @override
  State<EventDesc> createState() => _EventDescState();
}

class _EventDescState extends State<EventDesc> {
  late final String desc;
  bool readMore = false;

  @override
  void initState() {
    desc = widget.desc.length > 80
        ? "${widget.desc.substring(0, 79)}..."
        : widget.desc;
    if (widget.desc.length > 80) {
      readMore = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: Sizes.md,
            ),
            const Row(
              mainAxisSize: MainAxisSize.max,
              children: [],
            ),
            Text(
              'Description',
              style: AppTextTheme.lightTextTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: Sizes.sm,
            ),
            RichText(
              text: TextSpan(
                  text: readMore ? "$desc " : widget.desc,
                  style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                    height: 2,
                  ),
                  children: [
                    if (widget.desc.length > 50)
                      TextSpan(
                          text: readMore ? 'Show More' : 'Show Less',
                          style: AppTextTheme.lightTextTheme.bodyMedium
                              ?.copyWith(
                                  color: AppColors.secondaryColor,
                                  height: 2,
                                  fontWeight: FontWeight.w600),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // debugPrint("Reading more ");
                              setState(() {
                                readMore = !readMore;
                              });
                            })
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
