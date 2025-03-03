// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_like_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userLikeControllerHash() =>
    r'76d2682b75d62c3218b214a78669a4eb802abe53';

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

abstract class _$UserLikeController extends BuildlessNotifier<bool> {
  late final String? postId;

  bool build(
    String? postId,
  );
}

/// See also [UserLikeController].
@ProviderFor(UserLikeController)
const userLikeControllerProvider = UserLikeControllerFamily();

/// See also [UserLikeController].
class UserLikeControllerFamily extends Family<bool> {
  /// See also [UserLikeController].
  const UserLikeControllerFamily();

  /// See also [UserLikeController].
  UserLikeControllerProvider call(
    String? postId,
  ) {
    return UserLikeControllerProvider(
      postId,
    );
  }

  @override
  UserLikeControllerProvider getProviderOverride(
    covariant UserLikeControllerProvider provider,
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
  String? get name => r'userLikeControllerProvider';
}

/// See also [UserLikeController].
class UserLikeControllerProvider
    extends NotifierProviderImpl<UserLikeController, bool> {
  /// See also [UserLikeController].
  UserLikeControllerProvider(
    String? postId,
  ) : this._internal(
          () => UserLikeController()..postId = postId,
          from: userLikeControllerProvider,
          name: r'userLikeControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userLikeControllerHash,
          dependencies: UserLikeControllerFamily._dependencies,
          allTransitiveDependencies:
              UserLikeControllerFamily._allTransitiveDependencies,
          postId: postId,
        );

  UserLikeControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.postId,
  }) : super.internal();

  final String? postId;

  @override
  bool runNotifierBuild(
    covariant UserLikeController notifier,
  ) {
    return notifier.build(
      postId,
    );
  }

  @override
  Override overrideWith(UserLikeController Function() create) {
    return ProviderOverride(
      origin: this,
      override: UserLikeControllerProvider._internal(
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
  NotifierProviderElement<UserLikeController, bool> createElement() {
    return _UserLikeControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserLikeControllerProvider && other.postId == postId;
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
mixin UserLikeControllerRef on NotifierProviderRef<bool> {
  /// The parameter `postId` of this provider.
  String? get postId;
}

class _UserLikeControllerProviderElement
    extends NotifierProviderElement<UserLikeController, bool>
    with UserLikeControllerRef {
  _UserLikeControllerProviderElement(super.provider);

  @override
  String? get postId => (origin as UserLikeControllerProvider).postId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
