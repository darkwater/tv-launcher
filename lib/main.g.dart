// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$directoryContentsHash() => r'5d3bddb9bfebac0031843c69e08f893954f6a72c';

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

/// See also [directoryContents].
@ProviderFor(directoryContents)
const directoryContentsProvider = DirectoryContentsFamily();

/// See also [directoryContents].
class DirectoryContentsFamily extends Family<List<DirEntry>> {
  /// See also [directoryContents].
  const DirectoryContentsFamily();

  /// See also [directoryContents].
  DirectoryContentsProvider call(String path) {
    return DirectoryContentsProvider(path);
  }

  @override
  DirectoryContentsProvider getProviderOverride(
    covariant DirectoryContentsProvider provider,
  ) {
    return call(provider.path);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'directoryContentsProvider';
}

/// See also [directoryContents].
class DirectoryContentsProvider extends AutoDisposeProvider<List<DirEntry>> {
  /// See also [directoryContents].
  DirectoryContentsProvider(String path)
    : this._internal(
        (ref) => directoryContents(ref as DirectoryContentsRef, path),
        from: directoryContentsProvider,
        name: r'directoryContentsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$directoryContentsHash,
        dependencies: DirectoryContentsFamily._dependencies,
        allTransitiveDependencies:
            DirectoryContentsFamily._allTransitiveDependencies,
        path: path,
      );

  DirectoryContentsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.path,
  }) : super.internal();

  final String path;

  @override
  Override overrideWith(
    List<DirEntry> Function(DirectoryContentsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DirectoryContentsProvider._internal(
        (ref) => create(ref as DirectoryContentsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        path: path,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<DirEntry>> createElement() {
    return _DirectoryContentsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DirectoryContentsProvider && other.path == path;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, path.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DirectoryContentsRef on AutoDisposeProviderRef<List<DirEntry>> {
  /// The parameter `path` of this provider.
  String get path;
}

class _DirectoryContentsProviderElement
    extends AutoDisposeProviderElement<List<DirEntry>>
    with DirectoryContentsRef {
  _DirectoryContentsProviderElement(super.provider);

  @override
  String get path => (origin as DirectoryContentsProvider).path;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
