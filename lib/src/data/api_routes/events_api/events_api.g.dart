// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchEventWithPersonHash() =>
    r'913f19b833223f32e2867d29966d2ac238fd3078';

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

/// See also [fetchEventWithPerson].
@ProviderFor(fetchEventWithPerson)
const fetchEventWithPersonProvider = FetchEventWithPersonFamily();

/// See also [fetchEventWithPerson].
class FetchEventWithPersonFamily extends Family<AsyncValue<EventWithPerson>> {
  /// See also [fetchEventWithPerson].
  const FetchEventWithPersonFamily();

  /// See also [fetchEventWithPerson].
  FetchEventWithPersonProvider call(
    String eventId,
  ) {
    return FetchEventWithPersonProvider(
      eventId,
    );
  }

  @override
  FetchEventWithPersonProvider getProviderOverride(
    covariant FetchEventWithPersonProvider provider,
  ) {
    return call(
      provider.eventId,
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
  String? get name => r'fetchEventWithPersonProvider';
}

/// See also [fetchEventWithPerson].
class FetchEventWithPersonProvider
    extends AutoDisposeFutureProvider<EventWithPerson> {
  /// See also [fetchEventWithPerson].
  FetchEventWithPersonProvider(
    String eventId,
  ) : this._internal(
          (ref) => fetchEventWithPerson(
            ref as FetchEventWithPersonRef,
            eventId,
          ),
          from: fetchEventWithPersonProvider,
          name: r'fetchEventWithPersonProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchEventWithPersonHash,
          dependencies: FetchEventWithPersonFamily._dependencies,
          allTransitiveDependencies:
              FetchEventWithPersonFamily._allTransitiveDependencies,
          eventId: eventId,
        );

  FetchEventWithPersonProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.eventId,
  }) : super.internal();

  final String eventId;

