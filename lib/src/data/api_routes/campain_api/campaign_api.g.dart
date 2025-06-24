// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campaign_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$createCampaignHash() => r'757b09840d6576a479cb15a3dac9cf849dedd23a';

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

/// See also [createCampaign].
@ProviderFor(createCampaign)
const createCampaignProvider = CreateCampaignFamily();

/// See also [createCampaign].
class CreateCampaignFamily extends Family<AsyncValue<bool>> {
  /// See also [createCampaign].
  const CreateCampaignFamily();

  /// See also [createCampaign].
  CreateCampaignProvider call({
    required Map<String, dynamic> data,
    BuildContext? context,
  }) {
    return CreateCampaignProvider(
      data: data,
      context: context,
    );
  }

  @override
  CreateCampaignProvider getProviderOverride(
    covariant CreateCampaignProvider provider,
  ) {
    return call(
      data: provider.data,
      context: provider.context,
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
  String? get name => r'createCampaignProvider';
}

/// See also [createCampaign].
class CreateCampaignProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [createCampaign].
  CreateCampaignProvider({
    required Map<String, dynamic> data,
    BuildContext? context,
  }) : this._internal(
          (ref) => createCampaign(
            ref as CreateCampaignRef,
            data: data,
            context: context,
          ),
          from: createCampaignProvider,
          name: r'createCampaignProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$createCampaignHash,
          dependencies: CreateCampaignFamily._dependencies,
          allTransitiveDependencies:
              CreateCampaignFamily._allTransitiveDependencies,
          data: data,
          context: context,
        );

  CreateCampaignProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.data,
    required this.context,
  }) : super.internal();

  final Map<String, dynamic> data;
  final BuildContext? context;

  @override
  Override overrideWith(
    FutureOr<bool> Function(CreateCampaignRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CreateCampaignProvider._internal(
        (ref) => create(ref as CreateCampaignRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        data: data,
        context: context,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _CreateCampaignProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateCampaignProvider &&
        other.data == data &&
        other.context == context;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, data.hashCode);
    hash = _SystemHash.combine(hash, context.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CreateCampaignRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `data` of this provider.
  Map<String, dynamic> get data;

  /// The parameter `context` of this provider.
  BuildContext? get context;
}

class _CreateCampaignProviderElement
    extends AutoDisposeFutureProviderElement<bool> with CreateCampaignRef {
  _CreateCampaignProviderElement(super.provider);

  @override
  Map<String, dynamic> get data => (origin as CreateCampaignProvider).data;
  @override
  BuildContext? get context => (origin as CreateCampaignProvider).context;
}

String _$fetchCampaignsHash() => r'7e3823dc68b1d4cbc3546fc16debbf164f8828ca';

/// See also [fetchCampaigns].
@ProviderFor(fetchCampaigns)
final fetchCampaignsProvider =
    AutoDisposeFutureProvider<List<CampaignModel>>.internal(
  fetchCampaigns,
  name: r'fetchCampaignsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fetchCampaignsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FetchCampaignsRef = AutoDisposeFutureProviderRef<List<CampaignModel>>;
String _$fetchMyCampaignsHash() => r'1dcbe9af8e5d2ba5674638546bdd937b024a6d70';

/// See also [fetchMyCampaigns].
@ProviderFor(fetchMyCampaigns)
final fetchMyCampaignsProvider =
    AutoDisposeFutureProvider<List<CampaignModel>>.internal(
  fetchMyCampaigns,
  name: r'fetchMyCampaignsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fetchMyCampaignsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FetchMyCampaignsRef = AutoDisposeFutureProviderRef<List<CampaignModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
