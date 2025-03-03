import 'package:demo/features/home/controller/chat/user_status_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppLifecycleObserver extends ConsumerStatefulWidget {
  final Widget child;

  const AppLifecycleObserver({required this.child, Key? key}) : super(key: key);

  @override
  _AppLifecycleObserverState createState() => _AppLifecycleObserverState();
}

class _AppLifecycleObserverState extends ConsumerState<AppLifecycleObserver>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setUserOnline();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _setUserOnline();
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _setUserOffline();
    }
  }

  void _setUserOnline() {
    ref.read(userStatusControllerProvider.notifier).setUserOnline();
  }

  void _setUserOffline() {
    ref
        .read(userStatusControllerProvider.notifier)
        .setUserOffline(FirebaseAuth.instance.currentUser?.uid ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
