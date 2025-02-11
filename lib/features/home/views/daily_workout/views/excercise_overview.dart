import 'package:demo/common/widget/horidivider.dart';
import 'package:demo/features/home/widget/excercise/excercise_item.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ExcerciseOverviewScreen extends StatefulWidget {
  @override
  _SliverAppBarExampleState createState() => _SliverAppBarExampleState();
}

class _SliverAppBarExampleState extends State<ExcerciseOverviewScreen> {
  late ScrollController _scrollController;
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_updateOpacity);
  }

  void _updateOpacity() {
    double offset = _scrollController.offset;
    double newOpacity = (1 - (offset / 200)).clamp(0.0, 1.0);
    setState(() {
      _opacity = newOpacity;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateOpacity);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 150.0,
            pinned: true,
            stretch: true,
            foregroundColor: AppColors.backgroundLight,
            backgroundColor: Colors.black,
            leading: Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 6),
              child: GestureDetector(
                onTap: () {
                  HelpersUtils.navigatorState(context).pop();
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: Sizes.iconMd,
                ),
              ),
            ),
            floating: false,
            centerTitle: false,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              collapseMode: CollapseMode.parallax,
              stretchModes: const [StretchMode.zoomBackground],
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Squat Lost Weight",
                    // textAlign: TextAlign.start,
                    style: AppTextTheme.lightTextTheme.bodyLarge
                        ?.copyWith(color: AppColors.backgroundLight),
                  ),
                  Row(
                    children: [
                      Text(
                        '20 Mins',
                        style: AppTextTheme.lightTextTheme.labelSmall
                            ?.copyWith(color: AppColors.backgroundLight),
                      ),
                      const SizedBox(width: 8),
                      horiDivider(),
                      const SizedBox(width: 8),
                      Text(
                        '10 Exercises',
                        style: AppTextTheme.lightTextTheme.labelSmall
                            ?.copyWith(color: AppColors.backgroundLight),
                      ),
                    ],
                  ),
                ],
              ),
              background: Stack(
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
              ),
            ),
          ),
          _build_excercises(),
        ],
      ),
    );
  }

  Widget _build_excercises() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: Sizes.md),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColors.neutralColor,
                width: 1.0,
              ),
            ),
          ),
          child: excercise_item(context, index),
        ),
        childCount: 30,
      ),
    );
  }
}
