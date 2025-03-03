import 'dart:io';
import 'package:demo/common/model/transparent_container.dart';
import 'package:demo/common/model/user_model.dart';
import 'package:demo/common/widget/bottom_upload_sheet.dart';
import 'package:demo/common/widget/empty_content.dart';
import 'package:demo/common/widget/error_image_placeholder.dart';
import 'package:demo/common/widget/image_modal_viewer.dart';
import 'package:demo/features/home/views/single_profile/controller/media_tag_conroller.dart';
import 'package:demo/features/home/views/single_profile/controller/single_user_controller.dart';
import 'package:demo/features/home/views/profile/user_media.dart';
import 'package:demo/features/home/views/single_profile/widget/follow_msg.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/exception/app_exception.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SingleProfileHeader extends ConsumerStatefulWidget {
  final Function onLogout;
  String? uid;
  SingleProfileHeader({super.key, required this.onLogout, required this.uid});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends ConsumerState<SingleProfileHeader> {
  @override
  Widget build(BuildContext context) {
    final asyncUser = ref.watch(singleUserControllerProvider(widget.uid ?? ""));
    return asyncUser.when(
      error: (error, stackTrace) {
        return emptyContent(title: error.toString());
      },
      loading: () {
        return _buildLoading(context);
      },
      data: (data) {
        final currentUser = data;
        final showLoading =
            currentUser?.email == null || currentUser?.email == "";
        return SliverAppBar(
          expandedHeight: 60.h,
          stretch: true,
          leadingWidth: 70,
          leading: Container(
            width: 50,
            height: 50,
            margin: const EdgeInsets.only(left: Sizes.xl),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.6),
            ),
            child: IconButton(
              iconSize: Sizes.iconMd,
              onPressed: () {
                HelpersUtils.navigatorState(context).pop();
              },
              icon: const Icon(CupertinoIcons.back, color: Colors.white),
            ),
          ),
          backgroundColor: Colors.transparent,
          flexibleSpace: Skeletonizer(
            enabled: showLoading,
            child: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                stretchModes: const [StretchMode.zoomBackground],
                background: Stack(
                  children: [
                    Positioned.fill(
                        child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ZoomableImage(
                              imageUrl: currentUser?.cover_feature != ""
                                  ? currentUser!.cover_feature!
                                  : "https://cdn.statically.io/gh/Anime-Sama/IMG/img/contenu/dumbbell-nan-kilo-moteru.jpg",
                            );
                          },
                        );
                      },
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: FancyShimmerImage(
                              imageUrl: currentUser?.cover_feature != null &&
                                      currentUser!.cover_feature != ""
                                  ? currentUser.cover_feature!
                                  : 'https://cdn.statically.io/gh/Anime-Sama/IMG/img/contenu/dumbbell-nan-kilo-moteru.jpg',
                              boxFit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ],
                      ),
                    )),
                    Positioned(
                      top: 45,
                      left: 12,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color.fromARGB(255, 233, 235, 237),
                            width: 2,
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ZoomableImage(
                                  imageUrl: currentUser?.avatar != "" &&
                                          currentUser?.avatar != null
                                      ? currentUser!.avatar!
                                      : "https://cdn3d.iconscout.com/3d/premium/thumb/man-avatar-3d-icon-download-in-png-blend-fbx-gltf-file-formats--men-people-male-pack-avatars-icons-5187871.png?f=webp",
                                );
                              },
                            );
                          },
                          child: ClipOval(
                            child: currentUser?.avatar != "" &&
                                    currentUser?.avatar != null
                                ? FancyShimmerImage(
                                    errorWidget: errorImgplaceholder(),
                                    width: 100,
                                    height: 100,
                                    boxFit: BoxFit.cover,
                                    imageUrl: currentUser?.avatar ?? "")
                                : Assets.app.defaultAvatar.image(
                                    width: 100,
                                    height: 100,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(Sizes.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 90.w,
                                  child: transparentContainer(
                                    child: Text(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      '${currentUser?.fullname}',
                                      style: AppTextTheme
                                          .lightTextTheme.headlineMedium
                                          ?.copyWith(
                                        color: AppColors.backgroundLight,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: Sizes.md,
                                ),
                                transparentContainer(
                                  child: SizedBox(
                                    width: 85.w,
                                    child: Text(
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      currentUser?.bio == null ||
                                              currentUser?.bio == ""
                                          ? "This user has no bio yet !!!"
                                          : currentUser!.bio!,
                                      style: AppTextTheme
                                          .lightTextTheme.bodyMedium
                                          ?.copyWith(
                                              color: AppColors.backgroundLight,
                                              fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: Sizes.md,
                                ),
                              ],
                            ),
                            FollowMessageWidget(
                                userId: widget.uid,
                                unfollow: () async {
                                  final thisUserId =
                                      FirebaseAuth.instance.currentUser?.uid;
                                  if (thisUserId != null) {
                                    await ref
                                        .read(singleUserControllerProvider(
                                                currentUser?.id ?? "")
                                            .notifier)
                                        .unfollowingUser(
                                            thisUserId, currentUser?.id ?? "");
                                  }
                                },
                                following: () async {
                                  final thisUserId =
                                      FirebaseAuth.instance.currentUser?.uid;
                                  if (thisUserId != null) {
                                    await ref
                                        .read(singleUserControllerProvider(
                                                currentUser?.id ?? "")
                                            .notifier)
                                        .followingUser(
                                            thisUserId, currentUser?.id ?? "");
                                  }
                                }),
                            RenderMediaStatus(currentUser)
                          ],
                        ),
                      ),
                    )
                  ],
                )),
          ),
        );
      },
    );
  }

  Widget RenderMediaStatus(AuthModel? currentUser) {
    final async = ref.watch(mediaTagConrollerProvider(currentUser?.id ?? ""));
    return async.when(
      data: (data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 95.w,
              child: transparentContainer(
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: userSocialMediaTab(
                            floatingText: '${data?.workoutCounts ?? 0}',
                            type: 'Workouts')),
                    Expanded(
                        child: userSocialMediaTab(
                            floatingText: '${data?.followingCount ?? 0}',
                            type: 'Followings')),
                    Expanded(
                        child: userSocialMediaTab(
                            floatingText: '${data?.followerCount ?? 0}',
                            type: 'Followers'))
                  ],
                ),
              ),
            )
          ],
        );
      },
      loading: () {
        return Skeletonizer(
          enabled: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 95.w,
                child: transparentContainer(
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: userSocialMediaTab(
                              floatingText: '0', type: 'Workouts')),
                      Expanded(
                          child: userSocialMediaTab(
                              floatingText: '${currentUser?.followingCount}',
                              type: 'Followings')),
                      Expanded(
                          child: userSocialMediaTab(
                              floatingText: '${currentUser?.followerCount}',
                              type: 'Followers'))
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
      error: (error, stackTrace) {
        return emptyContent(title: error.toString());
      },
    );
  }

  Widget _buildLoading(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 60.h,
      backgroundColor: AppColors.backgroundDark,
      flexibleSpace: FlexibleSpaceBar(
          background: Stack(
        children: [
          Positioned.fill(
              child: Stack(
            children: [
              Positioned.fill(
                child: FancyShimmerImage(
                  imageUrl:
                      'https://cdn.statically.io/gh/Anime-Sama/IMG/img/contenu/dumbbell-nan-kilo-moteru.jpg',
                  boxFit: BoxFit.cover,
                ),
              ),
              Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ],
          )),
          Positioned(
            bottom: 10,
            child: Padding(
              padding: const EdgeInsets.all(Sizes.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      transparentContainer(
                        child: Text(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          '',
                          style: AppTextTheme.lightTextTheme.headlineMedium
                              ?.copyWith(color: AppColors.backgroundLight),
                        ),
                      ),
                      const SizedBox(
                        height: Sizes.md,
                      ),
                      transparentContainer(
                        child: SizedBox(
                          width: 85.w,
                          child: Text(
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            "This user has no bio yet !!!",
                            style: AppTextTheme.lightTextTheme.bodyMedium
                                ?.copyWith(
                                    color: AppColors.backgroundLight,
                                    fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: Sizes.md,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            clipBehavior: Clip.antiAlias,
                            child: TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor
                                        .withOpacity(0.15),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(Sizes.lg))),
                                onPressed: () {},
                                child: const Text('Edit Profile')),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: Sizes.md,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 95.w,
                        child: transparentContainer(
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: userSocialMediaTab(
                                      floatingText: '0', type: 'Workouts')),
                              Expanded(
                                  child: userSocialMediaTab(
                                      floatingText: '0', type: 'Followings')),
                              Expanded(
                                  child: userSocialMediaTab(
                                      floatingText: '0', type: 'Followers'))
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      )),
    );
  }

  void _uploadingImage(UploadType type, String? oldImage) async {
    try {
      File? fileImage = await HelpersUtils.pickImage(
          type == UploadType.photo ? ImageSource.gallery : ImageSource.camera);
      if (fileImage != null) {
        File? compressImage =
            await HelpersUtils.cropAndCompressImage(fileImage.path);
        if (compressImage != null) {
          debugPrint("Compress image");
          if (mounted) {
            HelpersUtils.navigatorState(context).pushNamed(AppPage.previewImage,
                arguments: {
                  'compressImage': compressImage,
                  'oldimage': oldImage
                });
          }
        }
      }
    } catch (e) {
      if (mounted && e is AppException) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        HelpersUtils.showErrorSnackbar(
            duration: 3000, context, 'Oop!', e.message, StatusSnackbar.failed);
      }
    } finally {
      setState(() {});
    }
  }

  void _openBottomSheet(BuildContext context, String? oldImage) {
    showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.backgroundLight,
        builder: (context) {
          return BottomUploadImage(
            context,
            (type) {
              _uploadingImage(type, oldImage);
            },
          );
        });
  }
}
