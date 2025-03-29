// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_tag_conroller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mediaTagConrollerHash() => r'1ead33e5bdc59dad5f942a3280d65cee77dacbfd';

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

abstract class _$MediaTagConroller extends BuildlessAsyncNotifier<MediaCount?> {
  late final String uid;

  FutureOr<MediaCount?> build(
    String uid,
  );
}

/// See also [MediaTagConroller].
@ProviderFor(MediaTagConroller)
const mediaTagConrollerProvider = MediaTagConrollerFamily();

/// See also [MediaTagConroller].
class MediaTagConrollerFamily extends Family<AsyncValue<MediaCount?>> {
  /// See also [MediaTagConroller].
  const MediaTagConrollerFamily();

  /// See also [MediaTagConroller].
  MediaTagConrollerProvider call(
    String uid,
  ) {
    return MediaTagConrollerProvider(
      uid,
    );
  }

  @override
  MediaTagConrollerProvider getProviderOverride(
    covariant MediaTagConrollerProvider provider,
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
  String? get name => r'mediaTagConrollerProvider';
}

/// See also [MediaTagConroller].
class MediaTagConrollerProvider
    extends AsyncNotifierProviderImpl<MediaTagConroller, MediaCount?> {
  /// See also [MediaTagConroller].
  MediaTagConrollerProvider(
    String uid,
  ) : this._internal(
          () => MediaTagConroller()..uid = uid,
          from: mediaTagConrollerProvider,
          name: r'mediaTagConrollerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$mediaTagConrollerHash,
          dependencies: MediaTagConrollerFamily._dependencies,
          allTransitiveDependencies:
              MediaTagConrollerFamily._allTransitiveDependencies,
          uid: uid,
        );

  MediaTagConrollerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
  }) : super.internal();

  final String uid;

  @override
  FutureOr<MediaCount?> runNotifierBuild(
    covariant MediaTagConroller notifier,
  ) {
    return notifier.build(
      uid,
    );
  }

  @override
  Override overrideWith(MediaTagConroller Function() create) {
    return ProviderOverride(
      origin: this,
      override: MediaTagConrollerProvider._internal(
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
  AsyncNotifierProviderElement<MediaTagConroller, MediaCount?> createElement() {
    return _MediaTagConrollerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MediaTagConrollerProvider && other.uid == uid;
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
mixin MediaTagConrollerRef on AsyncNotifierProviderRef<MediaCount?> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _MediaTagConrollerProviderElement
    extends AsyncNotifierProviderElement<MediaTagConroller, MediaCount?>
    with MediaTagConrollerRef {
  _MediaTagConrollerProviderElement(super.provider);

  @override
  String get uid => (origin as MediaTagConrollerProvider).uid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
