import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'video_page_controller.g.dart';

@Riverpod(keepAlive: true)
class VideoPageController extends _$VideoPageController {
  @override
  PageController build() {
    return PageController();
  }

  void resetPage() {
    // state.animateToPage(
    //   0,
    //   duration: const Duration(milliseconds: 300),
    //   curve: Curves.easeInOut,
    // );
  }
}
