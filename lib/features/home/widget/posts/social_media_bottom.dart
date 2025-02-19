import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SocialMediaBottom extends StatefulWidget {
  int? likes = 20;
  int? comments = 10;
  SocialMediaBottom({super.key, this.likes, this.comments});

  @override
  State<SocialMediaBottom> createState() => _SocialMediaBottomState();
}

class _SocialMediaBottomState extends State<SocialMediaBottom> {
  bool hasLiked = false;
  bool hasClick = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Sizes.lg, vertical: Sizes.lg),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                hasClick = true;
                hasLiked = !hasLiked;
              });
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  hasLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
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
                const SizedBox(
                  width: Sizes.xs,
                ),
                GestureDetector(onTap: () {}, child: Text('${widget.likes}')),
              ],
            ),
          ),
          const SizedBox(
            width: Sizes.sm,
          ),
          GestureDetector(
            onTap: () {
              HelpersUtils.navigatorState(context)
                  .pushNamed(AppPage.commentListings);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(CupertinoIcons.chat_bubble),
                const SizedBox(
                  width: Sizes.xs,
                ),
                Text('${widget.comments}'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
