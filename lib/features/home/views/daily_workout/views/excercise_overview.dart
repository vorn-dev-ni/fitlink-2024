import 'package:demo/common/widget/horidivider.dart';
import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/features/home/controller/workouts/activities_controller.dart';
import 'package:demo/features/home/controller/workouts/excercises_controller.dart';
import 'package:demo/features/home/controller/workouts/workout_date_controller.dart';
import 'package:demo/features/home/widget/excercise/excercise_item.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/formatters/formatter_utils.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ExcerciseOverviewScreen extends ConsumerStatefulWidget {
  @override
  _SliverAppBarExampleState createState() => _SliverAppBarExampleState();
}

class _SliverAppBarExampleState extends ConsumerState<ExcerciseOverviewScreen> {
  late ScrollController _scrollController;
  double _opacity = 1.0;
  String? docId = '';
  late Map<String, dynamic> workouts;

  @override
  void didChangeDependencies() {
    final result =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    if (result.containsKey('docId')) {
      docId = result['docId'];
    }
    if (result.containsKey('title')) {
      workouts = result;
    }

    super.didChangeDependencies();
  }

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
                  workouts['title'],
                  // textAlign: TextAlign.start,
                  style: AppTextTheme.lightTextTheme.bodyLarge
                      ?.copyWith(color: AppColors.backgroundLight),
                ),
                Row(
                  children: [
                    Text(
                      FormatterUtils.formatExerciseDuration(
                          workouts['duration']),
                      style: AppTextTheme.lightTextTheme.labelSmall
                          ?.copyWith(color: AppColors.backgroundLight),
                    ),
                    const SizedBox(width: 8),
                    horiDivider(),
                    const SizedBox(width: 8),
                    Text(
                      '${workouts['totalExcercises']} ${workouts['totalExcercises'] > 1 ? 'Excercises' : 'Excercises'}',
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
                    imageUrl: workouts['feature'] ??
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
        _build_excercises()
      ],
    ));
  }

  Widget _build_loader(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 140),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Skeletonizer(
              enabled: true,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: Sizes.md),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.neutralColor,
                      width: 1.0,
                    ),
                  ),
                ),
                child: excercise_item(context, index, null),
              ),
            );
          },
          childCount: 5,
        ),
      ),
    );
  }

  Widget _build_excercises() {
    final asyncValue = ref.watch(excercisesControllerProvider(docId ?? ""));
    final isLoading = ref.watch(appLoadingStateProvider);
    return asyncValue.when(
      data: (data) {
        return SliverPadding(
          padding: const EdgeInsets.only(bottom: 50),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final result = data![index];
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: Sizes.md),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.neutralColor,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: excercise_item(context, index, result),
                    ),
                    if (index == data.length - 1)
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () => _handleStartWorkout(data),
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: AppColors.secondaryColor,
                                  foregroundColor: AppColors.backgroundLight,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(Sizes.xxl),
                                  ),
                                  disabledBackgroundColor:
                                      const Color.fromARGB(255, 191, 194, 198),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: Sizes.lg,
                                      horizontal: Sizes.xxl),
                                ),
                                child: Text(
                                  isLoading ? 'Loading...' : 'Start Workout',
                                  style: AppTextTheme.lightTextTheme.titleMedium
                                      ?.copyWith(
                                          color: isLoading
                                              ? const Color.fromARGB(
                                                  255, 108, 108, 113)
                                              : AppColors.backgroundLight),
                                ),
                              )))
                  ],
                );
              },
              childCount: data?.length,
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        return Text(error.toString());
      },
      loading: () {
        return _build_loader(context);
      },
    );
  }

  void _handleStartWorkout(data) async {
    try {
      final selectedDate = ref.read(workoutDateControllerProvider);

      ref.read(appLoadingStateProvider.notifier).setState(true);

      await ref.read(activitiesControllerProvider(null).notifier).addWorkout(
          uid: FirebaseAuth.instance.currentUser!.uid,
          activities: null,
          workoutId: workouts['docId'],
          date: selectedDate);

      if (mounted) {
        DateTime normalizedDate =
            DateTime(selectedDate!.year, selectedDate.month, selectedDate.day);
        ref.invalidate(activitiesControllerProvider(normalizedDate));
        ref.read(appLoadingStateProvider.notifier).setState(false);
        HelpersUtils.navigatorState(context)
            .pushNamed(AppPage.excerciseDetail, arguments: {
          'excercises': data,
          'total_duration': workouts['duration'],
          'title': workouts['title'],
          'date': workouts['date'],
          'id': workouts['docId']
        });
      }
    } catch (e) {
      if (mounted) {
        ref.read(appLoadingStateProvider.notifier).setState(false);
      }
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: AppColors.errorColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
