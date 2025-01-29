import 'package:demo/common/widget/error_image_placeholder.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:demo/utils/constant/app_colors.dart';
part 'navbar_controller.g.dart';

@Riverpod(keepAlive: true)
class NavbarController extends _$NavbarController {
  @override
  List<BottomNavigationBarItem> build() {
    return [
      BottomNavigationBarItem(
        icon: Column(
          children: [
            SvgPicture.asset(
              Assets.icon.svg.house,
              fit: BoxFit.cover,
              colorFilter: const ColorFilter.mode(
                  AppColors.backgroundLight, BlendMode.srcIn),
              width: 25,
              height: 25,
            ),
            const SizedBox(
              height: 4,
            ),
            Opacity(
              opacity: 0.0,
              child: SvgPicture.asset(
                Assets.icon.svg.dotIndicator,
                fit: BoxFit.cover,
                colorFilter: const ColorFilter.mode(
                    AppColors.neutralBlack, BlendMode.hardLight),
                width: 7,
                height: 7,
              ),
            ),
          ],
        ),
        activeIcon: Column(
          children: [
            SvgPicture.asset(
              Assets.icon.svg.house,
              fit: BoxFit.cover,
              colorFilter: const ColorFilter.mode(
                  AppColors.backgroundLight, BlendMode.srcIn),
              width: 25,
              height: 25,
            ),
            const SizedBox(
              height: 4,
            ),
            SvgPicture.asset(
              Assets.icon.svg.dotIndicator,
              fit: BoxFit.cover,
              colorFilter: const ColorFilter.mode(
                  AppColors.backgroundLight, BlendMode.srcIn),
              width: 7,
              height: 7,
            ),
          ],
        ),
        label: '',
      ),
      BottomNavigationBarItem(
        icon: Column(
          children: [
            SvgPicture.asset(
              Assets.icon.svg.chat,
              fit: BoxFit.cover,
              colorFilter: const ColorFilter.mode(
                  AppColors.backgroundLight, BlendMode.srcIn),
              width: 25,
              height: 25,
            ),
            const SizedBox(
              height: 4,
            ),
            Opacity(
              opacity: 0.0,
              child: SvgPicture.asset(
                Assets.icon.svg.dotIndicator,
                fit: BoxFit.cover,
                colorFilter: const ColorFilter.mode(
                    AppColors.neutralBlack, BlendMode.hardLight),
                width: 7,
                height: 7,
              ),
            ),
          ],
        ),
        activeIcon: Column(
          children: [
            SvgPicture.asset(
              Assets.icon.svg.chat,
              fit: BoxFit.cover,
              colorFilter: const ColorFilter.mode(
                  AppColors.backgroundLight, BlendMode.srcIn),
              width: 25,
              height: 25,
            ),
            const SizedBox(
              height: 4,
            ),
            SvgPicture.asset(
              Assets.icon.svg.dotIndicator,
              fit: BoxFit.cover,
              colorFilter: const ColorFilter.mode(
                  AppColors.backgroundLight, BlendMode.srcIn),
              width: 7,
              height: 7,
            ),
          ],
        ),
        label: '',
      ),
      BottomNavigationBarItem(
        icon: Column(
          children: [
            SvgPicture.asset(
              Assets.icon.svg.plus,
              fit: BoxFit.cover,
              colorFilter: const ColorFilter.mode(
                  AppColors.backgroundLight, BlendMode.srcIn),
              width: 25,
              height: 25,
            ),
            const SizedBox(
              height: 4,
            ),
            Opacity(
              opacity: 0.0,
              child: SvgPicture.asset(
                Assets.icon.svg.dotIndicator,
                fit: BoxFit.cover,
                colorFilter: const ColorFilter.mode(
                    AppColors.neutralBlack, BlendMode.hardLight),
                width: 7,
                height: 7,
              ),
            ),
          ],
        ),
        activeIcon: Column(
          children: [
            SvgPicture.asset(
              Assets.icon.svg.plus,
              fit: BoxFit.cover,
              colorFilter: const ColorFilter.mode(
                  AppColors.backgroundLight, BlendMode.srcIn),
              width: 25,
              height: 25,
            ),
            const SizedBox(
              height: 4,
            ),
            SvgPicture.asset(
              Assets.icon.svg.dotIndicator,
              fit: BoxFit.cover,
              colorFilter: const ColorFilter.mode(
                  AppColors.backgroundLight, BlendMode.srcIn),
              width: 7,
              height: 7,
            ),
          ],
        ),
        label: '',
      ),
      BottomNavigationBarItem(
        icon: Column(
          children: [
            SvgPicture.asset(
              Assets.icon.svg.dumbell,
              fit: BoxFit.cover,
              colorFilter: const ColorFilter.mode(
                  AppColors.backgroundLight, BlendMode.srcIn),
              width: 25,
              height: 25,
            ),
            const SizedBox(
              height: 4,
            ),
            Opacity(
              opacity: 0.0,
              child: SvgPicture.asset(
                Assets.icon.svg.dotIndicator,
                fit: BoxFit.cover,
                colorFilter: const ColorFilter.mode(
                    AppColors.neutralBlack, BlendMode.hardLight),
                width: 7,
                height: 7,
              ),
            ),
          ],
        ),
        activeIcon: Column(
          children: [
            SvgPicture.asset(
              Assets.icon.svg.dumbell,
              fit: BoxFit.cover,
              colorFilter: const ColorFilter.mode(
                  AppColors.backgroundLight, BlendMode.srcIn),
              width: 25,
              height: 25,
            ),
            const SizedBox(
              height: 4,
            ),
            SvgPicture.asset(
              Assets.icon.svg.dotIndicator,
              fit: BoxFit.cover,
              colorFilter: const ColorFilter.mode(
                  AppColors.backgroundLight, BlendMode.srcIn),
              width: 7,
              height: 7,
            ),
          ],
        ),
        label: '',
      ),
      BottomNavigationBarItem(
        tooltip: 'profile',
        icon: Column(
          children: [
            SvgPicture.asset(
              Assets.icon.svg.circle,
              fit: BoxFit.cover,
              colorFilter: const ColorFilter.mode(
                  AppColors.backgroundLight, BlendMode.srcIn),
              width: 25,
              height: 25,
            ),
            const SizedBox(
              height: 4,
            ),
            Opacity(
              opacity: 0.0,
              child: SvgPicture.asset(
                Assets.icon.svg.dotIndicator,
                fit: BoxFit.cover,
                colorFilter: const ColorFilter.mode(
                    AppColors.neutralBlack, BlendMode.hardLight),
                width: 7,
                height: 7,
              ),
            ),
          ],
        ),
        activeIcon: Column(
          children: [
            SvgPicture.asset(
              Assets.icon.svg.circle,
              fit: BoxFit.cover,
              colorFilter: const ColorFilter.mode(
                  AppColors.backgroundLight, BlendMode.srcIn),
              width: 25,
              height: 25,
            ),
            const SizedBox(
              height: 4,
            ),
            SvgPicture.asset(
              Assets.icon.svg.dotIndicator,
              fit: BoxFit.cover,
              colorFilter: const ColorFilter.mode(
                  AppColors.backgroundLight, BlendMode.srcIn),
              width: 7,
              height: 7,
            ),
          ],
        ),
        label: '',
      ),
    ];
  }

