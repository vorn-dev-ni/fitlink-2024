import 'package:demo/common/widget/error_image_placeholder.dart';
import 'package:demo/features/home/views/main/comments/comment_overview.dart';
import 'package:demo/features/home/widget/posts/post_panel.dart';
import 'package:demo/features/home/widget/posts/profile_user.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/device/device_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom_release_unzoom/pinch_zoom_release_unzoom.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CommentMain extends StatefulWidget {
  const CommentMain({super.key});

  @override
  State<CommentMain> createState() => _CommentMainState();
}

class _CommentMainState extends State<CommentMain> {
  bool blockScroll = false;
  bool hasClickTap = false;
  bool isAnimating = false;
  ScrollController controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        DeviceUtils.hideKeyboard(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: renderAppBar(context),
        resizeToAvoidBottomInset: false,
        bottomSheet: renderBottomSheet(context),
        body: renderBody(),
      ),
    );
  }

  AppBar renderAppBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      leadingWidth: 100.w,
      leading: ProfileHeader(
          context: context,
          desc: 'Vacation',
          imageUrl: 'profileheader',
          type: ProfileType.header,
          showBackButton: true),
    );
  }

  Widget renderBody() {
    return SafeArea(
        child: SingleChildScrollView(
      controller: controller,
      physics: blockScroll
          ? const NeverScrollableScrollPhysics()
          : const ScrollPhysics(),
      child: Column(
        children: [
          PostPanel(
            url: null,
            showHeader: false,
            twoFingersOn: () => setState(() => blockScroll = true),
            twoFingersOff: () => Future.delayed(
              PinchZoomReleaseUnzoomWidget.defaultResetDuration,
              () => setState(() => blockScroll = false),
            ),
          ),
          const SizedBox(
            height: Sizes.md,
          ),
          renderComments(),
        ],
      ),
    ));
  }

  Widget renderBottomSheet(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(Sizes.lg),
        child: SizedBox(
          height: 8.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipOval(
                child: true
                    ? Container(
                        child: Assets.app.defaultAvatar
                            .image(width: 40, height: 40, fit: BoxFit.cover),
                      )
                    : FancyShimmerImage(
                        boxFit: BoxFit.cover,
                        width: 40,
                        height: 40,
                        imageUrl:
                            "https://images.unsplash.com/photo-1633332755192-727a05c4013d?q=80&w=2360&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                        errorWidget: errorImgplaceholder()),
              ),
              const SizedBox(
                width: Sizes.sm,
              ),
              Expanded(
                  child: TextField(
                autofocus: true,
                style: AppTextTheme.lightTextTheme.bodyMedium,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.neutralColor)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primaryColor)),
                    hintText: 'Add a comment...',
                    hintStyle: TextStyle(color: AppColors.neutralDark)),
              )),
              const SizedBox(
                width: Sizes.sm,
              ),
              IconButton(
                  onPressed: () {
                    DeviceUtils.hideKeyboard(context);
                  },
                  icon: const Icon(
                    Icons.send,
                    color: AppColors.secondaryColor,
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget renderComments() {
    return CommentOverview();
  }
}
