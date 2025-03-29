// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_detail_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$messageDetailControllerHash() =>
    r'8e64a328be1a88621b9840981ba2fa3a51b060e9';

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

abstract class _$MessageDetailController
    extends BuildlessStreamNotifier<List<Message>?> {
  late final String senderId;
  late final String receiverId;
  late final String? chatId;

  Stream<List<Message>?> build({
    required String senderId,
    required String receiverId,
    String? chatId,
  });
}

/// See also [MessageDetailController].
@ProviderFor(MessageDetailController)
const messageDetailControllerProvider = MessageDetailControllerFamily();

/// See also [MessageDetailController].
class MessageDetailControllerFamily extends Family<AsyncValue<List<Message>?>> {
  /// See also [MessageDetailController].
  const MessageDetailControllerFamily();

  /// See also [MessageDetailController].
  MessageDetailControllerProvider call({
    required String senderId,
    required String receiverId,
    String? chatId,
  }) {
    return MessageDetailControllerProvider(
      senderId: senderId,
      receiverId: receiverId,
      chatId: chatId,
    );
  }

  @override
  MessageDetailControllerProvider getProviderOverride(
    covariant MessageDetailControllerProvider provider,
  ) {
    return call(
      senderId: provider.senderId,
      receiverId: provider.receiverId,
      chatId: provider.chatId,
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
  String? get name => r'messageDetailControllerProvider';
}

/// See also [MessageDetailController].
class MessageDetailControllerProvider extends StreamNotifierProviderImpl<
    MessageDetailController, List<Message>?> {
  /// See also [MessageDetailController].
  MessageDetailControllerProvider({
    required String senderId,
    required String receiverId,
    String? chatId,
  }) : this._internal(
          () => MessageDetailController()
            ..senderId = senderId
            ..receiverId = receiverId
            ..chatId = chatId,
          from: messageDetailControllerProvider,
          name: r'messageDetailControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$messageDetailControllerHash,
          dependencies: MessageDetailControllerFamily._dependencies,
          allTransitiveDependencies:
              MessageDetailControllerFamily._allTransitiveDependencies,
          senderId: senderId,
          receiverId: receiverId,
          chatId: chatId,
        );

  MessageDetailControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.senderId,
    required this.receiverId,
    required this.chatId,
  }) : super.internal();

  final String senderId;
  final String receiverId;
  final String? chatId;

  @override
  Stream<List<Message>?> runNotifierBuild(
    covariant MessageDetailController notifier,
  ) {
    return notifier.build(
      senderId: senderId,
      receiverId: receiverId,
      chatId: chatId,
    );
  }

  @override
  Override overrideWith(MessageDetailController Function() create) {
    return ProviderOverride(
      origin: this,
      override: MessageDetailControllerProvider._internal(
        () => create()
          ..senderId = senderId
          ..receiverId = receiverId
          ..chatId = chatId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        senderId: senderId,
        receiverId: receiverId,
        chatId: chatId,
      ),
    );
  }

  @override
  StreamNotifierProviderElement<MessageDetailController, List<Message>?>
      createElement() {
    return _MessageDetailControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MessageDetailControllerProvider &&
        other.senderId == senderId &&
        other.receiverId == receiverId &&
        other.chatId == chatId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, senderId.hashCode);
    hash = _SystemHash.combine(hash, receiverId.hashCode);
    hash = _SystemHash.combine(hash, chatId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MessageDetailControllerRef on StreamNotifierProviderRef<List<Message>?> {
  /// The parameter `senderId` of this provider.
  String get senderId;

  /// The parameter `receiverId` of this provider.
  String get receiverId;

  /// The parameter `chatId` of this provider.
  String? get chatId;
}

class _MessageDetailControllerProviderElement
    extends StreamNotifierProviderElement<MessageDetailController,
        List<Message>?> with MessageDetailControllerRef {
  _MessageDetailControllerProviderElement(super.provider);

  @override
  String get senderId => (origin as MessageDetailControllerProvider).senderId;
  @override
  String get receiverId =>
      (origin as MessageDetailControllerProvider).receiverId;
  @override
  String? get chatId => (origin as MessageDetailControllerProvider).chatId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
