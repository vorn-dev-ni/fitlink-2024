// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_post_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profilePostControllerHash() =>
    r'8bf7037fc3a2b5b6c9c92e3caf29888d739d0c21';

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

abstract class _$ProfilePostController
    extends BuildlessStreamNotifier<List<Post>?> {
  late final String? uid;

  Stream<List<Post>?> build(
    String? uid,
  );
}

/// See also [ProfilePostController].
@ProviderFor(ProfilePostController)
const profilePostControllerProvider = ProfilePostControllerFamily();

/// See also [ProfilePostController].
class ProfilePostControllerFamily extends Family<AsyncValue<List<Post>?>> {
  /// See also [ProfilePostController].
  const ProfilePostControllerFamily();

  /// See also [ProfilePostController].
  ProfilePostControllerProvider call(
    String? uid,
  ) {
    return ProfilePostControllerProvider(
      uid,
    );
  }

  @override
  ProfilePostControllerProvider getProviderOverride(
    covariant ProfilePostControllerProvider provider,
  ) {
    return call(
      provider.uid,
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
  String? get name => r'profilePostControllerProvider';
}

/// See also [ProfilePostController].
class ProfilePostControllerProvider
    extends StreamNotifierProviderImpl<ProfilePostController, List<Post>?> {
  /// See also [ProfilePostController].
  ProfilePostControllerProvider(
    String? uid,
  ) : this._internal(
          () => ProfilePostController()..uid = uid,
          from: profilePostControllerProvider,
          name: r'profilePostControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$profilePostControllerHash,
          dependencies: ProfilePostControllerFamily._dependencies,
          allTransitiveDependencies:
              ProfilePostControllerFamily._allTransitiveDependencies,
          uid: uid,
        );

  ProfilePostControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
  }) : super.internal();

  final String? uid;

  @override
  Stream<List<Post>?> runNotifierBuild(
    covariant ProfilePostController notifier,
  ) {
    return notifier.build(
      uid,
    );
  }

  @override
  Override overrideWith(ProfilePostController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProfilePostControllerProvider._internal(
        () => create()..uid = uid,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
      ),
    );
  }

  @override
  StreamNotifierProviderElement<ProfilePostController, List<Post>?>
      createElement() {
    return _ProfilePostControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProfilePostControllerProvider && other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProfilePostControllerRef on StreamNotifierProviderRef<List<Post>?> {
  /// The parameter `uid` of this provider.
  String? get uid;
}

class _ProfilePostControllerProviderElement
    extends StreamNotifierProviderElement<ProfilePostController, List<Post>?>
    with ProfilePostControllerRef {
  _ProfilePostControllerProviderElement(super.provider);

  @override
  String? get uid => (origin as ProfilePostControllerProvider).uid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
