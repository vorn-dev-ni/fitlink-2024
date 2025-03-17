// import 'package:video_player/video_player.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'video_player_controller.g.dart';

// class VideoPlayerState {
//   final bool isBuffering;
//   final double currentPosition;
//   final double videoDuration;
//   final bool isInitialized;
//   final bool isPlaying;

//   VideoPlayerState({
//     required this.isBuffering,
//     required this.currentPosition,
//     required this.videoDuration,
//     required this.isInitialized,
//     required this.isPlaying,
//   });

//   // CopyWith method to update state without modifying the original state
//   VideoPlayerState copyWith({
//     bool? isBuffering,
//     double? currentPosition,
//     double? videoDuration,
//     bool? isInitialized,
//     bool? isPlaying,
//   }) {
//     return VideoPlayerState(
//       isBuffering: isBuffering ?? this.isBuffering,
//       currentPosition: currentPosition ?? this.currentPosition,
//       videoDuration: videoDuration ?? this.videoDuration,
//       isInitialized: isInitialized ?? this.isInitialized,
//       isPlaying: isPlaying ?? this.isPlaying,
//     );
//   }
// }

// @Riverpod(keepAlive: false)
// class VideoPlayerStateController extends _$VideoPlayerStateController {
//   @override
//   VideoPlayerState build(String url) {
//     return VideoPlayerState(
//       isBuffering: false,
//       currentPosition: 0.0,
//       videoDuration: 0.0,
//       isInitialized: false,
//       isPlaying: true,
//     );
//   }

//   // Update buffering status
//   void setBuffering(bool isBuffering) {
//     state = state.copyWith(isBuffering: isBuffering);
//   }

//   // Update current position of the video
//   void setCurrentPosition(double position) {
//     state = state.copyWith(currentPosition: position);
//   }

//   // Update video duration
//   void setVideoDuration(double duration) {
//     state = state.copyWith(videoDuration: duration);
//   }

//   // Update initialized state of the video
//   void setInitialized(bool isInitialized) {
//     state = state.copyWith(isInitialized: isInitialized);
//   }

//   // Update playing state of the video
//   void setPlaying(bool isPlaying) {
//     state = state.copyWith(isPlaying: isPlaying);
//   }
// }

// // Video Player Controller Provider
// @Riverpod(keepAlive: true)
// class VideoPlayerControllerProvider extends _$VideoPlayerControllerProvider {
//   late VideoPlayerController _controller;

//   @override
//   Future<VideoPlayerController> build(String url) async {
//     final videoUrl = url;
//     _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
//       ..addListener(() {
//         final isBuffering = _controller.value.isBuffering;
//         final currentPosition = _controller.value.position.inSeconds.toDouble();
//         final videoDuration = _controller.value.duration.inSeconds.toDouble();
//         final isPlaying = _controller.value.isPlaying;
//         final isInitialized = _controller.value.isInitialized;

//         // Update the video player state via Riverpod
//         ref
//             .read(videoPlayerStateControllerProvider(url).notifier)
//             .setBuffering(isBuffering);
//         ref
//             .read(videoPlayerStateControllerProvider(url).notifier)
//             .setCurrentPosition(currentPosition);
//         ref
//             .read(videoPlayerStateControllerProvider(url).notifier)
//             .setVideoDuration(videoDuration);
//         ref
//             .read(videoPlayerStateControllerProvider(url).notifier)
//             .setPlaying(isPlaying);
//         ref
//             .read(videoPlayerStateControllerProvider(url).notifier)
//             .setInitialized(isInitialized);
//       });

//     await _controller.initialize();
//     await _controller.play();
//     ref.onDispose(
//       () {
//         ref
//             .read(videoPlayerControllerProviderProvider(videoUrl).notifier)
//             .disposeController();
//       },
//     );
//     return _controller;
//   }

//   Future<void> disposeController() async {
//     await _controller.dispose();
//   }

//   void togglePlayPause() {
//     if (_controller.value.isPlaying) {
//       _controller.pause();
//     } else {
//       _controller.play();
//     }
//   }

//   Future<void> seekTo(Duration position) async {
//     ref
//         .read(videoPlayerStateControllerProvider(url).notifier)
//         .setBuffering(true);
//     await _controller.seekTo(position);
//     ref
//         .read(videoPlayerStateControllerProvider(url).notifier)
//         .setBuffering(false);
//   }
// }
