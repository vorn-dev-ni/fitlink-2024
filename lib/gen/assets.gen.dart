/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsAppGen {
  const $AssetsAppGen();

  /// File path: assets/app/art_one.png
  AssetGenImage get artOne => const AssetGenImage('assets/app/art_one.png');

  /// File path: assets/app/art_two.png
  AssetGenImage get artTwo => const AssetGenImage('assets/app/art_two.png');

  /// File path: assets/app/default_avatar.jpg
  AssetGenImage get defaultAvatar =>
      const AssetGenImage('assets/app/default_avatar.jpg');

  /// File path: assets/app/gym_background.png
  AssetGenImage get gymBackground =>
      const AssetGenImage('assets/app/gym_background.png');

  /// File path: assets/app/no_img_available.png
  AssetGenImage get noImgAvailable =>
      const AssetGenImage('assets/app/no_img_available.png');

  /// File path: assets/app/no_internet_cat.jpg
  AssetGenImage get noInternetCat =>
      const AssetGenImage('assets/app/no_internet_cat.jpg');

  /// List of all assets
  List<AssetGenImage> get values => [
        artOne,
        artTwo,
        defaultAvatar,
        gymBackground,
        noImgAvailable,
        noInternetCat
      ];
}

class $AssetsIconGen {
  const $AssetsIconGen();

  /// Directory path: assets/icon/svg
  $AssetsIconSvgGen get svg => const $AssetsIconSvgGen();
}

class $AssetsLottiesGen {
  const $AssetsLottiesGen();

  /// File path: assets/lotties/loading.json
  String get loading => 'assets/lotties/loading.json';

  /// File path: assets/lotties/loading_two.json
  String get loadingTwo => 'assets/lotties/loading_two.json';

  /// List of all assets
  List<String> get values => [loading, loadingTwo];
}

class $AssetsSplashGen {
  const $AssetsSplashGen();

  /// File path: assets/splash/flutter.png
  AssetGenImage get flutter => const AssetGenImage('assets/splash/flutter.png');

  /// File path: assets/splash/ic_launcher.png
  AssetGenImage get icLauncher =>
      const AssetGenImage('assets/splash/ic_launcher.png');

  /// File path: assets/splash/logo.png
  AssetGenImage get logo => const AssetGenImage('assets/splash/logo.png');

  /// List of all assets
  List<AssetGenImage> get values => [flutter, icLauncher, logo];
}

class $AssetsUtilsGen {
  const $AssetsUtilsGen();

  /// File path: assets/utils/amy.jpg
  AssetGenImage get amy => const AssetGenImage('assets/utils/amy.jpg');

  /// File path: assets/utils/fitlink_logo.jpg
  AssetGenImage get fitlinkLogo =>
      const AssetGenImage('assets/utils/fitlink_logo.jpg');

  /// File path: assets/utils/kith.jpg
  AssetGenImage get kith => const AssetGenImage('assets/utils/kith.jpg');

  /// File path: assets/utils/long.jpg
  AssetGenImage get long => const AssetGenImage('assets/utils/long.jpg');

  /// List of all assets
  List<AssetGenImage> get values => [amy, fitlinkLogo, kith, long];
}

class $AssetsIconSvgGen {
  const $AssetsIconSvgGen();

  /// File path: assets/icon/svg/chat.svg
  String get chat => 'assets/icon/svg/chat.svg';

  /// File path: assets/icon/svg/check.svg
  String get check => 'assets/icon/svg/check.svg';

  /// File path: assets/icon/svg/circle.svg
  String get circle => 'assets/icon/svg/circle.svg';

  /// File path: assets/icon/svg/cloud-up.svg
  String get cloudUp => 'assets/icon/svg/cloud-up.svg';

  /// File path: assets/icon/svg/dot_indicator.svg
  String get dotIndicator => 'assets/icon/svg/dot_indicator.svg';

  /// File path: assets/icon/svg/dumbell.svg
  String get dumbell => 'assets/icon/svg/dumbell.svg';

  /// File path: assets/icon/svg/eye-closed.svg
  String get eyeClosed => 'assets/icon/svg/eye-closed.svg';

  /// File path: assets/icon/svg/eye.svg
  String get eye => 'assets/icon/svg/eye.svg';

  /// File path: assets/icon/svg/file-neutral.svg
  String get fileNeutral => 'assets/icon/svg/file-neutral.svg';

  /// File path: assets/icon/svg/house.svg
  String get house => 'assets/icon/svg/house.svg';

  /// File path: assets/icon/svg/mdi_location.svg
  String get mdiLocation => 'assets/icon/svg/mdi_location.svg';

  /// File path: assets/icon/svg/not_found.svg
  String get notFound => 'assets/icon/svg/not_found.svg';

  /// File path: assets/icon/svg/plus.svg
  String get plus => 'assets/icon/svg/plus.svg';

  /// File path: assets/icon/svg/share.svg
  String get share => 'assets/icon/svg/share.svg';

  /// List of all assets
  List<String> get values => [
        chat,
        check,
        circle,
        cloudUp,
        dotIndicator,
        dumbell,
        eyeClosed,
        eye,
        fileNeutral,
        house,
        mdiLocation,
        notFound,
        plus,
        share
      ];
}

class Assets {
  Assets._();

  static const $AssetsAppGen app = $AssetsAppGen();
  static const $AssetsIconGen icon = $AssetsIconGen();
  static const $AssetsLottiesGen lotties = $AssetsLottiesGen();
  static const $AssetsSplashGen splash = $AssetsSplashGen();
  static const $AssetsUtilsGen utils = $AssetsUtilsGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
