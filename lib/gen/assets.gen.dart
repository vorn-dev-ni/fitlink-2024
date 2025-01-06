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

  /// File path: assets/app/gym_background.png
  AssetGenImage get gymBackground =>
      const AssetGenImage('assets/app/gym_background.png');

  /// List of all assets
  List<AssetGenImage> get values => [artOne, artTwo, gymBackground];
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

  /// List of all assets
  List<String> get values => [loading];
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

class $AssetsIconSvgGen {
  const $AssetsIconSvgGen();

  /// File path: assets/icon/svg/email.svg
  String get email => 'assets/icon/svg/email.svg';

  /// File path: assets/icon/svg/oops.svg
  String get oops => 'assets/icon/svg/oops.svg';

  /// File path: assets/icon/svg/oops_two.svg
  String get oopsTwo => 'assets/icon/svg/oops_two.svg';

  /// File path: assets/icon/svg/yoga.svg
  String get yoga => 'assets/icon/svg/yoga.svg';

  /// List of all assets
  List<String> get values => [email, oops, oopsTwo, yoga];
}

class Assets {
  Assets._();

  static const String aEnv = '.env';
  static const String aEnvdev = '.env.dev';
  static const $AssetsAppGen app = $AssetsAppGen();
  static const $AssetsIconGen icon = $AssetsIconGen();
  static const $AssetsLottiesGen lotties = $AssetsLottiesGen();
  static const $AssetsSplashGen splash = $AssetsSplashGen();

  /// List of all assets
  static List<String> get values => [aEnv, aEnvdev];
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
