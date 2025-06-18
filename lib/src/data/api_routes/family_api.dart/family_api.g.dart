// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchAllFamilyHash() => r'1b5b14717eb310bd5952b8e759a99e7bc57d1ba0';

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

/// See also [fetchAllFamily].
@ProviderFor(fetchAllFamily)
const fetchAllFamilyProvider = FetchAllFamilyFamily();

/// See also [fetchAllFamily].
class FetchAllFamilyFamily extends Family<AsyncValue<List<FamilyModel>>> {
  /// See also [fetchAllFamily].
  const FetchAllFamilyFamily();

  /// See also [fetchAllFamily].
  FetchAllFamilyProvider call({
    required String? chapterId,
  }) {
    return FetchAllFamilyProvider(
      chapterId: chapterId,
    );
  }

  @override
  FetchAllFamilyProvider getProviderOverride(
    covariant FetchAllFamilyProvider provider,
  ) {
    return call(
      chapterId: provider.chapterId,
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
  String? get name => r'fetchAllFamilyProvider';
}

/// See also [fetchAllFamily].
class FetchAllFamilyProvider
    extends AutoDisposeFutureProvider<List<FamilyModel>> {
  /// See also [fetchAllFamily].
  FetchAllFamilyProvider({
    required String? chapterId,
  }) : this._internal(
          (ref) => fetchAllFamily(
            ref as FetchAllFamilyRef,
            chapterId: chapterId,
          ),
          from: fetchAllFamilyProvider,
          name: r'fetchAllFamilyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchAllFamilyHash,
          dependencies: FetchAllFamilyFamily._dependencies,
          allTransitiveDependencies:
              FetchAllFamilyFamily._allTransitiveDependencies,
          chapterId: chapterId,
        );

  FetchAllFamilyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chapterId,
  }) : super.internal();

  final String? chapterId;

  @override
  Override overrideWith(
    FutureOr<List<FamilyModel>> Function(FetchAllFamilyRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchAllFamilyProvider._internal(
        (ref) => create(ref as FetchAllFamilyRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chapterId: chapterId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<FamilyModel>> createElement() {
    return _FetchAllFamilyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchAllFamilyProvider && other.chapterId == chapterId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chapterId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchAllFamilyRef on AutoDisposeFutureProviderRef<List<FamilyModel>> {
  /// The parameter `chapterId` of this provider.
  String? get chapterId;
}

class _FetchAllFamilyProviderElement
    extends AutoDisposeFutureProviderElement<List<FamilyModel>>
    with FetchAllFamilyRef {
  _FetchAllFamilyProviderElement(super.provider);

  @override
  String? get chapterId => (origin as FetchAllFamilyProvider).chapterId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
