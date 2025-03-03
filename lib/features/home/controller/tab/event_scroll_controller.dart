import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'event_scroll_controller.g.dart';

@Riverpod(keepAlive: true)
class EventScrollController extends _$EventScrollController {
  @override
  ScrollController build() {
    return ScrollController();
  }

  void scrollToTop({required Duration duration, required Curve curve}) {
    state.animateTo(0, duration: duration, curve: curve);
  }

  void resetScroll() {
    state.jumpTo(0);
  }
}
