import 'package:demo/common/widget/error_fallback.dart';
import 'package:demo/common/widget/error_image_placeholder.dart';
import 'package:demo/features/home/controller/event/event_detail_participant.dart';
import 'package:demo/features/home/controller/event/events_detail_controller.dart';
import 'package:demo/features/home/controller/profile/profile_user_controller.dart';
import 'package:demo/features/home/model/event.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/device/device_utils.dart';
import 'package:demo/utils/exception/app_exception.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:demo/common/widget/button.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EventBottomInterest extends ConsumerStatefulWidget {
  final List<Participant> users;
  final String title;
  final String desc;
  final String feature;
  final String docId;

  const EventBottomInterest({
    required this.users,
    required this.title,
    required this.desc,
    required this.feature,
    required this.docId,
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _EventBottomInterestState createState() => _EventBottomInterestState();
}

class _EventBottomInterestState extends ConsumerState<EventBottomInterest> {
  bool isInterested = false;
  late List<Participant>? mutateUsers;

  @override
  void initState() {
    mutateUsers = widget.users.length > 6
        ? widget.users.sublist(0, 6).toList()
        : widget.users;
    super.initState();
  }

  void toggleInterest(avatarImageUser) {
    if (FirebaseAuth.instance.currentUser == null) {
      HelpersUtils.navigatorState(context).pushNamed(AppPage.auth);
      return;
    }
    ref.read(eventsDetailControllerProvider.notifier).joinEvents(widget.docId);
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    if (!isInterested) {
      HelpersUtils.showErrorSnackbar(
          context,
          'Join Confirmed',
          duration: 2000,
          'You have successfully expressed interest in this event!',
          StatusSnackbar.success);

      mutateUsers?.add(Participant(
          userId: FirebaseAuth.instance.currentUser!.uid,
          avatarImage: avatarImageUser));
    } else {
      mutateUsers?.removeWhere(
        (element) => element.userId == FirebaseAuth.instance.currentUser?.uid,
      );
      HelpersUtils.showErrorSnackbar(
          context,
          'Unjoined Event',
          duration: 2000,
          'You have declined in joining this event at the moment.',
          StatusSnackbar.failed);
    }
    isInterested = !isInterested;

    setState(() {});
  }

  Future<void> shareEvent() async {
    await DeviceUtils.shareMedia(
      desc: widget.desc,
      feature: widget.feature,
      title: widget.title,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(profileUserControllerProvider);
    debugPrint("Re render event detail");
    isInterested = isExisted() ?? false;
    return user.when(
      data: (data) {
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Sizes.lg, vertical: Sizes.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: Sizes.md,
                ),
                if (isInterested)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Sizes.lg),
                    child: Text(
                      'You are participating in this event *',
                      style: AppTextTheme.lightTextTheme.bodyMedium
                          ?.copyWith(color: AppColors.secondaryColor),
                    ),
                  ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: mutateUsers?.length.toString(),
                        style: AppTextTheme.lightTextTheme.labelLarge?.copyWith(
                          color: AppColors.secondaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                        children: [
                          TextSpan(
                            text: ' People Joined',
                            style: AppTextTheme.lightTextTheme.labelLarge
                                ?.copyWith(
                              color: AppColors.neutralBlack,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: Sizes.md,
                    ),
                    if (mutateUsers != null && mutateUsers!.isNotEmpty)
                      Expanded(
                        child: SizedBox(
                          width: 100,
                          height: 20,
                          child: Stack(
                            children: [
                              ListUser(mutateUsers: mutateUsers),
                            ],
                          ),
                        ),
                      ),
                    Row(
                      children: [
                        IconButton(
                          style: IconButton.styleFrom(
                            overlayColor: AppColors.secondaryColor,
                            highlightColor:
                                AppColors.primaryColor.withOpacity(0.25),
                            side: const BorderSide(
                                width: 1, color: AppColors.secondaryColor),
                          ),
                          onPressed: shareEvent,
                          icon: SvgPicture.asset(
                            Assets.icon.svg.share,
                            width: 20,
                            height: 20,
                            fit: BoxFit.cover,
                            colorFilter: const ColorFilter.mode(
                              AppColors.secondaryColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        ButtonApp(
                          label: isInterested ? 'Not Interest' : 'Interest',
                          height: 14,
                          elevation: 0,
                          radius: 0,
                          color: isInterested
                              ? AppColors.errorColor
                              : AppColors.secondaryColor,
                          textStyle: AppTextTheme.lightTextTheme.bodyMedium!
                              .copyWith(color: AppColors.backgroundLight),
                          splashColor: AppColors.primaryColor,
                          onPressed: () => toggleInterest(
                              data?.avatar ?? ""), // Toggle the interest state
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      error: (error, stackTrace) => errorFallback(
          cb: () {},
          AppException(
            title: "Oops",
            message: error.toString(),
          )),
      loading: () => buildLoading(),
    );
  }

  Widget buildLoading() {
    return Skeletonizer(
      enabled: true,
      child: SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Sizes.lg, vertical: Sizes.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: Sizes.md,
              ),
              if (isInterested)
                Padding(
                  padding: const EdgeInsets.only(bottom: Sizes.lg),
                  child: Text(
                    'You are participating in this event *',
                    style: AppTextTheme.lightTextTheme.bodyMedium
                        ?.copyWith(color: AppColors.secondaryColor),
                  ),
                ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: mutateUsers?.length.toString(),
                      style: AppTextTheme.lightTextTheme.labelLarge?.copyWith(
                        color: AppColors.secondaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                      children: [
                        TextSpan(
                          text: ' People Joined',
                          style:
                              AppTextTheme.lightTextTheme.labelLarge?.copyWith(
                            color: AppColors.neutralBlack,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: Sizes.md,
                  ),
                  if (mutateUsers!.isNotEmpty)
                    Expanded(
                      child: SizedBox(
                        height: 20,
                        child: Stack(
                          children: [
                            ListView.builder(
                              itemCount: mutateUsers?.length,
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final user = mutateUsers![index];

                                return Transform.translate(
                                  offset: Offset(index * -10, 0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color: AppColors.neutralColor),
                                      borderRadius:
                                          BorderRadius.circular(Sizes.xxxl),
                                    ),
                                    child: ClipOval(
                                      child: user.avatarImage.isEmpty
                                          ? Assets.app.defaultAvatar.image(
                                              width: 44,
                                              height: 50,
                                              fit: BoxFit.cover)
                                          : FancyShimmerImage(
                                              boxFit: BoxFit.cover,
                                              width: 20,
                                              height: 50,
                                              imageUrl: user.avatarImage,
                                              errorWidget:
                                                  errorImgplaceholder()),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  Row(
                    children: [
                      IconButton(
                        style: IconButton.styleFrom(
                          overlayColor: AppColors.secondaryColor,
                          highlightColor:
                              AppColors.primaryColor.withOpacity(0.25),
                          side: const BorderSide(
                              width: 1, color: AppColors.secondaryColor),
                        ),
                        onPressed: shareEvent,
                        icon: SvgPicture.asset(
                          Assets.icon.svg.share,
                          width: 20,
                          height: 20,
                          fit: BoxFit.cover,
                          colorFilter: const ColorFilter.mode(
                            AppColors.secondaryColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      ButtonApp(
                          label: isInterested ? 'Not Interest !!!' : 'Interest',
                          height: 14,
                          elevation: 0,
                          radius: 0,
                          color: isInterested
                              ? AppColors.errorColor
                              : AppColors.secondaryColor,
                          textStyle: AppTextTheme.lightTextTheme.bodyMedium!
                              .copyWith(color: AppColors.backgroundLight),
                          splashColor: AppColors.primaryColor,
                          onPressed: () =>
                              toggleInterest("") // Toggle the interest state
                          ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool? isExisted() {
    if (FirebaseAuth.instance.currentUser != null) {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      return widget.users.any(
        (element) => element.userId.contains(uid),
      );
    }

    return false;
  }
}

class ListUser extends ConsumerStatefulWidget {
  const ListUser({
    super.key,
    required this.mutateUsers,
  });

  final List<Participant>? mutateUsers;

  @override
  ConsumerState<ListUser> createState() => _ListUserState();
}

class _ListUserState extends ConsumerState<ListUser> {
  @override
  Widget build(BuildContext context) {
    debugPrint("Length is ${widget.mutateUsers?.length}");
    return ListView.builder(
      itemCount: widget.mutateUsers?.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final user = widget.mutateUsers![index];
        final auth = ref.watch(
            eventDetailParticipantProvider(widget.mutateUsers![index].userId));
        return auth.when(
          data: (data) {
            final result = data;
            return Transform.translate(
              offset: Offset(index * -10, 0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: AppColors.neutralColor),
                  borderRadius: BorderRadius.circular(Sizes.xxxl),
                ),
                child: ClipOval(
                  child: result?.avatar == null && result?.avatar == ""
                      ? Assets.app.defaultAvatar
                          .image(width: 20, height: 50, fit: BoxFit.cover)
                      : FancyShimmerImage(
                          boxFit: BoxFit.cover,
                          width: 20,
                          height: 50,
                          imageUrl: result?.avatar ?? "",
                          errorWidget: Assets.app.defaultAvatar
                              .image(width: 20, height: 50, fit: BoxFit.cover)),
                ),
              ),
            );
          },
          error: (error, stackTrace) => Text(
            error.toString(),
            style: AppTextTheme.lightTextTheme.labelSmall,
          ),
          loading: () => Skeletonizer(
              enabled: true,
              child: Transform.translate(
                offset: Offset(index * -10, 0),
                child: ClipOval(
                  child: user.avatarImage.isEmpty
                      ? Assets.app.defaultAvatar
                          .image(width: 20, height: 50, fit: BoxFit.cover)
                      : FancyShimmerImage(
                          boxFit: BoxFit.cover,
                          width: 20,
                          height: 50,
                          imageUrl: user.avatarImage,
                          errorWidget: errorImgplaceholder()),
                ),
              )),
        );
      },
    );
  }
}
