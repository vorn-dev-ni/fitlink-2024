// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_header_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userHeaderControllerHash() =>
    r'7c825363a6af3486ed1fd2a05765d41b507e21dd';

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

abstract class _$UserHeaderController
    extends BuildlessStreamNotifier<UserData?> {
  late final String userId;

  Stream<UserData?> build(
    String userId,
  );
}

/// See also [UserHeaderController].
@ProviderFor(UserHeaderController)
const userHeaderControllerProvider = UserHeaderControllerFamily();

/// See also [UserHeaderController].
class UserHeaderControllerFamily extends Family<AsyncValue<UserData?>> {
  /// See also [UserHeaderController].
  const UserHeaderControllerFamily();

  /// See also [UserHeaderController].
  UserHeaderControllerProvider call(
    String userId,
  ) {
    return UserHeaderControllerProvider(
      userId,
    );
  }

  @override
  UserHeaderControllerProvider getProviderOverride(
    covariant UserHeaderControllerProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'userHeaderControllerProvider';
}

/// See also [UserHeaderController].
class UserHeaderControllerProvider
    extends StreamNotifierProviderImpl<UserHeaderController, UserData?> {
  /// See also [UserHeaderController].
  UserHeaderControllerProvider(
    String userId,
  ) : this._internal(
          () => UserHeaderController()..userId = userId,
          from: userHeaderControllerProvider,
          name: r'userHeaderControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userHeaderControllerHash,
          dependencies: UserHeaderControllerFamily._dependencies,
          allTransitiveDependencies:
              UserHeaderControllerFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserHeaderControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Stream<UserData?> runNotifierBuild(
    covariant UserHeaderController notifier,
  ) {
    return notifier.build(
      userId,
    );
  }

  @override
  Override overrideWith(UserHeaderController Function() create) {
    return ProviderOverride(
      origin: this,
      override: UserHeaderControllerProvider._internal(
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
  StreamNotifierProviderElement<UserHeaderController, UserData?>
      createElement() {
    return _UserHeaderControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserHeaderControllerProvider && other.userId == userId;
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
mixin UserHeaderControllerRef on StreamNotifierProviderRef<UserData?> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserHeaderControllerProviderElement
    extends StreamNotifierProviderElement<UserHeaderController, UserData?>
    with UserHeaderControllerRef {
  _UserHeaderControllerProviderElement(super.provider);

  @override
  String get userId => (origin as UserHeaderControllerProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
