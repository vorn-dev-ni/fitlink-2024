import 'dart:async';
import 'package:demo/common/widget/app_bar_custom.dart';
import 'package:demo/common/widget/app_dialog.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/model/workouts/workout_response.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sizer/sizer.dart';

class ExcerciseDetail extends StatefulWidget {
  const ExcerciseDetail({super.key});

  @override
  State<ExcerciseDetail> createState() => _ExcerciseDetailState();
}

class _ExcerciseDetailState extends State<ExcerciseDetail> {
  int initCount = 10;
  int totalDuration = 0;
  int currentCount = 10;
  bool isPaused = false;
  Timer? _timer;
  int currentExerciseIndex = 0;
  int currentSet = 1;
  int totalSet = 0;
  late List<Map<String, dynamic>> exercises = [];
  late AudioPlayer _playBgTheme;
  late AudioPlayer _playSoundStart;
  late AudioPlayer _playSoundNextSet;
  late AudioPlayer _playSoundPause;
  late AudioPlayer _playSoundEndRep;
  late bool isMute = false;
  late DateTime date;
  late String title;
  late String docId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final routes =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    if (routes.containsKey('title')) {
      title = routes['title'];
    } else {
      title = 'Workout';
    }

    if (routes.containsKey('date')) {
      date = routes['date'];
    } else {
      date = DateTime.now();
    }

