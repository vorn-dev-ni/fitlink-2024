// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_video_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tiktokCommentControllerHash() =>
    r'7aba7c26a449f8a38361a4b860a4b2a507a5d807';

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

abstract class _$TiktokCommentController
    extends BuildlessAutoDisposeAsyncNotifier<List<CommentTikTok>> {
  late final String videoId;

  FutureOr<List<CommentTikTok>> build(
    String videoId,
  );
}

/// See also [TiktokCommentController].
@ProviderFor(TiktokCommentController)
const tiktokCommentControllerProvider = TiktokCommentControllerFamily();

/// See also [TiktokCommentController].
class TiktokCommentControllerFamily
    extends Family<AsyncValue<List<CommentTikTok>>> {
  /// See also [TiktokCommentController].
  const TiktokCommentControllerFamily();

  /// See also [TiktokCommentController].
  TiktokCommentControllerProvider call(
    String videoId,
  ) {
    return TiktokCommentControllerProvider(
      videoId,
    );
  }

  @override
  TiktokCommentControllerProvider getProviderOverride(
    covariant TiktokCommentControllerProvider provider,
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
  String? get name => r'tiktokCommentControllerProvider';
}

/// See also [TiktokCommentController].
class TiktokCommentControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<TiktokCommentController,
        List<CommentTikTok>> {
  /// See also [TiktokCommentController].
  TiktokCommentControllerProvider(
    String videoId,
  ) : this._internal(
          () => TiktokCommentController()..videoId = videoId,
          from: tiktokCommentControllerProvider,
          name: r'tiktokCommentControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tiktokCommentControllerHash,
          dependencies: TiktokCommentControllerFamily._dependencies,
          allTransitiveDependencies:
              TiktokCommentControllerFamily._allTransitiveDependencies,
          videoId: videoId,
        );

  TiktokCommentControllerProvider._internal(
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
  FutureOr<List<CommentTikTok>> runNotifierBuild(
    covariant TiktokCommentController notifier,
  ) {
    return notifier.build(
      videoId,
    );
  }

  @override
  Override overrideWith(TiktokCommentController Function() create) {
    return ProviderOverride(
      origin: this,
      override: TiktokCommentControllerProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<TiktokCommentController,
      List<CommentTikTok>> createElement() {
    return _TiktokCommentControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TiktokCommentControllerProvider && other.videoId == videoId;
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
mixin TiktokCommentControllerRef
    on AutoDisposeAsyncNotifierProviderRef<List<CommentTikTok>> {
  /// The parameter `videoId` of this provider.
  String get videoId;
}

class _TiktokCommentControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<TiktokCommentController,
        List<CommentTikTok>> with TiktokCommentControllerRef {
  _TiktokCommentControllerProviderElement(super.provider);

  @override
  String get videoId => (origin as TiktokCommentControllerProvider).videoId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
