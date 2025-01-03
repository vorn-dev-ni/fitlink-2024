import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'connectivity_state.g.dart';

@Riverpod(keepAlive: true)
class ConnectivityState extends _$ConnectivityState {
  late Connectivity _connectivity;

  @override
  Stream<List<ConnectivityResult>> build() {
    _connectivity = Connectivity();
    return onConnectivityChange();
  }

  Stream<List<ConnectivityResult>> onConnectivityChange() {
    return _connectivity.onConnectivityChanged;
  }
}
