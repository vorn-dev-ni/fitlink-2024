// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'excercises_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$excercisesControllerHash() =>
    r'fc96ae8fe2b5c06206109c0cf73d3eeb281ac745';

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

abstract class _$ExcercisesController
    extends BuildlessAsyncNotifier<List<Exercises>?> {
  late final String docId;

  FutureOr<List<Exercises>?> build(
    String docId,
  );
}

/// See also [ExcercisesController].
@ProviderFor(ExcercisesController)
const excercisesControllerProvider = ExcercisesControllerFamily();

/// See also [ExcercisesController].
class ExcercisesControllerFamily extends Family<AsyncValue<List<Exercises>?>> {
  /// See also [ExcercisesController].
  const ExcercisesControllerFamily();

  /// See also [ExcercisesController].
  ExcercisesControllerProvider call(
    String docId,
  ) {
    return ExcercisesControllerProvider(
      docId,
    );
  }

  @override
  ExcercisesControllerProvider getProviderOverride(
    covariant ExcercisesControllerProvider provider,
  ) {
    return call(
      provider.docId,
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
  String? get name => r'excercisesControllerProvider';
}

/// See also [ExcercisesController].
class ExcercisesControllerProvider
    extends AsyncNotifierProviderImpl<ExcercisesController, List<Exercises>?> {
  /// See also [ExcercisesController].
  ExcercisesControllerProvider(
    String docId,
  ) : this._internal(
          () => ExcercisesController()..docId = docId,
          from: excercisesControllerProvider,
          name: r'excercisesControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$excercisesControllerHash,
          dependencies: ExcercisesControllerFamily._dependencies,
          allTransitiveDependencies:
              ExcercisesControllerFamily._allTransitiveDependencies,
          docId: docId,
        );

  ExcercisesControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.docId,
  }) : super.internal();

  final String docId;

  @override
  FutureOr<List<Exercises>?> runNotifierBuild(
    covariant ExcercisesController notifier,
  ) {
    return notifier.build(
      docId,
    );
  }

  @override
  Override overrideWith(ExcercisesController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ExcercisesControllerProvider._internal(
        () => create()..docId = docId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        docId: docId,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<ExcercisesController, List<Exercises>?>
      createElement() {
    return _ExcercisesControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExcercisesControllerProvider && other.docId == docId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, docId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ExcercisesControllerRef on AsyncNotifierProviderRef<List<Exercises>?> {
  /// The parameter `docId` of this provider.
  String get docId;
}

class _ExcercisesControllerProviderElement
    extends AsyncNotifierProviderElement<ExcercisesController, List<Exercises>?>
    with ExcercisesControllerRef {
  _ExcercisesControllerProviderElement(super.provider);

  @override
  String get docId => (origin as ExcercisesControllerProvider).docId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
