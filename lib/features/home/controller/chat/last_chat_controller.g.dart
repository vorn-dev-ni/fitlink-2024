// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'last_chat_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$lastChatControllerHash() =>
    r'27176d267866350d8bf26361b11612534652b153';

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

abstract class _$LastChatController extends BuildlessStreamNotifier<Chat?> {
  late final String userId;
  late final String currentId;

  Stream<Chat?> build({
    required String userId,
    required String currentId,
  });
}

/// See also [LastChatController].
@ProviderFor(LastChatController)
const lastChatControllerProvider = LastChatControllerFamily();

/// See also [LastChatController].
class LastChatControllerFamily extends Family<AsyncValue<Chat?>> {
  /// See also [LastChatController].
  const LastChatControllerFamily();

  /// See also [LastChatController].
  LastChatControllerProvider call({
    required String userId,
    required String currentId,
  }) {
    return LastChatControllerProvider(
      userId: userId,
      currentId: currentId,
    );
  }

  @override
  LastChatControllerProvider getProviderOverride(
    covariant LastChatControllerProvider provider,
  ) {
    return call(
      userId: provider.userId,
      currentId: provider.currentId,
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
  String? get name => r'lastChatControllerProvider';
}

/// See also [LastChatController].
class LastChatControllerProvider
    extends StreamNotifierProviderImpl<LastChatController, Chat?> {
  /// See also [LastChatController].
  LastChatControllerProvider({
    required String userId,
    required String currentId,
  }) : this._internal(
          () => LastChatController()
            ..userId = userId
            ..currentId = currentId,
          from: lastChatControllerProvider,
          name: r'lastChatControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$lastChatControllerHash,
          dependencies: LastChatControllerFamily._dependencies,
          allTransitiveDependencies:
              LastChatControllerFamily._allTransitiveDependencies,
          userId: userId,
          currentId: currentId,
        );

  LastChatControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
    required this.currentId,
  }) : super.internal();

  final String userId;
  final String currentId;

  @override
  Stream<Chat?> runNotifierBuild(
    covariant LastChatController notifier,
  ) {
    return notifier.build(
      userId: userId,
      currentId: currentId,
    );
  }

  @override
  Override overrideWith(LastChatController Function() create) {
    return ProviderOverride(
      origin: this,
      override: LastChatControllerProvider._internal(
        () => create()
          ..userId = userId
          ..currentId = currentId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
        currentId: currentId,
      ),
    );
  }

  @override
  StreamNotifierProviderElement<LastChatController, Chat?> createElement() {
    return _LastChatControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LastChatControllerProvider &&
        other.userId == userId &&
        other.currentId == currentId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);
    hash = _SystemHash.combine(hash, currentId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LastChatControllerRef on StreamNotifierProviderRef<Chat?> {
  /// The parameter `userId` of this provider.
  String get userId;

  /// The parameter `currentId` of this provider.
  String get currentId;
}

class _LastChatControllerProviderElement
    extends StreamNotifierProviderElement<LastChatController, Chat?>
    with LastChatControllerRef {
  _LastChatControllerProviderElement(super.provider);

  @override
  String get userId => (origin as LastChatControllerProvider).userId;
  @override
  String get currentId => (origin as LastChatControllerProvider).currentId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
