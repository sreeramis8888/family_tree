// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relationship_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchRelationshipsHash() =>
    r'5f9af18fa6321f41c089d80af74179c7aeedeec3';

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

/// See also [fetchRelationships].
@ProviderFor(fetchRelationships)
const fetchRelationshipsProvider = FetchRelationshipsFamily();

/// See also [fetchRelationships].
class FetchRelationshipsFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// See also [fetchRelationships].
  const FetchRelationshipsFamily();

  /// See also [fetchRelationships].
  FetchRelationshipsProvider call(
    String personId,
  ) {
    return FetchRelationshipsProvider(
      personId,
    );
  }

  @override
  FetchRelationshipsProvider getProviderOverride(
    covariant FetchRelationshipsProvider provider,
  ) {
    return call(
      provider.personId,
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
  String? get name => r'fetchRelationshipsProvider';
}

/// See also [fetchRelationships].
class FetchRelationshipsProvider
    extends AutoDisposeFutureProvider<List<Map<String, dynamic>>> {
  /// See also [fetchRelationships].
  FetchRelationshipsProvider(
    String personId,
  ) : this._internal(
          (ref) => fetchRelationships(
            ref as FetchRelationshipsRef,
            personId,
          ),
          from: fetchRelationshipsProvider,
          name: r'fetchRelationshipsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchRelationshipsHash,
          dependencies: FetchRelationshipsFamily._dependencies,
          allTransitiveDependencies:
              FetchRelationshipsFamily._allTransitiveDependencies,
          personId: personId,
        );

  FetchRelationshipsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.personId,
  }) : super.internal();

  final String personId;

  @override
  Override overrideWith(
    FutureOr<List<Map<String, dynamic>>> Function(
            FetchRelationshipsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchRelationshipsProvider._internal(
        (ref) => create(ref as FetchRelationshipsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        personId: personId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Map<String, dynamic>>> createElement() {
    return _FetchRelationshipsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchRelationshipsProvider && other.personId == personId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, personId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchRelationshipsRef
    on AutoDisposeFutureProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `personId` of this provider.
  String get personId;
}

class _FetchRelationshipsProviderElement
    extends AutoDisposeFutureProviderElement<List<Map<String, dynamic>>>
    with FetchRelationshipsRef {
  _FetchRelationshipsProviderElement(super.provider);

  @override
  String get personId => (origin as FetchRelationshipsProvider).personId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
