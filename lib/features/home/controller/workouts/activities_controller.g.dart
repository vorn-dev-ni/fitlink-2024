// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activities_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activitiesControllerHash() =>
    r'3e55dfd6979c74de7e4a4754de6fd0e9a3278f95';

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

abstract class _$ActivitiesController
    extends BuildlessAsyncNotifier<List<WorkoutExcerciseResponse>?> {
  late final DateTime? date;
  late final String userId;

  FutureOr<List<WorkoutExcerciseResponse>?> build(
    DateTime? date,
    String userId,
  );
}

/// See also [ActivitiesController].
@ProviderFor(ActivitiesController)
const activitiesControllerProvider = ActivitiesControllerFamily();

/// See also [ActivitiesController].
class ActivitiesControllerFamily
    extends Family<AsyncValue<List<WorkoutExcerciseResponse>?>> {
  /// See also [ActivitiesController].
  const ActivitiesControllerFamily();

  /// See also [ActivitiesController].
  ActivitiesControllerProvider call(
    DateTime? date,
    String userId,
  ) {
    return ActivitiesControllerProvider(
      date,
      userId,
    );
  }

  @override
  ActivitiesControllerProvider getProviderOverride(
    covariant ActivitiesControllerProvider provider,
  ) {
    return call(
      provider.date,
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
  String? get name => r'activitiesControllerProvider';
}

/// See also [ActivitiesController].
class ActivitiesControllerProvider extends AsyncNotifierProviderImpl<
    ActivitiesController, List<WorkoutExcerciseResponse>?> {
  /// See also [ActivitiesController].
  ActivitiesControllerProvider(
    DateTime? date,
    String userId,
  ) : this._internal(
          () => ActivitiesController()
            ..date = date
            ..userId = userId,
          from: activitiesControllerProvider,
          name: r'activitiesControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$activitiesControllerHash,
          dependencies: ActivitiesControllerFamily._dependencies,
          allTransitiveDependencies:
              ActivitiesControllerFamily._allTransitiveDependencies,
          date: date,
          userId: userId,
        );

  ActivitiesControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
    required this.userId,
  }) : super.internal();

  final DateTime? date;
  final String userId;

  @override
  FutureOr<List<WorkoutExcerciseResponse>?> runNotifierBuild(
    covariant ActivitiesController notifier,
  ) {
    return notifier.build(
      date,
      userId,
    );
  }

  @override
  Override overrideWith(ActivitiesController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ActivitiesControllerProvider._internal(
        () => create()
          ..date = date
          ..userId = userId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
        userId: userId,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<ActivitiesController,
      List<WorkoutExcerciseResponse>?> createElement() {
    return _ActivitiesControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ActivitiesControllerProvider &&
        other.date == date &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ActivitiesControllerRef
    on AsyncNotifierProviderRef<List<WorkoutExcerciseResponse>?> {
  /// The parameter `date` of this provider.
  DateTime? get date;

  /// The parameter `userId` of this provider.
  String get userId;
}

class _ActivitiesControllerProviderElement extends AsyncNotifierProviderElement<
    ActivitiesController,
    List<WorkoutExcerciseResponse>?> with ActivitiesControllerRef {
  _ActivitiesControllerProviderElement(super.provider);

  @override
  DateTime? get date => (origin as ActivitiesControllerProvider).date;
  @override
  String get userId => (origin as ActivitiesControllerProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
