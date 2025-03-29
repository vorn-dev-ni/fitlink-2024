// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'following_friend_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$followingFriendControllerHash() =>
    r'b442ed43e1f9f6271ea79ddbadc3970a36938b20';

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

abstract class _$FollowingFriendController
    extends BuildlessStreamNotifier<List<UserData>?> {
  late final String? userId;

  Stream<List<UserData>?> build({
    String? userId,
  });
}

/// See also [FollowingFriendController].
@ProviderFor(FollowingFriendController)
const followingFriendControllerProvider = FollowingFriendControllerFamily();

/// See also [FollowingFriendController].
class FollowingFriendControllerFamily
    extends Family<AsyncValue<List<UserData>?>> {
  /// See also [FollowingFriendController].
  const FollowingFriendControllerFamily();

  /// See also [FollowingFriendController].
  FollowingFriendControllerProvider call({
    String? userId,
  }) {
    return FollowingFriendControllerProvider(
      userId: userId,
    );
  }

  @override
  FollowingFriendControllerProvider getProviderOverride(
    covariant FollowingFriendControllerProvider provider,
  ) {
    return call(
      userId: provider.userId,
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
  String? get name => r'followingFriendControllerProvider';
}

/// See also [FollowingFriendController].
class FollowingFriendControllerProvider extends StreamNotifierProviderImpl<
    FollowingFriendController, List<UserData>?> {
  /// See also [FollowingFriendController].
  FollowingFriendControllerProvider({
    String? userId,
  }) : this._internal(
          () => FollowingFriendController()..userId = userId,
          from: followingFriendControllerProvider,
          name: r'followingFriendControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$followingFriendControllerHash,
          dependencies: FollowingFriendControllerFamily._dependencies,
          allTransitiveDependencies:
              FollowingFriendControllerFamily._allTransitiveDependencies,
          userId: userId,
        );

  FollowingFriendControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String? userId;

  @override
  Stream<List<UserData>?> runNotifierBuild(
    covariant FollowingFriendController notifier,
  ) {
    return notifier.build(
      userId: userId,
    );
  }

  @override
  Override overrideWith(FollowingFriendController Function() create) {
    return ProviderOverride(
      origin: this,
      override: FollowingFriendControllerProvider._internal(
        () => create()..userId = userId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  StreamNotifierProviderElement<FollowingFriendController, List<UserData>?>
      createElement() {
    return _FollowingFriendControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FollowingFriendControllerProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FollowingFriendControllerRef
    on StreamNotifierProviderRef<List<UserData>?> {
  /// The parameter `userId` of this provider.
  String? get userId;
}

class _FollowingFriendControllerProviderElement
    extends StreamNotifierProviderElement<FollowingFriendController,
        List<UserData>?> with FollowingFriendControllerRef {
  _FollowingFriendControllerProviderElement(super.provider);

  @override
  String? get userId => (origin as FollowingFriendControllerProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
