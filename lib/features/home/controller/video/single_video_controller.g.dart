// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'single_video_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$singleVideoControllerHash() =>
    r'8f647c43e22acc0e38b7d2f6bff232acf2074a12';

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

abstract class _$SingleVideoController
    extends BuildlessAsyncNotifier<VideoTikTok?> {
  late final String videoId;

  FutureOr<VideoTikTok?> build(
    String videoId,
  );
}

/// See also [SingleVideoController].
@ProviderFor(SingleVideoController)
const singleVideoControllerProvider = SingleVideoControllerFamily();

/// See also [SingleVideoController].
class SingleVideoControllerFamily extends Family<AsyncValue<VideoTikTok?>> {
  /// See also [SingleVideoController].
  const SingleVideoControllerFamily();

  /// See also [SingleVideoController].
  SingleVideoControllerProvider call(
    String videoId,
  ) {
    return SingleVideoControllerProvider(
      videoId,
    );
  }

  @override
  SingleVideoControllerProvider getProviderOverride(
    covariant SingleVideoControllerProvider provider,
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
  String? get name => r'singleVideoControllerProvider';
}

/// See also [SingleVideoController].
class SingleVideoControllerProvider
    extends AsyncNotifierProviderImpl<SingleVideoController, VideoTikTok?> {
  /// See also [SingleVideoController].
  SingleVideoControllerProvider(
    String videoId,
  ) : this._internal(
          () => SingleVideoController()..videoId = videoId,
          from: singleVideoControllerProvider,
          name: r'singleVideoControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$singleVideoControllerHash,
          dependencies: SingleVideoControllerFamily._dependencies,
          allTransitiveDependencies:
              SingleVideoControllerFamily._allTransitiveDependencies,
          videoId: videoId,
        );

  SingleVideoControllerProvider._internal(
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
  FutureOr<VideoTikTok?> runNotifierBuild(
    covariant SingleVideoController notifier,
  ) {
    return notifier.build(
      videoId,
    );
  }

  @override
  Override overrideWith(SingleVideoController Function() create) {
    return ProviderOverride(
      origin: this,
      override: SingleVideoControllerProvider._internal(
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
  AsyncNotifierProviderElement<SingleVideoController, VideoTikTok?>
      createElement() {
    return _SingleVideoControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SingleVideoControllerProvider && other.videoId == videoId;
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
mixin SingleVideoControllerRef on AsyncNotifierProviderRef<VideoTikTok?> {
  /// The parameter `videoId` of this provider.
  String get videoId;
}

class _SingleVideoControllerProviderElement
    extends AsyncNotifierProviderElement<SingleVideoController, VideoTikTok?>
    with SingleVideoControllerRef {
  _SingleVideoControllerProviderElement(super.provider);

  @override
  String get videoId => (origin as SingleVideoControllerProvider).videoId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
