import 'package:flutter/material.dart';

const double BUBBLE_RADIUS_IMAGE = 16.0; // Set this to your desired radius

class BubbleCustomImage extends StatelessWidget {
  static const loadingWidget = Center(
    child: CircularProgressIndicator(),
  );

  final String id;
  final Widget image;
  final double bubbleRadius;
  final bool isSender;
  final Color color;
  final bool tail;
  final bool sent;
  final bool delivered;
  final bool seen;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsets? margin;
  final EdgeInsets? padding;

  const BubbleCustomImage({
    Key? key,
    required this.id,
    required this.image,
    this.bubbleRadius = BUBBLE_RADIUS_IMAGE,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.fromLTRB(16, 8, 16, 8),
    this.leading,
    this.trailing,
    this.isSender = true,
    this.color = Colors.white70,
    this.tail = true,
    this.sent = false,
    this.delivered = false,
    this.seen = false,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  /// image bubble builder method
  @override
  Widget build(BuildContext context) {
    bool stateTick = false;
    Icon? stateIcon;
    if (sent) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (delivered) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (seen) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF92DEDA),
      );
    }

    return Row(
      children: <Widget>[
        isSender
            ? const Expanded(
                child: SizedBox(
                  width: 5,
                ),
              )
            : leading ?? Container(),
        Flexible(
          child: Container(
            padding: padding,
            margin: margin,
            width: 230,
            height: 230,
            child: GestureDetector(
              child: Hero(
                tag: id,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(bubbleRadius),
                          topRight: Radius.circular(bubbleRadius),
                          bottomLeft: Radius.circular(tail
                              ? isSender
                                  ? bubbleRadius
                                  : 0
                              : BUBBLE_RADIUS_IMAGE),
                          bottomRight: Radius.circular(tail
                              ? isSender
                                  ? 0
                                  : bubbleRadius
                              : BUBBLE_RADIUS_IMAGE),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(bubbleRadius),
                          child: FittedBox(
                            // Ensure the image fits within the bubble
                            fit: BoxFit.cover,
                            child: image,
                          ),
                        ),
                      ),
                    ),
                    if (stateIcon != null && stateTick)
                      Positioned(
                        bottom: 4,
                        right: 6,
                        child: stateIcon!,
                      ),
                  ],
                ),
              ),
              onLongPress: onLongPress,
              onTap: onTap ??
                  () {
                    // Navigator.push(context, MaterialPageRoute(builder: (_) {
                    //   return _DetailScreen(
                    //     tag: id,
                    //     image: image,
                    //   );
                    // }));
                  },
            ),
          ),
        ),
        if (isSender && trailing != null) const SizedBox.shrink(),
      ],
    );
  }
}