  @override
  Override overrideWith(
    FutureOr<EventWithPerson> Function(FetchEventWithPersonRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchEventWithPersonProvider._internal(
        (ref) => create(ref as FetchEventWithPersonRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        eventId: eventId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<EventWithPerson> createElement() {
    return _FetchEventWithPersonProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchEventWithPersonProvider && other.eventId == eventId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, eventId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchEventWithPersonRef on AutoDisposeFutureProviderRef<EventWithPerson> {
  /// The parameter `eventId` of this provider.
  String get eventId;
}

class _FetchEventWithPersonProviderElement
    extends AutoDisposeFutureProviderElement<EventWithPerson>
    with FetchEventWithPersonRef {
  _FetchEventWithPersonProviderElement(super.provider);

  @override
  String get eventId => (origin as FetchEventWithPersonProvider).eventId;
}

String _$filteredEventsHash() => r'ee04faa9276dc16b0bb1e5ded6d77af33786ba05';

/// See also [filteredEvents].
@ProviderFor(filteredEvents)
const filteredEventsProvider = FilteredEventsFamily();

/// See also [filteredEvents].
class FilteredEventsFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// See also [filteredEvents].
  const FilteredEventsFamily();

  /// See also [filteredEvents].
  FilteredEventsProvider call(
    List<String> memberIds,
  ) {
    return FilteredEventsProvider(
      memberIds,
    );
  }

  @override
  FilteredEventsProvider getProviderOverride(
    covariant FilteredEventsProvider provider,
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
  String? get name => r'filteredEventsProvider';
}

/// See also [filteredEvents].
class FilteredEventsProvider
    extends AutoDisposeFutureProvider<List<Map<String, dynamic>>> {
  /// See also [filteredEvents].
  FilteredEventsProvider(
    List<String> memberIds,
  ) : this._internal(
          (ref) => filteredEvents(
            ref as FilteredEventsRef,
            memberIds,
          ),
          from: filteredEventsProvider,
          name: r'filteredEventsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$filteredEventsHash,
          dependencies: FilteredEventsFamily._dependencies,
          allTransitiveDependencies:
              FilteredEventsFamily._allTransitiveDependencies,
          memberIds: memberIds,
        );

  FilteredEventsProvider._internal(
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
    FutureOr<List<Map<String, dynamic>>> Function(FilteredEventsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FilteredEventsProvider._internal(
        (ref) => create(ref as FilteredEventsRef),
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
    return _FilteredEventsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredEventsProvider && other.memberIds == memberIds;
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
mixin FilteredEventsRef
    on AutoDisposeFutureProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `memberIds` of this provider.
  List<String> get memberIds;
}

class _FilteredEventsProviderElement
    extends AutoDisposeFutureProviderElement<List<Map<String, dynamic>>>
    with FilteredEventsRef {
  _FilteredEventsProviderElement(super.provider);

  @override
  List<String> get memberIds => (origin as FilteredEventsProvider).memberIds;
}

String _$filteredFeedsHash() => r'0a6a6044a6d46fe8a290302e66287d9f5baedbd5';

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

String _$fetchEventsHash() => r'2e81897dcbdf1990dbbdcab23154cf5cac34f43b';

/// See also [fetchEvents].
@ProviderFor(fetchEvents)
final fetchEventsProvider = AutoDisposeFutureProvider<List<Event>>.internal(
  fetchEvents,
  name: r'fetchEventsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$fetchEventsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FetchEventsRef = AutoDisposeFutureProviderRef<List<Event>>;
String _$fetchEventAttendanceHash() =>
    r'bdb528873350458923378813fce104de43a71729';

/// See also [fetchEventAttendance].
@ProviderFor(fetchEventAttendance)
const fetchEventAttendanceProvider = FetchEventAttendanceFamily();

/// See also [fetchEventAttendance].
class FetchEventAttendanceFamily
    extends Family<AsyncValue<AttendanceUserListModel>> {
  /// See also [fetchEventAttendance].
  const FetchEventAttendanceFamily();

  /// See also [fetchEventAttendance].
  FetchEventAttendanceProvider call({
    required String eventId,
  }) {
    return FetchEventAttendanceProvider(
      eventId: eventId,
    );
  }

  @override
  FetchEventAttendanceProvider getProviderOverride(
    covariant FetchEventAttendanceProvider provider,
  ) {
    return call(
      eventId: provider.eventId,
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
  String? get name => r'fetchEventAttendanceProvider';
}

/// See also [fetchEventAttendance].
class FetchEventAttendanceProvider
    extends AutoDisposeFutureProvider<AttendanceUserListModel> {
  /// See also [fetchEventAttendance].
  FetchEventAttendanceProvider({
    required String eventId,
  }) : this._internal(
          (ref) => fetchEventAttendance(
            ref as FetchEventAttendanceRef,
            eventId: eventId,
          ),
          from: fetchEventAttendanceProvider,
          name: r'fetchEventAttendanceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchEventAttendanceHash,
          dependencies: FetchEventAttendanceFamily._dependencies,
          allTransitiveDependencies:
              FetchEventAttendanceFamily._allTransitiveDependencies,
          eventId: eventId,
        );

  FetchEventAttendanceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.eventId,
  }) : super.internal();

  final String eventId;

  @override
  Override overrideWith(
    FutureOr<AttendanceUserListModel> Function(FetchEventAttendanceRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchEventAttendanceProvider._internal(
        (ref) => create(ref as FetchEventAttendanceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        eventId: eventId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<AttendanceUserListModel> createElement() {
    return _FetchEventAttendanceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchEventAttendanceProvider && other.eventId == eventId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, eventId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchEventAttendanceRef
    on AutoDisposeFutureProviderRef<AttendanceUserListModel> {
  /// The parameter `eventId` of this provider.
  String get eventId;
}

class _FetchEventAttendanceProviderElement
    extends AutoDisposeFutureProviderElement<AttendanceUserListModel>
    with FetchEventAttendanceRef {
  _FetchEventAttendanceProviderElement(super.provider);

  @override
  String get eventId => (origin as FetchEventAttendanceProvider).eventId;
}

String _$fetchMyEventsHash() => r'd6a5700f499a5609986e5681987070f42dfa2cf1';

/// See also [fetchMyEvents].
@ProviderFor(fetchMyEvents)
final fetchMyEventsProvider = AutoDisposeFutureProvider<List<Event>>.internal(
  fetchMyEvents,
  name: r'fetchMyEventsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fetchMyEventsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FetchMyEventsRef = AutoDisposeFutureProviderRef<List<Event>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
