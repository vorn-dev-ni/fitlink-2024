import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sizer/sizer.dart';

class ProfileHeader extends StatefulWidget {
  final String imageUrl;
  final ProfileType type;
  final bool showBackButton;
  final BuildContext? context;
  final String? desc;

  const ProfileHeader({
    Key? key,
    required this.imageUrl,
    this.context,
    this.desc,
    this.type = ProfileType.post,
    this.showBackButton = false,
  }) : super(key: key);

  @override
  _ProfileHeaderState createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  bool hasLiked = false;
  bool hasClick = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.sm),
      child: widget.type == ProfileType.post
          ? Row(
              children: [
                ClipOval(
                  child: Container(
                    child: Assets.app.defaultAvatar
                        .image(width: 40, height: 40, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: Sizes.md),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('gymmiumiu19'),
                    Text(
                      'Workout Tag',
                      style: AppTextTheme.lightTextTheme.bodySmall
                          ?.copyWith(color: AppColors.secondaryColor),
                    )
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    CupertinoIcons.ellipsis,
                    size: Sizes.iconMd,
                    color: AppColors.secondaryColor,
                  ),
                )
              ],
            )
          : Row(
              children: [
                if (widget.showBackButton)
                  GestureDetector(
                    onTap: () {
                      HelpersUtils.navigatorState(widget.context!).pop();
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(left: Sizes.md),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                  ),
                ClipOval(
                  child: Container(
                    child: Assets.app.defaultAvatar
                        .image(width: 40, height: 40, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: Sizes.md),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Panhavorn',
                      style: AppTextTheme.lightTextTheme.bodySmall,
                    ),
                    SizedBox(
                      width: 65.w,
                      child: Text(
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        widget.desc ?? "",
                        style: AppTextTheme.lightTextTheme.bodyMedium
                            ?.copyWith(color: AppColors.secondaryColor),
                      ),
                    )
                  ],
                ),
                const Spacer(),
                if (widget.type == ProfileType.profile)
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      CupertinoIcons.ellipsis,
                      size: Sizes.iconMd,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                if (widget.type == ProfileType.comment)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        hasClick = true;
                        hasLiked = !hasLiked;
                      });
                    },
                    child: Column(
                      children: [
                        Icon(
                          hasLiked
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,
                          color: hasLiked ? AppColors.errorColor : null,
                        )
                            .animate(
                                target: hasLiked ? 1 : 0,
                                autoPlay: false,
                                onComplete: (controller) {
                                  if (hasClick)
                                    controller.forward().then(
                                      (value) {
                                        controller.reverse();
                                      },
                                    );
                                })
                            .scale(
                              begin: const Offset(1, 1),
                              end: const Offset(1.4, 1.4),
                              curve: Curves.easeInOut,
                              duration: const Duration(milliseconds: 200),
                            ),
                        Text(
                          '20',
                          style: AppTextTheme.lightTextTheme.labelSmall,
                        )
                      ],
                    ),
                  )
              ],
            ),
    );
  }
}
