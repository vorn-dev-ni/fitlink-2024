// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$commentControllerHash() => r'3724d57982c9e9f233433d202d1bd14409118556';

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

abstract class _$CommentController
    extends BuildlessAutoDisposeStreamNotifier<List<Comment>?> {
  late final String? parentId;

  Stream<List<Comment>?> build(
    String? parentId,
  );
}

/// See also [CommentController].
@ProviderFor(CommentController)
const commentControllerProvider = CommentControllerFamily();

/// See also [CommentController].
class CommentControllerFamily extends Family<AsyncValue<List<Comment>?>> {
  /// See also [CommentController].
  const CommentControllerFamily();

  /// See also [CommentController].
  CommentControllerProvider call(
    String? parentId,
  ) {
    return CommentControllerProvider(
      parentId,
    );
  }

  @override
  CommentControllerProvider getProviderOverride(
    covariant CommentControllerProvider provider,
  ) {
    return call(
      provider.parentId,
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
  String? get name => r'commentControllerProvider';
}

/// See also [CommentController].
class CommentControllerProvider extends AutoDisposeStreamNotifierProviderImpl<
    CommentController, List<Comment>?> {
  /// See also [CommentController].
  CommentControllerProvider(
    String? parentId,
  ) : this._internal(
          () => CommentController()..parentId = parentId,
          from: commentControllerProvider,
          name: r'commentControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$commentControllerHash,
          dependencies: CommentControllerFamily._dependencies,
          allTransitiveDependencies:
              CommentControllerFamily._allTransitiveDependencies,
          parentId: parentId,
        );

  CommentControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.parentId,
  }) : super.internal();

  final String? parentId;

  @override
  Stream<List<Comment>?> runNotifierBuild(
    covariant CommentController notifier,
  ) {
    return notifier.build(
      parentId,
    );
  }

  @override
  Override overrideWith(CommentController Function() create) {
    return ProviderOverride(
      origin: this,
      override: CommentControllerProvider._internal(
        () => create()..parentId = parentId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        parentId: parentId,
      ),
    );
  }

  @override
  AutoDisposeStreamNotifierProviderElement<CommentController, List<Comment>?>
      createElement() {
    return _CommentControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CommentControllerProvider && other.parentId == parentId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, parentId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CommentControllerRef
    on AutoDisposeStreamNotifierProviderRef<List<Comment>?> {
  /// The parameter `parentId` of this provider.
  String? get parentId;
}

class _CommentControllerProviderElement
    extends AutoDisposeStreamNotifierProviderElement<CommentController,
        List<Comment>?> with CommentControllerRef {
  _CommentControllerProviderElement(super.provider);

  @override
  String? get parentId => (origin as CommentControllerProvider).parentId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
