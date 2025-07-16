// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchAllFamilyHash() => r'455598ddac82952831633906c0343b1f9228cb0b';

/// See also [fetchAllFamily].
@ProviderFor(fetchAllFamily)
final fetchAllFamilyProvider =
    AutoDisposeFutureProvider<List<FamilyModel>>.internal(
  fetchAllFamily,
  name: r'fetchAllFamilyProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fetchAllFamilyHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FetchAllFamilyRef = AutoDisposeFutureProviderRef<List<FamilyModel>>;
String _$fetchSingleFamilyHash() => r'8b52a71708acd5e73279043a183425231d6fd0e3';

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

/// See also [fetchSingleFamily].
@ProviderFor(fetchSingleFamily)
const fetchSingleFamilyProvider = FetchSingleFamilyFamily();

/// See also [fetchSingleFamily].
class FetchSingleFamilyFamily extends Family<AsyncValue<FamilyModel>> {
  /// See also [fetchSingleFamily].
  const FetchSingleFamilyFamily();

  /// See also [fetchSingleFamily].
  FetchSingleFamilyProvider call({
    required String familyId,
  }) {
    return FetchSingleFamilyProvider(
      familyId: familyId,
    );
  }

  @override
  FetchSingleFamilyProvider getProviderOverride(
    covariant FetchSingleFamilyProvider provider,
  ) {
    return call(
      familyId: provider.familyId,
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
  String? get name => r'fetchSingleFamilyProvider';
}

/// See also [fetchSingleFamily].
class FetchSingleFamilyProvider extends AutoDisposeFutureProvider<FamilyModel> {
  /// See also [fetchSingleFamily].
  FetchSingleFamilyProvider({
    required String familyId,
  }) : this._internal(
          (ref) => fetchSingleFamily(
            ref as FetchSingleFamilyRef,
            familyId: familyId,
          ),
          from: fetchSingleFamilyProvider,
          name: r'fetchSingleFamilyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchSingleFamilyHash,
          dependencies: FetchSingleFamilyFamily._dependencies,
          allTransitiveDependencies:
              FetchSingleFamilyFamily._allTransitiveDependencies,
          familyId: familyId,
        );

  FetchSingleFamilyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.familyId,
  }) : super.internal();

  final String familyId;

  @override
  Override overrideWith(
    FutureOr<FamilyModel> Function(FetchSingleFamilyRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchSingleFamilyProvider._internal(
        (ref) => create(ref as FetchSingleFamilyRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        familyId: familyId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<FamilyModel> createElement() {
    return _FetchSingleFamilyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchSingleFamilyProvider && other.familyId == familyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, familyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchSingleFamilyRef on AutoDisposeFutureProviderRef<FamilyModel> {
  /// The parameter `familyId` of this provider.
  String get familyId;
}

class _FetchSingleFamilyProviderElement
    extends AutoDisposeFutureProviderElement<FamilyModel>
    with FetchSingleFamilyRef {
  _FetchSingleFamilyProviderElement(super.provider);

  @override
  String get familyId => (origin as FetchSingleFamilyProvider).familyId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
