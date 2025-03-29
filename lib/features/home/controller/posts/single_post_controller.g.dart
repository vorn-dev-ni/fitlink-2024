// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'single_post_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$singlePostControllerHash() =>
    r'13744015ecb77c9ab17c4cfc8b48693ac7804f19';

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

abstract class _$SinglePostController extends BuildlessStreamNotifier<Post?> {
  late final String postId;

  Stream<Post?> build(
    String postId,
  );
}

/// See also [SinglePostController].
@ProviderFor(SinglePostController)
const singlePostControllerProvider = SinglePostControllerFamily();

/// See also [SinglePostController].
class SinglePostControllerFamily extends Family<AsyncValue<Post?>> {
  /// See also [SinglePostController].
  const SinglePostControllerFamily();

  /// See also [SinglePostController].
  SinglePostControllerProvider call(
    String postId,
  ) {
    return SinglePostControllerProvider(
      postId,
    );
  }

  @override
  SinglePostControllerProvider getProviderOverride(
    covariant SinglePostControllerProvider provider,
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
  String? get name => r'singlePostControllerProvider';
}

/// See also [SinglePostController].
class SinglePostControllerProvider
    extends StreamNotifierProviderImpl<SinglePostController, Post?> {
  /// See also [SinglePostController].
  SinglePostControllerProvider(
    String postId,
  ) : this._internal(
          () => SinglePostController()..postId = postId,
          from: singlePostControllerProvider,
          name: r'singlePostControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$singlePostControllerHash,
          dependencies: SinglePostControllerFamily._dependencies,
          allTransitiveDependencies:
              SinglePostControllerFamily._allTransitiveDependencies,
          postId: postId,
        );

  SinglePostControllerProvider._internal(
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
  Stream<Post?> runNotifierBuild(
    covariant SinglePostController notifier,
  ) {
    return notifier.build(
      postId,
    );
  }

  @override
  Override overrideWith(SinglePostController Function() create) {
    return ProviderOverride(
      origin: this,
      override: SinglePostControllerProvider._internal(
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
  StreamNotifierProviderElement<SinglePostController, Post?> createElement() {
    return _SinglePostControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SinglePostControllerProvider && other.postId == postId;
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
mixin SinglePostControllerRef on StreamNotifierProviderRef<Post?> {
  /// The parameter `postId` of this provider.
  String get postId;
}

class _SinglePostControllerProviderElement
    extends StreamNotifierProviderElement<SinglePostController, Post?>
    with SinglePostControllerRef {
  _SinglePostControllerProviderElement(super.provider);

  @override
  String get postId => (origin as SinglePostControllerProvider).postId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
