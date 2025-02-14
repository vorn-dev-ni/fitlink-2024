// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$workoutControllerHash() => r'8f8fecd43b98210673489e3d936f816dd0237703';

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

abstract class _$WorkoutController
    extends BuildlessAsyncNotifier<List<WorkoutExcerciseResponse>?> {
  late final WorkoutType workoutType;

  FutureOr<List<WorkoutExcerciseResponse>?> build(
    WorkoutType workoutType,
  );
}

/// See also [WorkoutController].
@ProviderFor(WorkoutController)
const workoutControllerProvider = WorkoutControllerFamily();

/// See also [WorkoutController].
class WorkoutControllerFamily
    extends Family<AsyncValue<List<WorkoutExcerciseResponse>?>> {
  /// See also [WorkoutController].
  const WorkoutControllerFamily();

  /// See also [WorkoutController].
  WorkoutControllerProvider call(
    WorkoutType workoutType,
  ) {
    return WorkoutControllerProvider(
      workoutType,
    );
  }

  @override
  WorkoutControllerProvider getProviderOverride(
    covariant WorkoutControllerProvider provider,
  ) {
    return call(
      provider.workoutType,
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
  String? get name => r'workoutControllerProvider';
}

/// See also [WorkoutController].
class WorkoutControllerProvider extends AsyncNotifierProviderImpl<
    WorkoutController, List<WorkoutExcerciseResponse>?> {
  /// See also [WorkoutController].
  WorkoutControllerProvider(
    WorkoutType workoutType,
  ) : this._internal(
          () => WorkoutController()..workoutType = workoutType,
          from: workoutControllerProvider,
          name: r'workoutControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$workoutControllerHash,
          dependencies: WorkoutControllerFamily._dependencies,
          allTransitiveDependencies:
              WorkoutControllerFamily._allTransitiveDependencies,
          workoutType: workoutType,
        );

  WorkoutControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.workoutType,
  }) : super.internal();

  final WorkoutType workoutType;

  @override
  FutureOr<List<WorkoutExcerciseResponse>?> runNotifierBuild(
    covariant WorkoutController notifier,
  ) {
    return notifier.build(
      workoutType,
    );
  }

  @override
  Override overrideWith(WorkoutController Function() create) {
    return ProviderOverride(
      origin: this,
      override: WorkoutControllerProvider._internal(
        () => create()..workoutType = workoutType,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        workoutType: workoutType,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<WorkoutController,
      List<WorkoutExcerciseResponse>?> createElement() {
    return _WorkoutControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkoutControllerProvider &&
        other.workoutType == workoutType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, workoutType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WorkoutControllerRef
    on AsyncNotifierProviderRef<List<WorkoutExcerciseResponse>?> {
  /// The parameter `workoutType` of this provider.
  WorkoutType get workoutType;
}

class _WorkoutControllerProviderElement extends AsyncNotifierProviderElement<
    WorkoutController,
    List<WorkoutExcerciseResponse>?> with WorkoutControllerRef {
  _WorkoutControllerProviderElement(super.provider);

  @override
  WorkoutType get workoutType =>
      (origin as WorkoutControllerProvider).workoutType;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
