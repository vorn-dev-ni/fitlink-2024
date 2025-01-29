import 'package:demo/features/home/views/map_display.dart';
import 'package:demo/utils/device/device_utils.dart';
import 'package:flutter/material.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Widget eventMapSection(LatLng map, String locationTitle) {
  return SliverToBoxAdapter(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: Sizes.md,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Map',
                style: AppTextTheme.lightTextTheme.labelLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  size: Sizes.md,
                  color: AppColors.secondaryColor,
                ),
                iconAlignment: IconAlignment.end,
                style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
                onPressed: () async {
                  await DeviceUtils.openMap(map.latitude, map.longitude);
                },
                label: Text(
                  'Get Directions',
                  style: AppTextTheme.lightTextTheme.bodyMedium
                      ?.copyWith(color: AppColors.secondaryColor),
                ),
              )
            ],
          ),
          MapDisplayLocation(
            locationTitle: locationTitle,
            lat: map.latitude,
            lng: map.longitude,
          )
        ],
      ),
    ),
  );
}
