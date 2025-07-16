// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getSingleNotificationByIdHash() =>
    r'386c7cdbca9ad84481e7251cf0b2cba273d12fba';

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

/// ✅ Get a single notification by ID (uses `.family`)
///
/// Copied from [getSingleNotificationById].
@ProviderFor(getSingleNotificationById)
const getSingleNotificationByIdProvider = GetSingleNotificationByIdFamily();

/// ✅ Get a single notification by ID (uses `.family`)
///
/// Copied from [getSingleNotificationById].
class GetSingleNotificationByIdFamily
    extends Family<AsyncValue<NotificationWithPerson>> {
  /// ✅ Get a single notification by ID (uses `.family`)
  ///
  /// Copied from [getSingleNotificationById].
  const GetSingleNotificationByIdFamily();

  /// ✅ Get a single notification by ID (uses `.family`)
  ///
  /// Copied from [getSingleNotificationById].
  GetSingleNotificationByIdProvider call(
    String notificationId,
  ) {
    return GetSingleNotificationByIdProvider(
      notificationId,
    );
  }

  @override
  GetSingleNotificationByIdProvider getProviderOverride(
    covariant GetSingleNotificationByIdProvider provider,
  ) {
    return call(
      provider.notificationId,
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
  String? get name => r'getSingleNotificationByIdProvider';
}

/// ✅ Get a single notification by ID (uses `.family`)
///
/// Copied from [getSingleNotificationById].
class GetSingleNotificationByIdProvider
    extends AutoDisposeFutureProvider<NotificationWithPerson> {
  /// ✅ Get a single notification by ID (uses `.family`)
  ///
  /// Copied from [getSingleNotificationById].
  GetSingleNotificationByIdProvider(
    String notificationId,
  ) : this._internal(
          (ref) => getSingleNotificationById(
            ref as GetSingleNotificationByIdRef,
            notificationId,
          ),
          from: getSingleNotificationByIdProvider,
          name: r'getSingleNotificationByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getSingleNotificationByIdHash,
          dependencies: GetSingleNotificationByIdFamily._dependencies,
          allTransitiveDependencies:
              GetSingleNotificationByIdFamily._allTransitiveDependencies,
          notificationId: notificationId,
        );

  GetSingleNotificationByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.notificationId,
  }) : super.internal();

  final String notificationId;

  @override
  Override overrideWith(
    FutureOr<NotificationWithPerson> Function(
            GetSingleNotificationByIdRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetSingleNotificationByIdProvider._internal(
        (ref) => create(ref as GetSingleNotificationByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        notificationId: notificationId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<NotificationWithPerson> createElement() {
    return _GetSingleNotificationByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetSingleNotificationByIdProvider &&
        other.notificationId == notificationId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, notificationId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetSingleNotificationByIdRef
    on AutoDisposeFutureProviderRef<NotificationWithPerson> {
  /// The parameter `notificationId` of this provider.
  String get notificationId;
}

class _GetSingleNotificationByIdProviderElement
    extends AutoDisposeFutureProviderElement<NotificationWithPerson>
    with GetSingleNotificationByIdRef {
  _GetSingleNotificationByIdProviderElement(super.provider);

  @override
  String get notificationId =>
      (origin as GetSingleNotificationByIdProvider).notificationId;
}

String _$filteredNotificationsHash() =>
    r'75ae9be0e40854d03dc733f8a09148d33d7be506';

/// ✅ Fetch filtered notifications by family admin memberIds
///
/// Copied from [filteredNotifications].
@ProviderFor(filteredNotifications)
const filteredNotificationsProvider = FilteredNotificationsFamily();

/// ✅ Fetch filtered notifications by family admin memberIds
///
/// Copied from [filteredNotifications].
class FilteredNotificationsFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// ✅ Fetch filtered notifications by family admin memberIds
  ///
  /// Copied from [filteredNotifications].
  const FilteredNotificationsFamily();

  /// ✅ Fetch filtered notifications by family admin memberIds
  ///
  /// Copied from [filteredNotifications].
  FilteredNotificationsProvider call(
    List<String> memberIds,
  ) {
    return FilteredNotificationsProvider(
      memberIds,
    );
  }

  @override
  FilteredNotificationsProvider getProviderOverride(
    covariant FilteredNotificationsProvider provider,
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
  String? get name => r'filteredNotificationsProvider';
}

/// ✅ Fetch filtered notifications by family admin memberIds
///
/// Copied from [filteredNotifications].
class FilteredNotificationsProvider
    extends AutoDisposeFutureProvider<List<Map<String, dynamic>>> {
  /// ✅ Fetch filtered notifications by family admin memberIds
  ///
  /// Copied from [filteredNotifications].
  FilteredNotificationsProvider(
    List<String> memberIds,
  ) : this._internal(
          (ref) => filteredNotifications(
            ref as FilteredNotificationsRef,
            memberIds,
          ),
          from: filteredNotificationsProvider,
          name: r'filteredNotificationsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$filteredNotificationsHash,
          dependencies: FilteredNotificationsFamily._dependencies,
          allTransitiveDependencies:
              FilteredNotificationsFamily._allTransitiveDependencies,
          memberIds: memberIds,
        );

  FilteredNotificationsProvider._internal(
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
    FutureOr<List<Map<String, dynamic>>> Function(
            FilteredNotificationsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FilteredNotificationsProvider._internal(
        (ref) => create(ref as FilteredNotificationsRef),
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
    return _FilteredNotificationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredNotificationsProvider &&
        other.memberIds == memberIds;
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
mixin FilteredNotificationsRef
    on AutoDisposeFutureProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `memberIds` of this provider.
  List<String> get memberIds;
}

class _FilteredNotificationsProviderElement
    extends AutoDisposeFutureProviderElement<List<Map<String, dynamic>>>
    with FilteredNotificationsRef {
  _FilteredNotificationsProviderElement(super.provider);

  @override
  List<String> get memberIds =>
      (origin as FilteredNotificationsProvider).memberIds;
}

String _$fetchNotificationsHash() =>
    r'2208ca83815ca18f102f171da80d3651db287c21';

/// ✅ Fetch all user notifications
///
/// Copied from [fetchNotifications].
@ProviderFor(fetchNotifications)
final fetchNotificationsProvider =
    AutoDisposeFutureProvider<List<NotificationModel>>.internal(
  fetchNotifications,
  name: r'fetchNotificationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fetchNotificationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FetchNotificationsRef
    = AutoDisposeFutureProviderRef<List<NotificationModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
