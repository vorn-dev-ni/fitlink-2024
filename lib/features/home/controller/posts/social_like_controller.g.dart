// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_like_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$socialLikeControllerHash() =>
    r'0f3213c98dd77a8b6c1d0f13ad547e8832b65390';

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

abstract class _$SocialLikeController extends BuildlessStreamNotifier<Post> {
  late final String postId;

  Stream<Post> build(
    String postId,
  );
}

/// See also [SocialLikeController].
@ProviderFor(SocialLikeController)
const socialLikeControllerProvider = SocialLikeControllerFamily();

/// See also [SocialLikeController].
class SocialLikeControllerFamily extends Family<AsyncValue<Post>> {
  /// See also [SocialLikeController].
  const SocialLikeControllerFamily();

  /// See also [SocialLikeController].
  SocialLikeControllerProvider call(
    String postId,
  ) {
    return SocialLikeControllerProvider(
      postId,
    );
  }

  @override
  SocialLikeControllerProvider getProviderOverride(
    covariant SocialLikeControllerProvider provider,
  ) {
    return call(
      provider.postId,
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
  String? get name => r'socialLikeControllerProvider';
}

/// See also [SocialLikeController].
class SocialLikeControllerProvider
    extends StreamNotifierProviderImpl<SocialLikeController, Post> {
  /// See also [SocialLikeController].
  SocialLikeControllerProvider(
    String postId,
  ) : this._internal(
          () => SocialLikeController()..postId = postId,
          from: socialLikeControllerProvider,
          name: r'socialLikeControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$socialLikeControllerHash,
          dependencies: SocialLikeControllerFamily._dependencies,
          allTransitiveDependencies:
              SocialLikeControllerFamily._allTransitiveDependencies,
          postId: postId,
        );

  SocialLikeControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.postId,
  }) : super.internal();

  final String postId;

  @override
  Stream<Post> runNotifierBuild(
    covariant SocialLikeController notifier,
  ) {
    return notifier.build(
      postId,
    );
  }

  @override
  Override overrideWith(SocialLikeController Function() create) {
    return ProviderOverride(
      origin: this,
      override: SocialLikeControllerProvider._internal(
        () => create()..postId = postId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        postId: postId,
      ),
    );
  }

  @override
  StreamNotifierProviderElement<SocialLikeController, Post> createElement() {
    return _SocialLikeControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SocialLikeControllerProvider && other.postId == postId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, postId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SocialLikeControllerRef on StreamNotifierProviderRef<Post> {
  /// The parameter `postId` of this provider.
  String get postId;
}

class _SocialLikeControllerProviderElement
    extends StreamNotifierProviderElement<SocialLikeController, Post>
    with SocialLikeControllerRef {
  _SocialLikeControllerProviderElement(super.provider);

  @override
  String get postId => (origin as SocialLikeControllerProvider).postId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
