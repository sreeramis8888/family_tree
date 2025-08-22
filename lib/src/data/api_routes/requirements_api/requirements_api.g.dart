// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'requirements_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredFeedsHash() => r'bab39d6391c444ea8515474d9de061dff162ab47';

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

/// See also [filteredFeeds].
@ProviderFor(filteredFeeds)
const filteredFeedsProvider = FilteredFeedsFamily();

/// See also [filteredFeeds].
class FilteredFeedsFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// See also [filteredFeeds].
  const FilteredFeedsFamily();

  /// See also [filteredFeeds].
  FilteredFeedsProvider call(
    List<String> memberIds,
  ) {
    return FilteredFeedsProvider(
      memberIds,
    );
  }

  @override
  FilteredFeedsProvider getProviderOverride(
    covariant FilteredFeedsProvider provider,
  ) {
    return call(
      provider.memberIds,
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
  String? get name => r'filteredFeedsProvider';
}

/// See also [filteredFeeds].
class FilteredFeedsProvider
    extends AutoDisposeFutureProvider<List<Map<String, dynamic>>> {
  /// See also [filteredFeeds].
  FilteredFeedsProvider(
    List<String> memberIds,
  ) : this._internal(
          (ref) => filteredFeeds(
            ref as FilteredFeedsRef,
            memberIds,
          ),
          from: filteredFeedsProvider,
          name: r'filteredFeedsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$filteredFeedsHash,
          dependencies: FilteredFeedsFamily._dependencies,
          allTransitiveDependencies:
              FilteredFeedsFamily._allTransitiveDependencies,
          memberIds: memberIds,
        );

  FilteredFeedsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.memberIds,
  }) : super.internal();

  final List<String> memberIds;

  @override
  Override overrideWith(
    FutureOr<List<Map<String, dynamic>>> Function(FilteredFeedsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FilteredFeedsProvider._internal(
        (ref) => create(ref as FilteredFeedsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        memberIds: memberIds,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Map<String, dynamic>>> createElement() {
    return _FilteredFeedsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredFeedsProvider && other.memberIds == memberIds;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, memberIds.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FilteredFeedsRef
    on AutoDisposeFutureProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `memberIds` of this provider.
  List<String> get memberIds;
}

class _FilteredFeedsProviderElement
    extends AutoDisposeFutureProviderElement<List<Map<String, dynamic>>>
    with FilteredFeedsRef {
  _FilteredFeedsProviderElement(super.provider);

  @override
  List<String> get memberIds => (origin as FilteredFeedsProvider).memberIds;
}

String _$fetchBusinessHash() => r'5204abaa072b373b3752dbad2e58344e99130f2a';

/// See also [fetchBusiness].
@ProviderFor(fetchBusiness)
const fetchBusinessProvider = FetchBusinessFamily();

/// See also [fetchBusiness].
class FetchBusinessFamily extends Family<AsyncValue<List<Business>>> {
  /// See also [fetchBusiness].
  const FetchBusinessFamily();

  /// See also [fetchBusiness].
  FetchBusinessProvider call({
    int pageNo = 1,
    int limit = 10,
  }) {
    return FetchBusinessProvider(
      pageNo: pageNo,
      limit: limit,
    );
  }

  @override
  FetchBusinessProvider getProviderOverride(
    covariant FetchBusinessProvider provider,
  ) {
    return call(
      pageNo: provider.pageNo,
      limit: provider.limit,
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
  String? get name => r'fetchBusinessProvider';
}

/// See also [fetchBusiness].
class FetchBusinessProvider extends AutoDisposeFutureProvider<List<Business>> {
  /// See also [fetchBusiness].
  FetchBusinessProvider({
    int pageNo = 1,
    int limit = 10,
  }) : this._internal(
          (ref) => fetchBusiness(
            ref as FetchBusinessRef,
            pageNo: pageNo,
            limit: limit,
          ),
          from: fetchBusinessProvider,
          name: r'fetchBusinessProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchBusinessHash,
          dependencies: FetchBusinessFamily._dependencies,
          allTransitiveDependencies:
              FetchBusinessFamily._allTransitiveDependencies,
          pageNo: pageNo,
          limit: limit,
        );

  FetchBusinessProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pageNo,
    required this.limit,
  }) : super.internal();

  final int pageNo;
  final int limit;

  @override
  Override overrideWith(
    FutureOr<List<Business>> Function(FetchBusinessRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchBusinessProvider._internal(
        (ref) => create(ref as FetchBusinessRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pageNo: pageNo,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Business>> createElement() {
    return _FetchBusinessProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchBusinessProvider &&
        other.pageNo == pageNo &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pageNo.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchBusinessRef on AutoDisposeFutureProviderRef<List<Business>> {
  /// The parameter `pageNo` of this provider.
  int get pageNo;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _FetchBusinessProviderElement
    extends AutoDisposeFutureProviderElement<List<Business>>
    with FetchBusinessRef {
  _FetchBusinessProviderElement(super.provider);

  @override
  int get pageNo => (origin as FetchBusinessProvider).pageNo;
  @override
  int get limit => (origin as FetchBusinessProvider).limit;
}

String _$fetchMyBusinessesHash() => r'3921cded82ffdc61e8753d3f23fc8d8a257320b6';

/// See also [fetchMyBusinesses].
@ProviderFor(fetchMyBusinesses)
final fetchMyBusinessesProvider =
    AutoDisposeFutureProvider<List<Business>>.internal(
  fetchMyBusinesses,
  name: r'fetchMyBusinessesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fetchMyBusinessesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FetchMyBusinessesRef = AutoDisposeFutureProviderRef<List<Business>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
