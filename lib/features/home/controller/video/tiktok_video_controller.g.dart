// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tiktok_video_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tiktokVideoControllerHash() =>
    r'd7082f98d4661b8122e8f7fab4a356f5062e65a7';

/// See also [TiktokVideoController].
@ProviderFor(TiktokVideoController)
final tiktokVideoControllerProvider =
    AsyncNotifierProvider<TiktokVideoController, List<VideoTikTok>>.internal(
  TiktokVideoController.new,
  name: r'tiktokVideoControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tiktokVideoControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TiktokVideoController = AsyncNotifier<List<VideoTikTok>>;
String _$socialInteractonVideoControllerHash() =>
    r'9e299076b4e1d867ce75e38071adea54659dc2eb';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$SocialInteractonVideoController
    extends BuildlessStreamNotifier<VideoTikTok> {
  late final String videoId;

  Stream<VideoTikTok> build(
    String videoId,
  );
}

/// See also [SocialInteractonVideoController].
@ProviderFor(SocialInteractonVideoController)
const socialInteractonVideoControllerProvider =
    SocialInteractonVideoControllerFamily();

/// See also [SocialInteractonVideoController].
class SocialInteractonVideoControllerFamily
    extends Family<AsyncValue<VideoTikTok>> {
  /// See also [SocialInteractonVideoController].
  const SocialInteractonVideoControllerFamily();

  /// See also [SocialInteractonVideoController].
  SocialInteractonVideoControllerProvider call(
    String videoId,
  ) {
    return SocialInteractonVideoControllerProvider(
      videoId,
    );
  }

  @override
  SocialInteractonVideoControllerProvider getProviderOverride(
    covariant SocialInteractonVideoControllerProvider provider,
  ) {
    return call(
      provider.videoId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'socialInteractonVideoControllerProvider';
}

/// See also [SocialInteractonVideoController].
class SocialInteractonVideoControllerProvider
    extends StreamNotifierProviderImpl<SocialInteractonVideoController,
        VideoTikTok> {
  /// See also [SocialInteractonVideoController].
  SocialInteractonVideoControllerProvider(
    String videoId,
  ) : this._internal(
          () => SocialInteractonVideoController()..videoId = videoId,
          from: socialInteractonVideoControllerProvider,
          name: r'socialInteractonVideoControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$socialInteractonVideoControllerHash,
          dependencies: SocialInteractonVideoControllerFamily._dependencies,
          allTransitiveDependencies:
              SocialInteractonVideoControllerFamily._allTransitiveDependencies,
          videoId: videoId,
        );

  SocialInteractonVideoControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.videoId,
  }) : super.internal();

  final String videoId;

  @override
  Stream<VideoTikTok> runNotifierBuild(
    covariant SocialInteractonVideoController notifier,
  ) {
    return notifier.build(
      videoId,
    );
  }

  @override
  Override overrideWith(SocialInteractonVideoController Function() create) {
    return ProviderOverride(
      origin: this,
      override: SocialInteractonVideoControllerProvider._internal(
        () => create()..videoId = videoId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        videoId: videoId,
      ),
    );
  }

  @override
  StreamNotifierProviderElement<SocialInteractonVideoController, VideoTikTok>
      createElement() {
    return _SocialInteractonVideoControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SocialInteractonVideoControllerProvider &&
        other.videoId == videoId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, videoId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SocialInteractonVideoControllerRef
    on StreamNotifierProviderRef<VideoTikTok> {
  /// The parameter `videoId` of this provider.
  String get videoId;
}

class _SocialInteractonVideoControllerProviderElement
    extends StreamNotifierProviderElement<SocialInteractonVideoController,
        VideoTikTok> with SocialInteractonVideoControllerRef {
  _SocialInteractonVideoControllerProviderElement(super.provider);

  @override
  String get videoId =>
      (origin as SocialInteractonVideoControllerProvider).videoId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