  void updateProfileTab(String avatar) {
    state = state.map(
      (e) {
        if (e.tooltip == "profile") {
          e = BottomNavigationBarItem(
            icon: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Sizes.lg),
                      border: Border.all(
                          width: 1, color: AppColors.backgroundLight)),
                  child: ClipOval(
                    child: avatar.isEmpty
                        ? Assets.app.defaultAvatar
                            .image(width: 20, height: 20, fit: BoxFit.cover)
                        : FancyShimmerImage(
                            boxFit: BoxFit.cover,
                            boxDecoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: AppColors.backgroundLight)),
                            width: 20,
                            height: 20,
                            errorWidget: errorImgplaceholder(),
                            imageUrl: avatar,
                          ),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Opacity(
                  opacity: 0.0,
                  child: SvgPicture.asset(
                    Assets.icon.svg.dotIndicator,
                    fit: BoxFit.cover,
                    colorFilter: const ColorFilter.mode(
                        AppColors.neutralBlack, BlendMode.hardLight),
                    width: 7,
                    height: 7,
                  ),
                ),
              ],
            ),
            activeIcon: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Sizes.lg),
                      border: Border.all(
                          width: 1, color: AppColors.backgroundLight)),
                  child: ClipOval(
                    child: avatar.isEmpty
                        ? Assets.app.defaultAvatar
                            .image(width: 20, height: 20, fit: BoxFit.cover)
                        : FancyShimmerImage(
                            boxFit: BoxFit.cover,
                            boxDecoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: AppColors.backgroundLight)),
                            width: 20,
                            height: 20,
                            errorWidget: errorImgplaceholder(),
                            imageUrl: avatar,
                          ),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                SvgPicture.asset(
                  Assets.icon.svg.dotIndicator,
                  fit: BoxFit.cover,
                  colorFilter: const ColorFilter.mode(
                      AppColors.backgroundLight, BlendMode.srcIn),
                  width: 7,
                  height: 7,
                ),
              ],
            ),
            label: '',
          );
        }
        return e;
      },
    ).toList();
  }
}
