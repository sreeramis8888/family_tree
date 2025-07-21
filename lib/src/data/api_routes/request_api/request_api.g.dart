// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchRequestWithPersonAndRelationshipsHash() =>
    r'e27d0d37828eeac544853bd194ce948372caeab0';

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

/// See also [fetchRequestWithPersonAndRelationships].
@ProviderFor(fetchRequestWithPersonAndRelationships)
const fetchRequestWithPersonAndRelationshipsProvider =
    FetchRequestWithPersonAndRelationshipsFamily();

/// See also [fetchRequestWithPersonAndRelationships].
class FetchRequestWithPersonAndRelationshipsFamily
    extends Family<AsyncValue<RequestWithPerson>> {
  /// See also [fetchRequestWithPersonAndRelationships].
  const FetchRequestWithPersonAndRelationshipsFamily();

  /// See also [fetchRequestWithPersonAndRelationships].
  FetchRequestWithPersonAndRelationshipsProvider call(
    String requestId,
  ) {
    return FetchRequestWithPersonAndRelationshipsProvider(
      requestId,
    );
  }

  @override
  FetchRequestWithPersonAndRelationshipsProvider getProviderOverride(
    covariant FetchRequestWithPersonAndRelationshipsProvider provider,
  ) {
    return call(
      provider.requestId,
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
  String? get name => r'fetchRequestWithPersonAndRelationshipsProvider';
}

/// See also [fetchRequestWithPersonAndRelationships].
class FetchRequestWithPersonAndRelationshipsProvider
    extends AutoDisposeFutureProvider<RequestWithPerson> {
  /// See also [fetchRequestWithPersonAndRelationships].
  FetchRequestWithPersonAndRelationshipsProvider(
    String requestId,
  ) : this._internal(
          (ref) => fetchRequestWithPersonAndRelationships(
            ref as FetchRequestWithPersonAndRelationshipsRef,
            requestId,
          ),
          from: fetchRequestWithPersonAndRelationshipsProvider,
          name: r'fetchRequestWithPersonAndRelationshipsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchRequestWithPersonAndRelationshipsHash,
          dependencies:
              FetchRequestWithPersonAndRelationshipsFamily._dependencies,
          allTransitiveDependencies:
              FetchRequestWithPersonAndRelationshipsFamily
                  ._allTransitiveDependencies,
          requestId: requestId,
        );

  FetchRequestWithPersonAndRelationshipsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.requestId,
  }) : super.internal();

  final String requestId;

  @override
  Override overrideWith(
    FutureOr<RequestWithPerson> Function(
            FetchRequestWithPersonAndRelationshipsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchRequestWithPersonAndRelationshipsProvider._internal(
        (ref) => create(ref as FetchRequestWithPersonAndRelationshipsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        requestId: requestId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<RequestWithPerson> createElement() {
    return _FetchRequestWithPersonAndRelationshipsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchRequestWithPersonAndRelationshipsProvider &&
        other.requestId == requestId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, requestId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchRequestWithPersonAndRelationshipsRef
    on AutoDisposeFutureProviderRef<RequestWithPerson> {
  /// The parameter `requestId` of this provider.
  String get requestId;
}

class _FetchRequestWithPersonAndRelationshipsProviderElement
    extends AutoDisposeFutureProviderElement<RequestWithPerson>
    with FetchRequestWithPersonAndRelationshipsRef {
  _FetchRequestWithPersonAndRelationshipsProviderElement(super.provider);

  @override
  String get requestId =>
      (origin as FetchRequestWithPersonAndRelationshipsProvider).requestId;
}

String _$fetchAllMembershipRequestsHash() =>
    r'd9159619da83b92bacac810f72079bbb8c23ebab';

/// See also [fetchAllMembershipRequests].
@ProviderFor(fetchAllMembershipRequests)
final fetchAllMembershipRequestsProvider =
    AutoDisposeFutureProvider<List<RequestModel>>.internal(
  fetchAllMembershipRequests,
  name: r'fetchAllMembershipRequestsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fetchAllMembershipRequestsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FetchAllMembershipRequestsRef
    = AutoDisposeFutureProviderRef<List<RequestModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
