// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_video_user_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profileVideoUserControllerHash() =>
    r'2e1059600ec0d661cff5ce631ca6994366496af8';

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

abstract class _$ProfileVideoUserController
    extends BuildlessStreamNotifier<List<VideoTikTok>> {
  late final String userId;

  Stream<List<VideoTikTok>> build(
    String userId,
  );
}

/// See also [ProfileVideoUserController].
@ProviderFor(ProfileVideoUserController)
const profileVideoUserControllerProvider = ProfileVideoUserControllerFamily();

/// See also [ProfileVideoUserController].
class ProfileVideoUserControllerFamily
    extends Family<AsyncValue<List<VideoTikTok>>> {
  /// See also [ProfileVideoUserController].
  const ProfileVideoUserControllerFamily();

  /// See also [ProfileVideoUserController].
  ProfileVideoUserControllerProvider call(
    String userId,
  ) {
    return ProfileVideoUserControllerProvider(
      userId,
    );
  }

  @override
  ProfileVideoUserControllerProvider getProviderOverride(
    covariant ProfileVideoUserControllerProvider provider,
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
  String? get name => r'profileVideoUserControllerProvider';
}

/// See also [ProfileVideoUserController].
class ProfileVideoUserControllerProvider extends StreamNotifierProviderImpl<
    ProfileVideoUserController, List<VideoTikTok>> {
  /// See also [ProfileVideoUserController].
  ProfileVideoUserControllerProvider(
    String userId,
  ) : this._internal(
          () => ProfileVideoUserController()..userId = userId,
          from: profileVideoUserControllerProvider,
          name: r'profileVideoUserControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$profileVideoUserControllerHash,
          dependencies: ProfileVideoUserControllerFamily._dependencies,
          allTransitiveDependencies:
              ProfileVideoUserControllerFamily._allTransitiveDependencies,
          userId: userId,
        );

  ProfileVideoUserControllerProvider._internal(
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
  Stream<List<VideoTikTok>> runNotifierBuild(
    covariant ProfileVideoUserController notifier,
  ) {
    return notifier.build(
      userId,
    );
  }

  @override
  Override overrideWith(ProfileVideoUserController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProfileVideoUserControllerProvider._internal(
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
  StreamNotifierProviderElement<ProfileVideoUserController, List<VideoTikTok>>
      createElement() {
    return _ProfileVideoUserControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProfileVideoUserControllerProvider &&
        other.userId == userId;
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
mixin ProfileVideoUserControllerRef
    on StreamNotifierProviderRef<List<VideoTikTok>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _ProfileVideoUserControllerProviderElement
    extends StreamNotifierProviderElement<ProfileVideoUserController,
        List<VideoTikTok>> with ProfileVideoUserControllerRef {
  _ProfileVideoUserControllerProviderElement(super.provider);

  @override
  String get userId => (origin as ProfileVideoUserControllerProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
