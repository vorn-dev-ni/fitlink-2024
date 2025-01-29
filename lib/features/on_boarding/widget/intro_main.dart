import 'package:demo/features/on_boarding/controller/start_page_controller.dart';
import 'package:demo/features/on_boarding/widget/bg_boarding.dart';
import 'package:demo/features/on_boarding/widget/intro_content.dart';
import 'package:demo/features/on_boarding/widget/intro_header.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IntroMain extends ConsumerStatefulWidget {
  final String body;
  final String title;
  final AssetGenImage? backgroundAssets;

  IntroMain(
      {super.key,
      this.backgroundAssets,
      required this.body,
      required this.title});

  @override
  ConsumerState<IntroMain> createState() => _IntroMainState();
}

class _IntroMainState extends ConsumerState<IntroMain> {
  @override
  Widget build(BuildContext context) {
    final activeIndex = ref.watch(startPageControllerProvider);

    return Stack(
      children: [
        background_boarding(image: widget.backgroundAssets),
        if (activeIndex < 2) introHeader(context),
        introContent(body: widget.body, title: widget.title),
      ],
    );
  }
}
