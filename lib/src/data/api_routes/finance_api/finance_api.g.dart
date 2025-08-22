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

String _$getAllFlatProgramMembersHash() =>
    r'8c3f7d8aafcd8a958c84c6730337c552e5fb675f';

/// See also [getAllFlatProgramMembers].
@ProviderFor(getAllFlatProgramMembers)
const getAllFlatProgramMembersProvider = GetAllFlatProgramMembersFamily();

/// See also [getAllFlatProgramMembers].
class GetAllFlatProgramMembersFamily
    extends Family<AsyncValue<List<ProgramMember>>> {
  /// See also [getAllFlatProgramMembers].
  const GetAllFlatProgramMembersFamily();

  /// See also [getAllFlatProgramMembers].
  GetAllFlatProgramMembersProvider call({
    int page = 1,
    int limit = 20,
  }) {
    return GetAllFlatProgramMembersProvider(
      page: page,
      limit: limit,
    );
  }

  @override
  GetAllFlatProgramMembersProvider getProviderOverride(
    covariant GetAllFlatProgramMembersProvider provider,
  ) {
    return call(
      page: provider.page,
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
  String? get name => r'getAllFlatProgramMembersProvider';
}

/// See also [getAllFlatProgramMembers].
class GetAllFlatProgramMembersProvider
    extends AutoDisposeFutureProvider<List<ProgramMember>> {
  /// See also [getAllFlatProgramMembers].
  GetAllFlatProgramMembersProvider({
    int page = 1,
    int limit = 20,
  }) : this._internal(
          (ref) => getAllFlatProgramMembers(
            ref as GetAllFlatProgramMembersRef,
            page: page,
            limit: limit,
          ),
          from: getAllFlatProgramMembersProvider,
          name: r'getAllFlatProgramMembersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getAllFlatProgramMembersHash,
          dependencies: GetAllFlatProgramMembersFamily._dependencies,
          allTransitiveDependencies:
              GetAllFlatProgramMembersFamily._allTransitiveDependencies,
          page: page,
          limit: limit,
        );

  GetAllFlatProgramMembersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.page,
    required this.limit,
  }) : super.internal();

  final int page;
  final int limit;

  @override
  Override overrideWith(
    FutureOr<List<ProgramMember>> Function(GetAllFlatProgramMembersRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetAllFlatProgramMembersProvider._internal(
        (ref) => create(ref as GetAllFlatProgramMembersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        page: page,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ProgramMember>> createElement() {
    return _GetAllFlatProgramMembersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetAllFlatProgramMembersProvider &&
        other.page == page &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetAllFlatProgramMembersRef
    on AutoDisposeFutureProviderRef<List<ProgramMember>> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _GetAllFlatProgramMembersProviderElement
    extends AutoDisposeFutureProviderElement<List<ProgramMember>>
    with GetAllFlatProgramMembersRef {
  _GetAllFlatProgramMembersProviderElement(super.provider);

  @override
  int get page => (origin as GetAllFlatProgramMembersProvider).page;
  @override
  int get limit => (origin as GetAllFlatProgramMembersProvider).limit;
}

String _$joinProgramHash() => r'0a7caed9a43aaa862b2e0a218e63c7fa548079cb';

/// See also [joinProgram].
@ProviderFor(joinProgram)
const joinProgramProvider = JoinProgramFamily();

/// See also [joinProgram].
class JoinProgramFamily extends Family<AsyncValue<bool>> {
  /// See also [joinProgram].
  const JoinProgramFamily();

  /// See also [joinProgram].
  JoinProgramProvider call({
    required String memberId,
    String? membershipStatus,
    int? amount,
  }) {
    return JoinProgramProvider(
      memberId: memberId,
      membershipStatus: membershipStatus,
      amount: amount,
    );
  }

  @override
  JoinProgramProvider getProviderOverride(
    covariant JoinProgramProvider provider,
  ) {
    return call(
      memberId: provider.memberId,
      membershipStatus: provider.membershipStatus,
      amount: provider.amount,
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
  String? get name => r'joinProgramProvider';
}

/// See also [joinProgram].
class JoinProgramProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [joinProgram].
  JoinProgramProvider({
    required String memberId,
    String? membershipStatus,
    int? amount,
  }) : this._internal(
          (ref) => joinProgram(
            ref as JoinProgramRef,
            memberId: memberId,
            membershipStatus: membershipStatus,
            amount: amount,
          ),
          from: joinProgramProvider,
          name: r'joinProgramProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$joinProgramHash,
          dependencies: JoinProgramFamily._dependencies,
          allTransitiveDependencies:
              JoinProgramFamily._allTransitiveDependencies,
          memberId: memberId,
          membershipStatus: membershipStatus,
          amount: amount,
        );

  JoinProgramProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.memberId,
    required this.membershipStatus,
    required this.amount,
  }) : super.internal();

  final String memberId;
  final String? membershipStatus;
  final int? amount;

  @override
  Override overrideWith(
    FutureOr<bool> Function(JoinProgramRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: JoinProgramProvider._internal(
        (ref) => create(ref as JoinProgramRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        memberId: memberId,
        membershipStatus: membershipStatus,
        amount: amount,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _JoinProgramProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JoinProgramProvider &&
        other.memberId == memberId &&
        other.membershipStatus == membershipStatus &&
        other.amount == amount;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, memberId.hashCode);
    hash = _SystemHash.combine(hash, membershipStatus.hashCode);
    hash = _SystemHash.combine(hash, amount.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin JoinProgramRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `memberId` of this provider.
  String get memberId;

  /// The parameter `membershipStatus` of this provider.
  String? get membershipStatus;

  /// The parameter `amount` of this provider.
  int? get amount;
}

class _JoinProgramProviderElement extends AutoDisposeFutureProviderElement<bool>
    with JoinProgramRef {
  _JoinProgramProviderElement(super.provider);

  @override
  String get memberId => (origin as JoinProgramProvider).memberId;
  @override
  String? get membershipStatus =>
      (origin as JoinProgramProvider).membershipStatus;
  @override
  int? get amount => (origin as JoinProgramProvider).amount;
}

String _$getAllTransactionsHash() =>
    r'7b9e0edf21b1eea8fd7b8eded3f11e8018f70d82';

/// See also [getAllTransactions].
@ProviderFor(getAllTransactions)
const getAllTransactionsProvider = GetAllTransactionsFamily();

/// See also [getAllTransactions].
class GetAllTransactionsFamily
    extends Family<AsyncValue<List<TransactionModel>>> {
  /// See also [getAllTransactions].
  const GetAllTransactionsFamily();

  /// See also [getAllTransactions].
  GetAllTransactionsProvider call({
    int page = 1,
    int limit = 20,
    String? search,
    String? method,
    String? type,
    String? personId,
    String? startDate,
    String? endDate,
    double? minAmount,
    double? maxAmount,
    String sortBy = 'date',
    String sortOrder = 'desc',
  }) {
    return GetAllTransactionsProvider(
      page: page,
      limit: limit,
      search: search,
      method: method,
      type: type,
      personId: personId,
      startDate: startDate,
      endDate: endDate,
      minAmount: minAmount,
      maxAmount: maxAmount,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
  }

  @override
  GetAllTransactionsProvider getProviderOverride(
    covariant GetAllTransactionsProvider provider,
  ) {
    return call(
      page: provider.page,
      limit: provider.limit,
      search: provider.search,
      method: provider.method,
      type: provider.type,
      personId: provider.personId,
      startDate: provider.startDate,
      endDate: provider.endDate,
      minAmount: provider.minAmount,
      maxAmount: provider.maxAmount,
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
  String? get name => r'getAllTransactionsProvider';
}

/// See also [getAllTransactions].
class GetAllTransactionsProvider
    extends AutoDisposeFutureProvider<List<TransactionModel>> {
  /// See also [getAllTransactions].
  GetAllTransactionsProvider({
    int page = 1,
    int limit = 20,
    String? search,
    String? method,
    String? type,
    String? personId,
    String? startDate,
    String? endDate,
    double? minAmount,
    double? maxAmount,
    String sortBy = 'date',
    String sortOrder = 'desc',
  }) : this._internal(
          (ref) => getAllTransactions(
            ref as GetAllTransactionsRef,
            page: page,
            limit: limit,
            search: search,
            method: method,
            type: type,
            personId: personId,
            startDate: startDate,
            endDate: endDate,
            minAmount: minAmount,
            maxAmount: maxAmount,
            sortBy: sortBy,
            sortOrder: sortOrder,
          ),
          from: getAllTransactionsProvider,
          name: r'getAllTransactionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getAllTransactionsHash,
          dependencies: GetAllTransactionsFamily._dependencies,
          allTransitiveDependencies:
              GetAllTransactionsFamily._allTransitiveDependencies,
          page: page,
          limit: limit,
          search: search,
          method: method,
          type: type,
          personId: personId,
          startDate: startDate,
          endDate: endDate,
          minAmount: minAmount,
          maxAmount: maxAmount,
          sortBy: sortBy,
          sortOrder: sortOrder,
        );

  GetAllTransactionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.page,
    required this.limit,
    required this.search,
    required this.method,
    required this.type,
    required this.personId,
    required this.startDate,
    required this.endDate,
    required this.minAmount,
    required this.maxAmount,
    required this.sortBy,
    required this.sortOrder,
  }) : super.internal();

  final int page;
  final int limit;
  final String? search;
  final String? method;
  final String? type;
  final String? personId;
  final String? startDate;
  final String? endDate;
  final double? minAmount;
  final double? maxAmount;
  final String sortBy;
  final String sortOrder;

  @override
  Override overrideWith(
    FutureOr<List<TransactionModel>> Function(GetAllTransactionsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetAllTransactionsProvider._internal(
        (ref) => create(ref as GetAllTransactionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        page: page,
        limit: limit,
        search: search,
        method: method,
        type: type,
        personId: personId,
        startDate: startDate,
        endDate: endDate,
        minAmount: minAmount,
        maxAmount: maxAmount,
        sortBy: sortBy,
        sortOrder: sortOrder,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<TransactionModel>> createElement() {
    return _GetAllTransactionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetAllTransactionsProvider &&
        other.page == page &&
        other.limit == limit &&
        other.search == search &&
        other.method == method &&
        other.type == type &&
        other.personId == personId &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.minAmount == minAmount &&
        other.maxAmount == maxAmount &&
        other.sortBy == sortBy &&
        other.sortOrder == sortOrder;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);
    hash = _SystemHash.combine(hash, search.hashCode);
    hash = _SystemHash.combine(hash, method.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);
    hash = _SystemHash.combine(hash, personId.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);
    hash = _SystemHash.combine(hash, minAmount.hashCode);
    hash = _SystemHash.combine(hash, maxAmount.hashCode);
    hash = _SystemHash.combine(hash, sortBy.hashCode);
    hash = _SystemHash.combine(hash, sortOrder.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetAllTransactionsRef
    on AutoDisposeFutureProviderRef<List<TransactionModel>> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `limit` of this provider.
  int get limit;

  /// The parameter `search` of this provider.
  String? get search;

  /// The parameter `method` of this provider.
  String? get method;

  /// The parameter `type` of this provider.
  String? get type;

  /// The parameter `personId` of this provider.
  String? get personId;

  /// The parameter `startDate` of this provider.
  String? get startDate;

  /// The parameter `endDate` of this provider.
  String? get endDate;

  /// The parameter `minAmount` of this provider.
  double? get minAmount;

  /// The parameter `maxAmount` of this provider.
  double? get maxAmount;

  /// The parameter `sortBy` of this provider.
  String get sortBy;

  /// The parameter `sortOrder` of this provider.
  String get sortOrder;
}

class _GetAllTransactionsProviderElement
    extends AutoDisposeFutureProviderElement<List<TransactionModel>>
    with GetAllTransactionsRef {
  _GetAllTransactionsProviderElement(super.provider);

  @override
  int get page => (origin as GetAllTransactionsProvider).page;
  @override
  int get limit => (origin as GetAllTransactionsProvider).limit;
  @override
  String? get search => (origin as GetAllTransactionsProvider).search;
  @override
  String? get method => (origin as GetAllTransactionsProvider).method;
  @override
  String? get type => (origin as GetAllTransactionsProvider).type;
  @override
  String? get personId => (origin as GetAllTransactionsProvider).personId;
  @override
  String? get startDate => (origin as GetAllTransactionsProvider).startDate;
  @override
  String? get endDate => (origin as GetAllTransactionsProvider).endDate;
  @override
  double? get minAmount => (origin as GetAllTransactionsProvider).minAmount;
  @override
  double? get maxAmount => (origin as GetAllTransactionsProvider).maxAmount;
  @override
  String get sortBy => (origin as GetAllTransactionsProvider).sortBy;
  @override
  String get sortOrder => (origin as GetAllTransactionsProvider).sortOrder;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
