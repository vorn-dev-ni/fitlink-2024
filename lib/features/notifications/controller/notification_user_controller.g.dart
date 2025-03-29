// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_user_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationUserControllerHash() =>
    r'eab0726b47be7bf915149908448aea5f4b90d05d';

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

abstract class _$NotificationUserController
    extends BuildlessAutoDisposeAsyncNotifier<List<NotificationModel>> {
  late final String? uid;

  FutureOr<List<NotificationModel>> build(
    String? uid,
  );
}

/// See also [NotificationUserController].
@ProviderFor(NotificationUserController)
const notificationUserControllerProvider = NotificationUserControllerFamily();

/// See also [NotificationUserController].
class NotificationUserControllerFamily
    extends Family<AsyncValue<List<NotificationModel>>> {
  /// See also [NotificationUserController].
  const NotificationUserControllerFamily();

  /// See also [NotificationUserController].
  NotificationUserControllerProvider call(
    String? uid,
  ) {
    return NotificationUserControllerProvider(
      uid,
    );
  }

  @override
  NotificationUserControllerProvider getProviderOverride(
    covariant NotificationUserControllerProvider provider,
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
  String? get name => r'notificationUserControllerProvider';
}

/// See also [NotificationUserController].
class NotificationUserControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<NotificationUserController,
        List<NotificationModel>> {
  /// See also [NotificationUserController].
  NotificationUserControllerProvider(
    String? uid,
  ) : this._internal(
          () => NotificationUserController()..uid = uid,
          from: notificationUserControllerProvider,
          name: r'notificationUserControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$notificationUserControllerHash,
          dependencies: NotificationUserControllerFamily._dependencies,
          allTransitiveDependencies:
              NotificationUserControllerFamily._allTransitiveDependencies,
          uid: uid,
        );

  NotificationUserControllerProvider._internal(
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
  FutureOr<List<NotificationModel>> runNotifierBuild(
    covariant NotificationUserController notifier,
  ) {
    return notifier.build(
      uid,
    );
  }

  @override
  Override overrideWith(NotificationUserController Function() create) {
    return ProviderOverride(
      origin: this,
      override: NotificationUserControllerProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<NotificationUserController,
      List<NotificationModel>> createElement() {
    return _NotificationUserControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NotificationUserControllerProvider && other.uid == uid;
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
mixin NotificationUserControllerRef
    on AutoDisposeAsyncNotifierProviderRef<List<NotificationModel>> {
  /// The parameter `uid` of this provider.
  String? get uid;
}

class _NotificationUserControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<NotificationUserController,
        List<NotificationModel>> with NotificationUserControllerRef {
  _NotificationUserControllerProviderElement(super.provider);

  @override
  String? get uid => (origin as NotificationUserControllerProvider).uid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
