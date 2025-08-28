// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchTransactionsHash() => r'ef21aea3996708f0c3cea03b6cb45b8dbe9a8e6d';

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

/// See also [fetchTransactions].
@ProviderFor(fetchTransactions)
const fetchTransactionsProvider = FetchTransactionsFamily();

/// See also [fetchTransactions].
class FetchTransactionsFamily
    extends Family<AsyncValue<List<TransactionModel>>> {
  /// See also [fetchTransactions].
  const FetchTransactionsFamily();

  /// See also [fetchTransactions].
  FetchTransactionsProvider call({
    String? type,
    String? method,
    String? userId,
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    return FetchTransactionsProvider(
      type: type,
      method: method,
      userId: userId,
      fromDate: fromDate,
      toDate: toDate,
    );
  }

  @override
  FetchTransactionsProvider getProviderOverride(
    covariant FetchTransactionsProvider provider,
  ) {
    return call(
      type: provider.type,
      method: provider.method,
      userId: provider.userId,
      fromDate: provider.fromDate,
      toDate: provider.toDate,
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
  String? get name => r'fetchTransactionsProvider';
}

/// See also [fetchTransactions].
class FetchTransactionsProvider
    extends AutoDisposeFutureProvider<List<TransactionModel>> {
  /// See also [fetchTransactions].
  FetchTransactionsProvider({
    String? type,
    String? method,
    String? userId,
    DateTime? fromDate,
    DateTime? toDate,
  }) : this._internal(
          (ref) => fetchTransactions(
            ref as FetchTransactionsRef,
            type: type,
            method: method,
            userId: userId,
            fromDate: fromDate,
            toDate: toDate,
          ),
          from: fetchTransactionsProvider,
          name: r'fetchTransactionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchTransactionsHash,
          dependencies: FetchTransactionsFamily._dependencies,
          allTransitiveDependencies:
              FetchTransactionsFamily._allTransitiveDependencies,
          type: type,
          method: method,
          userId: userId,
          fromDate: fromDate,
          toDate: toDate,
        );

  FetchTransactionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
    required this.method,
    required this.userId,
    required this.fromDate,
    required this.toDate,
  }) : super.internal();

  final String? type;
  final String? method;
  final String? userId;
  final DateTime? fromDate;
  final DateTime? toDate;

  @override
  Override overrideWith(
    FutureOr<List<TransactionModel>> Function(FetchTransactionsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchTransactionsProvider._internal(
        (ref) => create(ref as FetchTransactionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
        method: method,
        userId: userId,
        fromDate: fromDate,
        toDate: toDate,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<TransactionModel>> createElement() {
    return _FetchTransactionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchTransactionsProvider &&
        other.type == type &&
        other.method == method &&
        other.userId == userId &&
        other.fromDate == fromDate &&
        other.toDate == toDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);
    hash = _SystemHash.combine(hash, method.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);
    hash = _SystemHash.combine(hash, fromDate.hashCode);
    hash = _SystemHash.combine(hash, toDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchTransactionsRef
    on AutoDisposeFutureProviderRef<List<TransactionModel>> {
  /// The parameter `type` of this provider.
  String? get type;

  /// The parameter `method` of this provider.
  String? get method;

  /// The parameter `userId` of this provider.
  String? get userId;

  /// The parameter `fromDate` of this provider.
  DateTime? get fromDate;

  /// The parameter `toDate` of this provider.
  DateTime? get toDate;
}

class _FetchTransactionsProviderElement
    extends AutoDisposeFutureProviderElement<List<TransactionModel>>
    with FetchTransactionsRef {
  _FetchTransactionsProviderElement(super.provider);

  @override
  String? get type => (origin as FetchTransactionsProvider).type;
  @override
  String? get method => (origin as FetchTransactionsProvider).method;
  @override
  String? get userId => (origin as FetchTransactionsProvider).userId;
  @override
  DateTime? get fromDate => (origin as FetchTransactionsProvider).fromDate;
  @override
  DateTime? get toDate => (origin as FetchTransactionsProvider).toDate;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
