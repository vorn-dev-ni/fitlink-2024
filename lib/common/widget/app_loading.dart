import 'package:demo/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Widget appLoadingSpinner() {
  return Center(
    child: Lottie.asset(Assets.lotties.loadingTwo,
        alignment: Alignment.center, fit: BoxFit.cover, height: 30),
  );
}
