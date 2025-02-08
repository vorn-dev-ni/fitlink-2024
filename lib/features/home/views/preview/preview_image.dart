import 'dart:io';
import 'package:demo/common/widget/app_bar_custom.dart';
import 'package:demo/common/widget/backdrop_loading.dart';
import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/features/home/controller/profile/profile_user_controller.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PreviewImage extends ConsumerStatefulWidget {
  const PreviewImage({super.key});

  @override
  ConsumerState<PreviewImage> createState() => _PreviewImageState();
}

class _PreviewImageState extends ConsumerState<PreviewImage> {
  late File previewImage;
  late String oldImage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    if (args.containsKey('compressImage')) {
      previewImage = args['compressImage'];
    }

    if (args.containsKey('oldimage')) {
      oldImage = args['oldimage'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(appLoadingStateProvider);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBarCustom(
            isCenter: true,
            text: 'Preview',
            bgColor: AppColors.backgroundLight,
            foregroundColor: AppColors.secondaryColor,
            showheader: false,
            leading: TextButton(
                onPressed: _onSaveImage,
                child: Text(
                  'Save',
                  style: AppTextTheme.lightTextTheme.bodyMedium
                      ?.copyWith(color: AppColors.secondaryColor),
                )),
          ),
          body: SafeArea(
              child: Center(
                  child: Image.file(
            previewImage,
            fit: BoxFit.cover,
          ))),
        ),
        if (loading) backDropLoading()
      ],
    );
  }

  void _onSaveImage() async {
    try {
      ref.read(appLoadingStateProvider.notifier).setState(true);
      await ref
          .read(profileUserControllerProvider.notifier)
          .updateCoverPicture(previewImage, oldImage);

      ref.invalidate(profileUserControllerProvider);
      debugPrint("Update cover successfully !!!");
      HelpersUtils.navigatorState(context).pop();

      Fluttertoast.showToast(
          msg: "Update user cover successfully !!!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.successColor,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      ref.read(appLoadingStateProvider.notifier).setState(false);
    }
  }
}
