// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_like_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$commentLikeControllerHash() =>
    r'b44c42fba39164d563d5ffabadbe92befe16e9d5';

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

abstract class _$CommentLikeController extends BuildlessNotifier<bool> {
  late final String? commentId;

  bool build(
    String? commentId,
  );
}

/// See also [CommentLikeController].
@ProviderFor(CommentLikeController)
const commentLikeControllerProvider = CommentLikeControllerFamily();

/// See also [CommentLikeController].
class CommentLikeControllerFamily extends Family<bool> {
  /// See also [CommentLikeController].
  const CommentLikeControllerFamily();

  /// See also [CommentLikeController].
  CommentLikeControllerProvider call(
    String? commentId,
  ) {
    return CommentLikeControllerProvider(
      commentId,
    );
  }

  @override
  CommentLikeControllerProvider getProviderOverride(
    covariant CommentLikeControllerProvider provider,
  ) {
    return call(
      provider.commentId,
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
  String? get name => r'commentLikeControllerProvider';
}

/// See also [CommentLikeController].
class CommentLikeControllerProvider
    extends NotifierProviderImpl<CommentLikeController, bool> {
  /// See also [CommentLikeController].
  CommentLikeControllerProvider(
    String? commentId,
  ) : this._internal(
          () => CommentLikeController()..commentId = commentId,
          from: commentLikeControllerProvider,
          name: r'commentLikeControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$commentLikeControllerHash,
          dependencies: CommentLikeControllerFamily._dependencies,
          allTransitiveDependencies:
              CommentLikeControllerFamily._allTransitiveDependencies,
          commentId: commentId,
        );

  CommentLikeControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.commentId,
  }) : super.internal();

  final String? commentId;

  @override
  bool runNotifierBuild(
    covariant CommentLikeController notifier,
  ) {
    return notifier.build(
      commentId,
    );
  }

  @override
  Override overrideWith(CommentLikeController Function() create) {
    return ProviderOverride(
      origin: this,
      override: CommentLikeControllerProvider._internal(
        () => create()..commentId = commentId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        commentId: commentId,
      ),
    );
  }

  @override
  NotifierProviderElement<CommentLikeController, bool> createElement() {
    return _CommentLikeControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CommentLikeControllerProvider &&
        other.commentId == commentId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, commentId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CommentLikeControllerRef on NotifierProviderRef<bool> {
  /// The parameter `commentId` of this provider.
  String? get commentId;
}

class _CommentLikeControllerProviderElement
    extends NotifierProviderElement<CommentLikeController, bool>
    with CommentLikeControllerRef {
  _CommentLikeControllerProviderElement(super.provider);

  @override
  String? get commentId => (origin as CommentLikeControllerProvider).commentId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