    if (routes.containsKey('id')) {
      docId = routes['id'];
    } else {
      docId = '';
    }
    if (routes.containsKey('total_duration')) {
      totalDuration = routes['total_duration'];
    }
    if (routes.containsKey('excercises')) {
      final listExercises = routes['excercises'] as List<Exercises>;

      exercises = listExercises.map((item) {
        totalSet = totalSet + int.parse(item.sets ?? "0");
        return {
          "name": item.title,
          "feature": item.imageUrl,
          "sets": item.sets.toString(),
          "reps": item.reps.toString(),
          "duration": item.duration.toString()
        };
      }).toList();

      if (exercises.isNotEmpty) {
        currentExerciseIndex = 0;
        currentSet = 1;

        initCount = int.parse(exercises[currentExerciseIndex]['duration']);
        currentCount = initCount;
      }
    }
  }

  @override
  void initState() {
    _playSoundStart = AudioPlayer();
    _playSoundNextSet = AudioPlayer();
    _playSoundPause = AudioPlayer();
    _playBgTheme = AudioPlayer();
    _playSoundEndRep = AudioPlayer();
    _startThemeSong();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _playBgTheme.dispose();
    super.dispose();
  }

  void _startThemeSong() async {
    try {
      await _playBgTheme.stop();
      await _playBgTheme.seek(const Duration(seconds: 0));
      await _playBgTheme.setAsset(Assets.audio.bgGym);
      _playBgTheme.setVolume(0.6);
      _playBgTheme.setLoopMode(LoopMode.all);
      _playBgTheme.play();
    } catch (e) {
      debugPrint("Error loading audio: $e");
    }
  }

  void _onStartSound() async {
    try {
      await _playSoundStart.stop();
      await _playSoundStart.seek(const Duration(seconds: 0));
      await _playSoundStart.setAsset(Assets.audio.whistle);
      _playSoundStart.setVolume(1);
      _playSoundStart.play();
    } catch (e) {
      debugPrint("Error loading audio: $e");
    }
  }

  void _onSoundPauses() async {
    try {
      await _playSoundPause.stop();
      await _playSoundPause.seek(const Duration(seconds: 0));
      await _playSoundPause.setAsset(Assets.audio.ohGod);
      _playSoundPause.setVolume(1);
      _playSoundPause.play();
    } catch (e) {
      debugPrint("Error loading audio: $e");
    }
  }

  void _endRepSound() async {
    try {
      await _playSoundEndRep.stop();
      await _playSoundEndRep.seek(const Duration(seconds: 0));
      await _playSoundEndRep.setAsset(Assets.audio.goodJob);
      _playSoundEndRep.setVolume(1);
      _playSoundEndRep.play();
    } catch (e) {
      debugPrint("Error loading audio: $e");
    }
  }

  void _nextSetSound() async {
    try {
      await _playSoundNextSet.stop();
      await _playSoundNextSet.seek(const Duration(seconds: 0));
      await _playSoundNextSet.setAsset(Assets.audio.wow);
      _playSoundNextSet.setVolume(1);
      _playSoundNextSet.play();
    } catch (e) {
      debugPrint("Error loading audio: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentExercise = exercises[currentExerciseIndex];
    int totalSets = int.parse(currentExercise['sets']);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        foregroundColor: AppColors.backgroundDark,
        title: Text(
          title,
          maxLines: 2,
          style: AppTextTheme.lightTextTheme.headlineSmall?.copyWith(
              color: AppColors.backgroundDark, fontWeight: FontWeight.w500),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                InkWell(
                    onTap: () {
                      final mutateVol = _playBgTheme.volume < 1
                          ? _playBgTheme.volume + 0.1
                          : 1.0;
                      _playBgTheme.setVolume(mutateVol);
                    },
                    child:
                        const Icon(Icons.add, size: 20, color: Colors.green)),
                const SizedBox(
                  width: Sizes.sm,
                ),
                InkWell(
                    onTap: () {
                      if (!isMute) {
                        _playBgTheme.pause();
                        setState(() {
                          isMute = true;
                        });
                      } else {
                        _playBgTheme.play();
                        setState(() {
                          isMute = false;
                        });
                      }
                    },
                    child: Icon(!isMute
                        ? Icons.volume_up_rounded
                        : Icons.volume_mute_rounded)),
                const SizedBox(
                  width: Sizes.sm,
                ),
                InkWell(
                    onTap: () {
                      final mutateVolume = _playBgTheme.volume > 0.1
                          ? _playBgTheme.volume - 0.1
                          : 0.0;
                      _playBgTheme.setVolume(mutateVolume);
                    },
                    child:
                        const Icon(Icons.remove, size: 20, color: Colors.red)),
              ],
            ),
          ),
        ],
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: GestureDetector(
            onTap: () {
              HelpersUtils.navigatorState(context).pop();
            },
            child: const Icon(Icons.arrow_back_ios),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FancyShimmerImage(
              boxFit: BoxFit.contain,
              width: 100.w,
              height: 300,
              imageUrl: currentExercise['feature'] ??
                  'https://cdn.shopify.com/s/files/1/0269/5551/3900/files/Dumbbell-Bent-Over-Row-_Single-Arm_49867db3-f465-4fbc-b359-29cbdda502e2_600x600.png?v=1612138069',
            ),
            const SizedBox(
              height: Sizes.xl,
            ),
            Text(
              currentExercise['name'],
              style: AppTextTheme.lightTextTheme.bodyLarge,
            ),
            const SizedBox(
              height: Sizes.lg,
            ),
            Container(
              padding: const EdgeInsets.all(Sizes.xxxl),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: AppColors.secondaryColor, width: 4)),
              child: Column(
                children: [
                  Text(
                    'Remaining ',
                    style: AppTextTheme.lightTextTheme.bodyMedium,
                  ),
                  Text(
                    '$currentCount',
                    style: AppTextTheme.lightTextTheme.headlineLarge
                        ?.copyWith(color: AppColors.secondaryColor),
                  ),
                  Text(
                    'seconds',
                    style: AppTextTheme.lightTextTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: Sizes.lg,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sets count : ',
                  style: AppTextTheme.lightTextTheme.bodyLarge,
                ),
                const SizedBox(
                  width: Sizes.xs,
                ),
                Text(
                  '$currentSet/$totalSets',
                  style: AppTextTheme.lightTextTheme.bodyLarge
                      ?.copyWith(color: AppColors.secondaryColor),
                ),
              ],
            ),
            const SizedBox(
              height: Sizes.lg,
            ),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.xxxl + 20, vertical: Sizes.lg),
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(
                          width: 1, color: AppColors.secondaryColor),
                      borderRadius: BorderRadius.circular(Sizes.xxxl)),
                  foregroundColor: AppColors.secondaryColor),
              onPressed: () async {
                if (currentCount != initCount) {
                  showDialog(
                      context: context,
                      builder: (context) => AppALertDialog(
                          onConfirm: () {},
                          title: 'Warning',
                          desc:
                              "There is an ongoing workout set, please complete your set first"));
                  return;
                }
                await _playBgTheme.stop();
                _navigating();
              },
              label: const Text('DONE'),
              icon: const Icon(Icons.check),
            ),
            const SizedBox(
              height: Sizes.lg,
            ),
            Padding(
              padding: const EdgeInsets.all(Sizes.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                          padding: const EdgeInsets.all(Sizes.md),
                          backgroundColor: AppColors.secondaryColor,
                          foregroundColor: AppColors.backgroundLight),
                      onPressed: () {
                        _renderTimer();
                        setState(() {
                          isPaused = !isPaused;
                        });
                      },
                      label: Text(currentCount != initCount && isPaused
                          ? 'PAUSE'
                          : 'START'),
                      icon: Icon(currentCount != initCount && isPaused
                          ? Icons.pause
                          : Icons.play_arrow),
                    ),
                  ),
                  const SizedBox(
                    width: Sizes.lg,
                  ),
                  Expanded(
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                          padding: const EdgeInsets.all(Sizes.md),
                          backgroundColor: AppColors.secondaryColor,
                          foregroundColor: AppColors.backgroundLight),
                      onPressed: () => _handlePressSet(totalSets),
                      label: const Text('NEXT SET'),
                      icon: const Icon(Icons.arrow_forward_sharp),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }

  void _renderTimer() {
    if (isPaused) {
      _onSoundPauses();
    } else {
      _onStartSound();
    }
    if (_timer != null && _timer!.isActive) {
      return;
    }

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (!isPaused) {
          return;
        }
        if (currentCount > 0) {
          setState(() {
            currentCount--;
          });
        } else {
          _endRepSound();
          timer.cancel();
          _timer = null;
          setState(() {
            currentCount = initCount;
            isPaused = false;
          });
        }
      },
    );
  }

  void _handlePressSet(totalSets) async {
    if (currentSet >= totalSets) {
      _nextSetSound();
    }
    if (currentSet < totalSets) {
      setState(() {
        currentSet++;
        currentCount = initCount;
        isPaused = false;
      });
    } else {
      if (currentExerciseIndex < exercises.length - 1) {
        setState(() {
          currentExerciseIndex++;
          currentSet = 1;
          currentCount = initCount;
          isPaused = false;
        });
      } else {
        await _playBgTheme.stop();
        _navigating();
      }
    }
  }

  void _navigating() async {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        setState(() {
          isMute = false;
        });
      },
    );
    await HelpersUtils.navigatorState(context)
        .pushNamed(AppPage.exerciseSuccess, arguments: {
      'title': title,
      'total_excercises': exercises.length,
      'total_duration': totalDuration,
      'total_set': totalSet,
      'date': date,
      'id': docId
    });
    await _playBgTheme.seek(const Duration(seconds: 0));
    _playBgTheme.play();
  }
}
