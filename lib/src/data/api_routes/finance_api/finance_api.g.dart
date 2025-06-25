// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getMinimumBalanceHash() => r'e910dfd7e5813445b4a35c0394a336753e136245';

/// See also [getMinimumBalance].
@ProviderFor(getMinimumBalance)
final getMinimumBalanceProvider =
    AutoDisposeFutureProvider<MinimumBalance?>.internal(
  getMinimumBalance,
  name: r'getMinimumBalanceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getMinimumBalanceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetMinimumBalanceRef = AutoDisposeFutureProviderRef<MinimumBalance?>;
String _$getProgramMemberByIdHash() =>
    r'd0b33cb451defb80c6831494314e729964916680';

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

/// See also [getProgramMemberById].
@ProviderFor(getProgramMemberById)
const getProgramMemberByIdProvider = GetProgramMemberByIdFamily();

/// See also [getProgramMemberById].
class GetProgramMemberByIdFamily
    extends Family<AsyncValue<FinancialAssistance?>> {
  /// See also [getProgramMemberById].
  const GetProgramMemberByIdFamily();

  /// See also [getProgramMemberById].
  GetProgramMemberByIdProvider call(
    String id,
  ) {
    return GetProgramMemberByIdProvider(
      id,
    );
  }

  @override
  GetProgramMemberByIdProvider getProviderOverride(
    covariant GetProgramMemberByIdProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'getProgramMemberByIdProvider';
}

/// See also [getProgramMemberById].
class GetProgramMemberByIdProvider
    extends AutoDisposeFutureProvider<FinancialAssistance?> {
  /// See also [getProgramMemberById].
  GetProgramMemberByIdProvider(
    String id,
  ) : this._internal(
          (ref) => getProgramMemberById(
            ref as GetProgramMemberByIdRef,
            id,
          ),
          from: getProgramMemberByIdProvider,
          name: r'getProgramMemberByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getProgramMemberByIdHash,
          dependencies: GetProgramMemberByIdFamily._dependencies,
          allTransitiveDependencies:
              GetProgramMemberByIdFamily._allTransitiveDependencies,
          id: id,
        );

  GetProgramMemberByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<FinancialAssistance?> Function(GetProgramMemberByIdRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetProgramMemberByIdProvider._internal(
        (ref) => create(ref as GetProgramMemberByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<FinancialAssistance?> createElement() {
    return _GetProgramMemberByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetProgramMemberByIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetProgramMemberByIdRef
    on AutoDisposeFutureProviderRef<FinancialAssistance?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _GetProgramMemberByIdProviderElement
    extends AutoDisposeFutureProviderElement<FinancialAssistance?>
    with GetProgramMemberByIdRef {
  _GetProgramMemberByIdProviderElement(super.provider);

  @override
  String get id => (origin as GetProgramMemberByIdProvider).id;
}

String _$getAllProgramMembersHash() =>
    r'81042085dad0e35b55c4bdd32bba65b5523af5ed';

/// See also [getAllProgramMembers].
@ProviderFor(getAllProgramMembers)
const getAllProgramMembersProvider = GetAllProgramMembersFamily();

/// See also [getAllProgramMembers].
class GetAllProgramMembersFamily
    extends Family<AsyncValue<List<FinancialAssistance>>> {
  /// See also [getAllProgramMembers].
  const GetAllProgramMembersFamily();

  /// See also [getAllProgramMembers].
  GetAllProgramMembersProvider call({
    int page = 1,
    int limit = 20,
    String? membershipStatus,
    String sortBy = 'createdAt',
    String sortOrder = 'desc',
  }) {
    return GetAllProgramMembersProvider(
      page: page,
      limit: limit,
      membershipStatus: membershipStatus,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
  }

  @override
  GetAllProgramMembersProvider getProviderOverride(
    covariant GetAllProgramMembersProvider provider,
  ) {
    return call(
      page: provider.page,
      limit: provider.limit,
      membershipStatus: provider.membershipStatus,
      sortBy: provider.sortBy,
      sortOrder: provider.sortOrder,
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
  String? get name => r'getAllProgramMembersProvider';
}

/// See also [getAllProgramMembers].
class GetAllProgramMembersProvider
    extends AutoDisposeFutureProvider<List<FinancialAssistance>> {
  /// See also [getAllProgramMembers].
  GetAllProgramMembersProvider({
    int page = 1,
    int limit = 20,
    String? membershipStatus,
    String sortBy = 'createdAt',
    String sortOrder = 'desc',
  }) : this._internal(
          (ref) => getAllProgramMembers(
            ref as GetAllProgramMembersRef,
            page: page,
            limit: limit,
            membershipStatus: membershipStatus,
            sortBy: sortBy,
            sortOrder: sortOrder,
          ),
          from: getAllProgramMembersProvider,
          name: r'getAllProgramMembersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getAllProgramMembersHash,
          dependencies: GetAllProgramMembersFamily._dependencies,
          allTransitiveDependencies:
              GetAllProgramMembersFamily._allTransitiveDependencies,
          page: page,
          limit: limit,
          membershipStatus: membershipStatus,
          sortBy: sortBy,
          sortOrder: sortOrder,
        );

  GetAllProgramMembersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.page,
    required this.limit,
    required this.membershipStatus,
    required this.sortBy,
    required this.sortOrder,
  }) : super.internal();

  final int page;
  final int limit;
  final String? membershipStatus;
  final String sortBy;
  final String sortOrder;

  @override
  Override overrideWith(
    FutureOr<List<FinancialAssistance>> Function(
            GetAllProgramMembersRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetAllProgramMembersProvider._internal(
        (ref) => create(ref as GetAllProgramMembersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        page: page,
        limit: limit,
        membershipStatus: membershipStatus,
        sortBy: sortBy,
        sortOrder: sortOrder,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<FinancialAssistance>> createElement() {
    return _GetAllProgramMembersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetAllProgramMembersProvider &&
        other.page == page &&
        other.limit == limit &&
        other.membershipStatus == membershipStatus &&
        other.sortBy == sortBy &&
        other.sortOrder == sortOrder;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);
    hash = _SystemHash.combine(hash, membershipStatus.hashCode);
    hash = _SystemHash.combine(hash, sortBy.hashCode);
    hash = _SystemHash.combine(hash, sortOrder.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetAllProgramMembersRef
    on AutoDisposeFutureProviderRef<List<FinancialAssistance>> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `limit` of this provider.
  int get limit;

  /// The parameter `membershipStatus` of this provider.
  String? get membershipStatus;

  /// The parameter `sortBy` of this provider.
  String get sortBy;

  /// The parameter `sortOrder` of this provider.
  String get sortOrder;
}

class _GetAllProgramMembersProviderElement
    extends AutoDisposeFutureProviderElement<List<FinancialAssistance>>
    with GetAllProgramMembersRef {
  _GetAllProgramMembersProviderElement(super.provider);

  @override
  int get page => (origin as GetAllProgramMembersProvider).page;
  @override
  int get limit => (origin as GetAllProgramMembersProvider).limit;
  @override
  String? get membershipStatus =>
      (origin as GetAllProgramMembersProvider).membershipStatus;
  @override
  String get sortBy => (origin as GetAllProgramMembersProvider).sortBy;
  @override
  String get sortOrder => (origin as GetAllProgramMembersProvider).sortOrder;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
