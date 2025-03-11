import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

class NotificationItem extends StatefulWidget {
  final String avatar;
  final String username;
  final String message;
  final String time;
  final bool showFollowButton;
  final VoidCallback onPress;
  final VoidCallback? onFollow;

  const NotificationItem({
    super.key,
    required this.avatar,
    required this.username,
    required this.message,
    required this.time,
    required this.showFollowButton,
    required this.onPress,
    this.onFollow,
  });

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  bool hasFollowing = false;

  @override
  void initState() {
    hasFollowing = widget.showFollowButton;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: AppColors.neutralColor),
        ),
      ),
      child: ListTile(
        tileColor: AppColors.backgroundLight,
        leading: widget.avatar.isEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Assets.app.defaultAvatar.image(fit: BoxFit.cover),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: FancyShimmerImage(
                  imageUrl: widget.avatar,
                  boxFit: BoxFit.cover,
                  width: 55,
                  height: 55,
                ),
              ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.username,
              style: AppTextTheme.lightTextTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              widget.time,
              style: AppTextTheme.lightTextTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
        subtitle: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 10.0),
                child: Text(
                  widget.message,
                  style: AppTextTheme.lightTextTheme.bodySmall?.copyWith(
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 2,
                ),
              ),
            ),
            const SizedBox(width: 6),
            if (hasFollowing)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    hasFollowing = !hasFollowing;
                  });

                  widget.onFollow != null ? widget.onFollow!() : null;
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 2.0,
                    horizontal: 20.0,
                  ),
                ),
                child: const Text(
                  'Follow back',
                  style: TextStyle(fontSize: 13),
                ),
              ),
          ],
        ),
        onTap: widget.onPress,
      ),
    );
  }
}
