// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_detail_participant.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$eventDetailParticipantHash() =>
    r'46fb36a875ccf4967da9c09fe5ef14af33838507';

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

abstract class _$EventDetailParticipant
    extends BuildlessAutoDisposeAsyncNotifier<AuthModel?> {
  late final String id;

  FutureOr<AuthModel?> build(
    String id,
  );
}

/// See also [EventDetailParticipant].
@ProviderFor(EventDetailParticipant)
const eventDetailParticipantProvider = EventDetailParticipantFamily();

/// See also [EventDetailParticipant].
class EventDetailParticipantFamily extends Family<AsyncValue<AuthModel?>> {
  /// See also [EventDetailParticipant].
  const EventDetailParticipantFamily();

  /// See also [EventDetailParticipant].
  EventDetailParticipantProvider call(
    String id,
  ) {
    return EventDetailParticipantProvider(
      id,
    );
  }

  @override
  EventDetailParticipantProvider getProviderOverride(
    covariant EventDetailParticipantProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'eventDetailParticipantProvider';
}

/// See also [EventDetailParticipant].
class EventDetailParticipantProvider
    extends AutoDisposeAsyncNotifierProviderImpl<EventDetailParticipant,
        AuthModel?> {
  /// See also [EventDetailParticipant].
  EventDetailParticipantProvider(
    String id,
  ) : this._internal(
          () => EventDetailParticipant()..id = id,
          from: eventDetailParticipantProvider,
          name: r'eventDetailParticipantProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$eventDetailParticipantHash,
          dependencies: EventDetailParticipantFamily._dependencies,
          allTransitiveDependencies:
              EventDetailParticipantFamily._allTransitiveDependencies,
          id: id,
        );

  EventDetailParticipantProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  FutureOr<AuthModel?> runNotifierBuild(
    covariant EventDetailParticipant notifier,
  ) {
    return notifier.build(
      id,
    );
  }

  @override
  Override overrideWith(EventDetailParticipant Function() create) {
    return ProviderOverride(
      origin: this,
      override: EventDetailParticipantProvider._internal(
        () => create()..id = id,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<EventDetailParticipant, AuthModel?>
      createElement() {
    return _EventDetailParticipantProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EventDetailParticipantProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin EventDetailParticipantRef
    on AutoDisposeAsyncNotifierProviderRef<AuthModel?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _EventDetailParticipantProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<EventDetailParticipant,
        AuthModel?> with EventDetailParticipantRef {
  _EventDetailParticipantProviderElement(super.provider);

  @override
  String get id => (origin as EventDetailParticipantProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
