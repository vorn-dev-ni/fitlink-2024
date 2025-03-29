// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_search_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$videoSearchControllerHash() =>
    r'df9457eedd3355ac59b508927c021aa3221de860';

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

abstract class _$VideoSearchController
    extends BuildlessAutoDisposeAsyncNotifier<List<VideoTikTok>> {
  late final String query;
  late final List<String>? tag;

  FutureOr<List<VideoTikTok>> build(
    String query,
    List<String>? tag,
  );
}

/// See also [VideoSearchController].
@ProviderFor(VideoSearchController)
const videoSearchControllerProvider = VideoSearchControllerFamily();

/// See also [VideoSearchController].
class VideoSearchControllerFamily
    extends Family<AsyncValue<List<VideoTikTok>>> {
  /// See also [VideoSearchController].
  const VideoSearchControllerFamily();

  /// See also [VideoSearchController].
  VideoSearchControllerProvider call(
    String query,
    List<String>? tag,
  ) {
    return VideoSearchControllerProvider(
      query,
      tag,
    );
  }

  @override
  VideoSearchControllerProvider getProviderOverride(
    covariant VideoSearchControllerProvider provider,
  ) {
    return call(
      provider.query,
      provider.tag,
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
  String? get name => r'videoSearchControllerProvider';
}

/// See also [VideoSearchController].
class VideoSearchControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<VideoSearchController,
        List<VideoTikTok>> {
  /// See also [VideoSearchController].
  VideoSearchControllerProvider(
    String query,
    List<String>? tag,
  ) : this._internal(
          () => VideoSearchController()
            ..query = query
            ..tag = tag,
          from: videoSearchControllerProvider,
          name: r'videoSearchControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$videoSearchControllerHash,
          dependencies: VideoSearchControllerFamily._dependencies,
          allTransitiveDependencies:
              VideoSearchControllerFamily._allTransitiveDependencies,
          query: query,
          tag: tag,
        );

  VideoSearchControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
    required this.tag,
  }) : super.internal();

  final String query;
  final List<String>? tag;

  @override
  FutureOr<List<VideoTikTok>> runNotifierBuild(
    covariant VideoSearchController notifier,
  ) {
    return notifier.build(
      query,
      tag,
    );
  }

  @override
  Override overrideWith(VideoSearchController Function() create) {
    return ProviderOverride(
      origin: this,
      override: VideoSearchControllerProvider._internal(
        () => create()
          ..query = query
          ..tag = tag,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
        tag: tag,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<VideoSearchController,
      List<VideoTikTok>> createElement() {
    return _VideoSearchControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VideoSearchControllerProvider &&
        other.query == query &&
        other.tag == tag;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);
    hash = _SystemHash.combine(hash, tag.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin VideoSearchControllerRef
    on AutoDisposeAsyncNotifierProviderRef<List<VideoTikTok>> {
  /// The parameter `query` of this provider.
  String get query;

  /// The parameter `tag` of this provider.
  List<String>? get tag;
}

class _VideoSearchControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<VideoSearchController,
        List<VideoTikTok>> with VideoSearchControllerRef {
  _VideoSearchControllerProviderElement(super.provider);

  @override
  String get query => (origin as VideoSearchControllerProvider).query;
  @override
  List<String>? get tag => (origin as VideoSearchControllerProvider).tag;
}

String _$recentSearchControllerHash() =>
    r'afebc7a6bfe0709193bd52e43e4f23d9d87cd8a3';

/// See also [RecentSearchController].
@ProviderFor(RecentSearchController)
final recentSearchControllerProvider =
    AsyncNotifierProvider<RecentSearchController, List<String>>.internal(
  RecentSearchController.new,
  name: r'recentSearchControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$recentSearchControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RecentSearchController = AsyncNotifier<List<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
