// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'single_user_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$singleUserControllerHash() =>
    r'720c6dd9daf4fdbf1ae638996c4a600be63f001b';

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

abstract class _$SingleUserController
    extends BuildlessAsyncNotifier<AuthModel?> {
  late final String uid;

  FutureOr<AuthModel?> build(
    String uid,
  );
}

/// See also [SingleUserController].
@ProviderFor(SingleUserController)
const singleUserControllerProvider = SingleUserControllerFamily();

/// See also [SingleUserController].
class SingleUserControllerFamily extends Family<AsyncValue<AuthModel?>> {
  /// See also [SingleUserController].
  const SingleUserControllerFamily();

  /// See also [SingleUserController].
  SingleUserControllerProvider call(
    String uid,
  ) {
    return SingleUserControllerProvider(
      uid,
    );
  }

  @override
  SingleUserControllerProvider getProviderOverride(
    covariant SingleUserControllerProvider provider,
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
  String? get name => r'singleUserControllerProvider';
}

/// See also [SingleUserController].
class SingleUserControllerProvider
    extends AsyncNotifierProviderImpl<SingleUserController, AuthModel?> {
  /// See also [SingleUserController].
  SingleUserControllerProvider(
    String uid,
  ) : this._internal(
          () => SingleUserController()..uid = uid,
          from: singleUserControllerProvider,
          name: r'singleUserControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$singleUserControllerHash,
          dependencies: SingleUserControllerFamily._dependencies,
          allTransitiveDependencies:
              SingleUserControllerFamily._allTransitiveDependencies,
          uid: uid,
        );

  SingleUserControllerProvider._internal(
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
  FutureOr<AuthModel?> runNotifierBuild(
    covariant SingleUserController notifier,
  ) {
    return notifier.build(
      uid,
    );
  }

  @override
  Override overrideWith(SingleUserController Function() create) {
    return ProviderOverride(
      origin: this,
      override: SingleUserControllerProvider._internal(
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
  AsyncNotifierProviderElement<SingleUserController, AuthModel?>
      createElement() {
    return _SingleUserControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SingleUserControllerProvider && other.uid == uid;
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
mixin SingleUserControllerRef on AsyncNotifierProviderRef<AuthModel?> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _SingleUserControllerProviderElement
    extends AsyncNotifierProviderElement<SingleUserController, AuthModel?>
    with SingleUserControllerRef {
  _SingleUserControllerProviderElement(super.provider);

  @override
  String get uid => (origin as SingleUserControllerProvider).uid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
