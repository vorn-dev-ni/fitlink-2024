import 'package:demo/common/widget/app_loading.dart';
import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/features/home/controller/workouts/activities_controller.dart';
import 'package:demo/features/home/views/single_profile/controller/media_tag_conroller.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/formatters/formatter_utils.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ExcerciseSuccess extends ConsumerStatefulWidget {
  const ExcerciseSuccess({super.key});

  @override
  ConsumerState<ExcerciseSuccess> createState() => _ExcerciseSuccessState();
}

class _ExcerciseSuccessState extends ConsumerState<ExcerciseSuccess>
    with TickerProviderStateMixin {
  String? isSelected = '';
  late AudioPlayer _playSoundNextSet;
  late AudioPlayer _finishSound;
  late AudioPlayer _sussySound;
  late int totalSet;
  late int totalDuration;
  late int totalExcercises;
  late String title;
  late String workoutId;
  late DateTime date;
  late bool showSurpriseEffect;
  late AnimationController _lottieController; // Declare the Lottie controller

  @override
  void initState() {
    _lottieController = AnimationController(vsync: this);

    _finishSound = AudioPlayer();
    _sussySound = AudioPlayer();
    _playSoundNextSet = AudioPlayer();
    playCongratSound();
    showSurpriseEffect = true;

    super.initState();
  }

  @override
  void didChangeDependencies() {
    final routeParams =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    title = routeParams['title'];
    workoutId = routeParams['id'];
    date = routeParams['date'];
    totalSet = routeParams['total_set'];
    totalDuration = routeParams['total_duration'];
    totalExcercises = routeParams['total_excercises'];
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _finishSound.dispose();
    _playSoundNextSet.dispose();
    _lottieController.dispose();

    super.dispose();
  }

  void playCongratSound() async {
    try {
      await _finishSound.setAsset(Assets.audio.ty);
      await _sussySound.setAsset(Assets.audio.ohGod);
      await _playSoundNextSet.setAsset(Assets.audio.yay);
      _sussySound.setVolume(0.8);
      _playSoundNextSet.setVolume(1);
      _playSoundNextSet.play();
      _finishSound.play();
    } catch (e) {
      debugPrint("Error loading audio: $e");
    }
  }

  Future playExitSound() async {
    try {
      _finishSound.setVolume(1);
      _finishSound.play();
      ref.read(appLoadingStateProvider.notifier).setState(true);
      await ref
          .read(activitiesControllerProvider(
                  null, FirebaseAuth.instance.currentUser?.uid ?? "")
              .notifier)
          .updateWorkoutCompleted(workoutId: workoutId, datetime: date);

      if (mounted) {
        ref.invalidate(mediaTagConrollerProvider(
            FirebaseAuth.instance.currentUser?.uid ?? ""));
        ref.read(appLoadingStateProvider.notifier).setState(false);
        HelpersUtils.navigatorState(context).pop();
        HelpersUtils.navigatorState(context).pop();
        HelpersUtils.navigatorState(context).pop();
      }
    } catch (e) {
      ref.read(appLoadingStateProvider.notifier).setState(false);
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: AppColors.errorColor,
          textColor: Colors.white,
          fontSize: 16.0);
      debugPrint("Error loading audio: $e");
    }
  }

  Future playClickSound() async {
    try {
      await _sussySound.stop();
      await _sussySound.seek(Duration.zero);
      _sussySound.play();
    } catch (e) {
      debugPrint("Error loading audio: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(appLoadingStateProvider);
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 50.h,
              pinned: true,
              stretch: true,
              foregroundColor: AppColors.backgroundLight,
              backgroundColor: Colors.black,
              floating: true,
              centerTitle: false,
              leading: null,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                collapseMode: CollapseMode.parallax,
                stretchModes: const [StretchMode.zoomBackground],
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "WORKOUT COMPLETED!!!",
                      style: AppTextTheme.lightTextTheme.headlineSmall
                          ?.copyWith(
                              color: AppColors.backgroundLight,
                              fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                background: Stack(
                  children: [
                    Positioned.fill(
                      child: FancyShimmerImage(
                        imageUrl:
                            'https://i.pinimg.com/736x/06/9c/ce/069cce91104498e06957335fd5e5921b.jpg',
                        boxFit: BoxFit.cover,
                        alignment: Alignment.center,
                      ),
                    ),
                    Positioned(
                        child: Container(
                      color: AppColors.backgroundDark.withOpacity(0.6),
                    )),
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black,
                              Colors.black87,
                              Colors.black54, // Midway fade
                              Colors.transparent,
                            ],
                            stops: [
                              0.0,
                              0.2,
                              0.4,
                              1.0
                            ], // Control fade transition
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Lottie.asset(
                        controller: _lottieController,
                        Assets.lotties.surpise,
                        fit: BoxFit.cover,
                        onLoaded: (composition) {
                          final extendedDuration = composition.duration * 1;
                          _lottieController
                            ..duration = extendedDuration
                            ..forward();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverMainAxisGroup(slivers: [
              SliverToBoxAdapter(
                child: Text(title,
                    style: AppTextTheme.lightTextTheme.headlineMedium?.copyWith(
                        color: AppColors.backgroundLight,
                        fontWeight: FontWeight.w600)),
              ),
              SliverToBoxAdapter(
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: Sizes.lg, horizontal: Sizes.xs),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('$totalExcercises',
                                style: AppTextTheme
                                    .lightTextTheme.headlineMedium
                                    ?.copyWith(
                                        color: AppColors.backgroundLight,
                                        fontWeight: FontWeight.w600)),
                            Text('Excercises',
                                style: AppTextTheme.lightTextTheme.bodyLarge
                                    ?.copyWith(
                                        color: AppColors.neutralColor,
                                        fontWeight: FontWeight.w400)),
                          ],
                        ),
                        VerticalDivider(
                          thickness: 1,
                          width: 1,
                          color: AppColors.backgroundLight.withOpacity(0.4),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('$totalSet',
                                style: AppTextTheme
                                    .lightTextTheme.headlineMedium
                                    ?.copyWith(
                                        color: AppColors.backgroundLight,
                                        fontWeight: FontWeight.w600)),
                            Text('Total Sets',
                                style: AppTextTheme.lightTextTheme.bodyLarge
                                    ?.copyWith(
                                        color: AppColors.neutralColor,
                                        fontWeight: FontWeight.w400)),
                          ],
                        ),
                        VerticalDivider(
                          thickness: 1,
                          width: 1,
                          color: AppColors.backgroundLight.withOpacity(0.4),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                FormatterUtils.formatToAlarmClock(
                                    totalDuration),
                                style: AppTextTheme
                                    .lightTextTheme.headlineMedium
                                    ?.copyWith(
                                        color: AppColors.backgroundLight,
                                        fontWeight: FontWeight.w600)),
                            Text('Duration',
                                style: AppTextTheme.lightTextTheme.bodyLarge
                                    ?.copyWith(
                                        color: AppColors.neutralColor,
                                        fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: Sizes.lg, horizontal: Sizes.xs),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('How do you feel',
                          style: AppTextTheme.lightTextTheme.headlineSmall
                              ?.copyWith(
                                  color: AppColors.backgroundLight,
                                  fontWeight: FontWeight.w600)),
                      const SizedBox(
                        height: Sizes.xxl,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              playClickSound();
                              setState(() {
                                isSelected = 'easy';
                              });
                            },
                            child: Column(
                              children: [
                                Text('😎',
                                    style: AppTextTheme
                                        .lightTextTheme.displayLarge
                                        ?.copyWith(
                                            color: AppColors.neutralColor,
                                            fontWeight: FontWeight.w400)),
                                Text('Easy',
                                    style: AppTextTheme.lightTextTheme.bodyLarge
                                        ?.copyWith(
                                            color: AppColors.neutralColor,
                                            fontWeight: FontWeight.w400)),
                              ],
                            )
                                .animate(target: isSelected == 'easy' ? 1 : 0)
                                .scale(
                                    begin: const Offset(1, 1),
                                    end: const Offset(1.3, 1.3),
                                    duration: 300.ms),
                          ), //,
                          GestureDetector(
                            onTap: () {
                              playClickSound();

                              setState(() {
                                isSelected = 'normal';
                              });
                            },
                            child: Column(
                              children: [
                                Text('😅',
                                    style: AppTextTheme
                                        .lightTextTheme.displayLarge
                                        ?.copyWith(
                                            color: AppColors.neutralColor,
                                            fontWeight: FontWeight.w400)),
                                Text('Just Right',
                                    style: AppTextTheme.lightTextTheme.bodyLarge
                                        ?.copyWith(
                                            color: AppColors.neutralColor,
                                            fontWeight: FontWeight.w400)),
                              ],
                            )
                                .animate(target: isSelected == 'normal' ? 1 : 0)
                                .scale(
                                    begin: const Offset(1, 1),
                                    end: const Offset(1.3, 1.3),
                                    duration: 300.ms),
                          ),
                          GestureDetector(
                            onTap: () {
                              playClickSound();
                              setState(() {
                                isSelected = 'hard';
                              });
                            },
                            child: Column(
                              children: [
                                Text('🫠',
                                    style: AppTextTheme
                                        .lightTextTheme.displayLarge
                                        ?.copyWith(
                                            color: AppColors.neutralColor,
                                            fontWeight: FontWeight.w400)),
                                Text('Hard',
                                    style: AppTextTheme.lightTextTheme.bodyLarge
                                        ?.copyWith(
                                            color: AppColors.neutralColor,
                                            fontWeight: FontWeight.w400)),
                              ],
                            )
                                .animate(target: isSelected == 'hard' ? 1 : 0)
                                .scale(
                                    begin: const Offset(1, 1),
                                    end: const Offset(1.3, 1.3),
                                    duration: 300.ms),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: Sizes.xxl,
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: Sizes.xl,
                ),
              ),
              SliverToBoxAdapter(
                child: isLoading
                    ? appLoadingSpinner()
                    : FilledButton(
                        style: FilledButton.styleFrom(
                            padding: const EdgeInsets.all(Sizes.xl),
                            backgroundColor: AppColors.secondaryColor),
                        onPressed: () async {
                          await playExitSound();
                        },
                        child: Text(
                          'Finish',
                          style: AppTextTheme.lightTextTheme.bodyLarge
                              ?.copyWith(color: AppColors.primaryColor),
                        )),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: Sizes.xxxl + 50,
                ),
              )
            ]),
          ],
        ),
      ),
    );
  }
}
